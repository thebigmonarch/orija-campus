// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Body of the Oja Rank page, in two tabs:
///  - My Rank: the profile card, progress to the next tier and the tier
///    ladder (what the page already showed).
///  - Progress Path: everything that earns or costs points -- read from
///    the oja_rank_events catalog (the same labels the "+N Oja Points"
///    notifications use), with how many times YOU earned each, this week's
///    total and your recent point activity.
/// It scrolls itself (a segmented switch, not a TabBarView).
class OrijaOjaRank extends StatefulWidget {
  const OrijaOjaRank({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaOjaRank> createState() => _OrijaOjaRankState();
}

class _OrijaOjaRankState extends State<OrijaOjaRank> {
  int _tab = 0;
  bool _loading = true;
  bool _failed = false;
  Map<String, dynamic>? _board;
  Map<String, dynamic>? _path;

  static const _categoryOrder = [
    'selling',
    'buying',
    'content',
    'community',
    'trust',
    'logistics',
    'penalty',
  ];
  static const _categoryTitle = {
    'selling': 'Selling',
    'buying': 'Buying',
    'content': 'Posting',
    'community': 'Community',
    'trust': 'Trust & verification',
    'logistics': 'Deliveries',
    'penalty': 'What costs you points',
  };
  static const _categoryIcon = {
    'selling': Icons.storefront_outlined,
    'buying': Icons.shopping_bag_outlined,
    'content': Icons.edit_note_rounded,
    'community': Icons.groups_2_outlined,
    'trust': Icons.verified_user_outlined,
    'logistics': Icons.local_shipping_outlined,
    'penalty': Icons.warning_amber_rounded,
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final supabase = Supabase.instance.client;
      final board = await supabase
          .rpc('get_oja_leaderboard', params: {'p_user_id': currentUserUid});
      final path = await supabase
          .rpc('get_oja_progress_path', params: {'p_user_id': currentUserUid});
      if (!mounted) return;
      setState(() {
        _board = Map<String, dynamic>.from(board as Map);
        _path = Map<String, dynamic>.from(path as Map);
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  String _num(num? v) {
    final s = (v ?? 0).round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String _timeAgo(String? iso) {
    final t = DateTime.tryParse(iso ?? '')?.toLocal();
    if (t == null) return '';
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays < 7) return '${d.inDays}d ago';
    return '${(d.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 8 (Pattern D bulk pass). Mobile body
    // below is untouched; this gate is unreachable on a real phone.
    if (OrijaDesktopShell.isDesktop(context)) {
      return OrijaDesktopShell(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _mobileBody(context),
          ),
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }
    if (_failed || _board == null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.cloud_off_rounded, size: 40, color: theme.secondaryText),
            const SizedBox(height: 10),
            Text('Couldn\'t load your rank.',
                style: TextStyle(color: theme.secondaryText)),
            TextButton(onPressed: _load, child: const Text('Try again')),
          ],
        ),
      );
    }
    // Scrolls itself: the page's own scroll view was part of the node this
    // widget replaced, so without this the page can't scroll.
    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _switcher(theme),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey(_tab),
                child: _tab == 0 ? _myRank(theme) : _progressPath(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switcher(FlutterFlowTheme theme) {
    Widget seg(int i, String label) {
      final on = _tab == i;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _tab = i),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: on ? theme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                    color: on ? Colors.white : theme.secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Row(children: [seg(0, 'My Rank'), seg(1, 'Progress Path')]),
    );
  }

  // ------------------------------------------------------------- My Rank

  Widget _myRank(FlutterFlowTheme theme) {
    final user = Map<String, dynamic>.from(_board!['user'] as Map? ?? {});
    final tiers = List<Map<String, dynamic>>.from(
        (_board!['tiers'] as List? ?? [])
            .map((t) => Map<String, dynamic>.from(t)));
    final avatar = user['avatar_url'] as String? ?? '';
    final name = [user['first_name'], user['last_name']]
        .where((e) => e != null && (e as String).isNotEmpty)
        .join(' ');
    final points = (user['oja_points'] as num?) ?? 0;
    final next = user['oja_tier_points_next'] as num?;
    final toNext = user['points_to_next_tier'] as num?;
    final pct =
        ((user['progress_pct'] as num?) ?? 0).toDouble().clamp(0.0, 1.0);
    final nextTitle = user['oja_tier_next_title'] as String?;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.alternate),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.alternate,
                      backgroundImage:
                          avatar.isNotEmpty ? NetworkImage(avatar) : null,
                      child: avatar.isEmpty
                          ? Icon(Icons.person, color: theme.secondaryText)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name.isEmpty ? 'You' : name,
                              style: TextStyle(
                                  color: theme.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          Text(user['oja_tier_title'] as String? ?? '',
                              style: TextStyle(
                                  color: theme.secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_num(points),
                            style: TextStyle(
                                color: theme.primary,
                                fontSize: 24,
                                fontWeight: FontWeight.w800)),
                        Text('Oja Points',
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (next != null) ...[
                  Row(
                    children: [
                      Text(_num(user['oja_tier_points_start'] as num?),
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 11.5)),
                      const Spacer(),
                      Text('${nextTitle ?? 'Next'} · ${_num(next)}',
                          style: TextStyle(
                              color: theme.secondary,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 10,
                      backgroundColor: theme.alternate,
                      color: theme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${_num(toNext)} points to $nextTitle',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                ] else
                  Text('You\'ve reached the top rank.',
                      style: TextStyle(
                          color: theme.secondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => setState(() => _tab = 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt_rounded, size: 16, color: theme.tertiary),
                      const SizedBox(width: 4),
                      Text('See how to earn more points',
                          style: TextStyle(
                              color: theme.primary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Rank ladder',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.alternate),
            ),
            child: Column(
              children: [
                for (var i = 0; i < tiers.length; i++)
                  _tierRow(theme, tiers[i], isLast: i == tiers.length - 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tierRow(FlutterFlowTheme theme, Map<String, dynamic> t,
      {required bool isLast}) {
    final current = t['is_current'] == true;
    final unlocked = t['is_unlocked'] == true;
    final max = t['points_max'] as num?;
    final range = max == null
        ? '${_num(t['points_min'] as num?)}+ pts'
        : '${_num(t['points_min'] as num?)} – ${_num(max)} pts';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: current
                        ? theme.primary
                        : (unlocked ? theme.secondary : theme.alternate),
                    boxShadow: current
                        ? [
                            BoxShadow(
                                color: theme.primary.withValues(alpha: 0.35),
                                blurRadius: 10)
                          ]
                        : null,
                  ),
                  child: Icon(
                      unlocked
                          ? Icons.check_rounded
                          : Icons.lock_outline_rounded,
                      size: 15,
                      color: unlocked ? Colors.white : theme.secondaryText),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: unlocked && !current
                          ? theme.secondary
                          : theme.alternate,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text('Tier ${t['tier']}: ${t['name']}',
                            style: TextStyle(
                                color: unlocked
                                    ? theme.primaryText
                                    : theme.secondaryText,
                                fontSize: 13.5,
                                fontWeight: current
                                    ? FontWeight.w800
                                    : FontWeight.w600)),
                      ),
                      if (current) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                              color: theme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text('You are here',
                              style: TextStyle(
                                  color: theme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  Text(range,
                      style: TextStyle(
                          color: theme.secondaryText, fontSize: 11.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------- Progress Path

  Widget _progressPath(FlutterFlowTheme theme) {
    final events = List<Map<String, dynamic>>.from(
        (_path?['events'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e)));
    final recent = List<Map<String, dynamic>>.from(
        (_path?['recent'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e)));
    final week = (_path?['week_points'] as num?) ?? 0;
    final byCategory = <String, List<Map<String, dynamic>>>{};
    for (final e in events) {
      byCategory
          .putIfAbsent(e['category'] as String? ?? 'community', () => [])
          .add(e);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [theme.secondary, theme.primary]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up_rounded,
                    color: Colors.white, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${week >= 0 ? '+' : ''}${_num(week)} points this week',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      Text(
                          'Everything below adds to your Oja Rank. You get a '
                          'notification every time you earn points.',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              height: 1.35)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (final cat in _categoryOrder)
            if (byCategory[cat] != null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(_categoryIcon[cat] ?? Icons.star_outline,
                      size: 18,
                      color: cat == 'penalty' ? theme.error : theme.primary),
                  const SizedBox(width: 8),
                  Text(_categoryTitle[cat] ?? cat,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.alternate),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < byCategory[cat]!.length; i++) ...[
                      if (i > 0) Divider(height: 1, color: theme.alternate),
                      _eventRow(theme, byCategory[cat]![i]),
                    ],
                  ],
                ),
              ),
            ],
          const SizedBox(height: 22),
          Text('Recent activity',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.alternate),
            ),
            child: recent.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                        'No points yet. Pick something above to get started.',
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 13)),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < recent.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: theme.alternate),
                        _recentRow(theme, recent[i]),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _pointsChip(FlutterFlowTheme theme, num delta) {
    final neg = delta < 0;
    final color = neg ? theme.error : theme.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12)),
      child: Text('${neg ? '' : '+'}${_num(delta)}',
          style: TextStyle(
              color: color, fontSize: 12.5, fontWeight: FontWeight.w800)),
    );
  }

  Widget _eventRow(FlutterFlowTheme theme, Map<String, dynamic> e) {
    final count = (e['earned_count'] as num?)?.toInt() ?? 0;
    final total = (e['earned_points'] as num?) ?? 0;
    final penalty = ((e['delta'] as num?) ?? 0) < 0;
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['label'] as String? ?? '',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(e['description'] as String? ?? '',
                    style: TextStyle(
                        color: theme.secondaryText, fontSize: 12, height: 1.3)),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8,
                  children: [
                    Text(e['cadence'] as String? ?? '',
                        style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 11,
                            fontStyle: FontStyle.italic)),
                    if (count > 0)
                      Text(
                          '${penalty ? 'Happened' : 'Earned'} ×$count · '
                          '${total >= 0 ? '+' : ''}${_num(total)} pts',
                          style: TextStyle(
                              color: penalty ? theme.error : theme.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _pointsChip(theme, (e['delta'] as num?) ?? 0),
        ],
      ),
    );
  }

  Widget _recentRow(FlutterFlowTheme theme, Map<String, dynamic> r) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r['label'] as String? ?? '',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Text(_timeAgo(r['created_at'] as String?),
                    style: TextStyle(color: theme.secondaryText, fontSize: 11)),
              ],
            ),
          ),
          _pointsChip(theme, (r['delta'] as num?) ?? 0),
        ],
      ),
    );
  }
}
