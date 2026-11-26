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
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
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
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// A community's page. People join it (follow it); vendors list their stores in
/// it, and vendors who are in it get a Discussion button to its group chat.
/// Three tabs: Street (posts tagged to the community), Stores (the stores that
/// are actually listed and approved, filterable by category) and About.
/// Every action uses signed-in database functions. It scrolls itself.
class OrijaCommunity extends StatefulWidget {
  const OrijaCommunity({
    super.key,
    this.width,
    this.height,
    required this.communityId,
    this.embedded = false,
  });

  final double? width;
  final double? height;
  final String? communityId;

  /// True when shown inside another page (the Dashboard tab of a school's
  /// listings page): no back button and no extra status-bar space on top.
  final bool embedded;

  @override
  State<OrijaCommunity> createState() => _OrijaCommunityState();
}

class _OrijaCommunityState extends State<OrijaCommunity> {
  final _db = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  Map<String, dynamic> _d = {};
  int _tab = 0;
  String? _category;
  String _sort = 'top'; // top | new | all
  Map<String, Map<String, dynamic>> _categoryMeta = {};
  // School communities: 'student' or 'nearby' per store id (see
  // get_campus_store_labels). Stores without a label are missing.
  Map<String, String> _campusLabels = {};
  bool _descOpen = false;
  bool _busy = false;
  final Set<String> _busyStores = {};

  Map<String, dynamic> get _community => _d['community'] is Map
      ? Map<String, dynamic>.from(_d['community'] as Map)
      : {};
  Map<String, dynamic> get _viewer =>
      _d['viewer'] is Map ? Map<String, dynamic>.from(_d['viewer'] as Map) : {};
  List<Map<String, dynamic>> get _myStores =>
      ((_viewer['stores'] as List?) ?? const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
  bool get _isMember => _viewer['is_member'] == true;
  bool get _isHead => _viewer['is_head'] == true;
  bool get _isMarket => _community['type'] == 'market';
  String get _id => widget.communityId ?? '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_id.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'No community selected.';
      });
      return;
    }
    try {
      final res = await _db
          .rpc('get_community_page_v3', params: {'p_community_id': _id});
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        final d = Map<String, dynamic>.from(res);
        final storeSlugs = <String>{
          for (final s in ((d['stores'] as List?) ?? const []))
            if ((((s as Map)['category']) as String? ?? '').isNotEmpty)
              '${s['category']}'
        }.toList();
        var meta = <String, Map<String, dynamic>>{};
        if (storeSlugs.isNotEmpty) {
          try {
            final cats = await _db
                .from('categories')
                .select('slug, name, icon_url')
                .inFilter('slug', storeSlugs);
            meta = {
              for (final c in List<Map<String, dynamic>>.from(cats as List))
                '${c['slug']}': c
            };
          } catch (_) {}
        }
        var labels = <String, String>{};
        final community = d['community'] is Map ? d['community'] as Map : {};
        if (community['type'] == 'institution') {
          final ids = [
            for (final s in ((d['stores'] as List?) ?? const []))
              if ((s as Map)['id'] != null) '${s['id']}'
          ];
          if (ids.isNotEmpty) {
            try {
              final res = await _db.rpc('get_campus_store_labels',
                  params: {'p_storefront_ids': ids});
              if (res is Map) {
                res.forEach((k, v) {
                  // Only the label for this school's community.
                  if (v is Map && '${v['community_id']}' == _id) {
                    labels['$k'] = '${v['label']}';
                  }
                });
              }
            } catch (_) {}
          }
        }
        if (!mounted) return;
        setState(() {
          _d = d;
          _categoryMeta = meta;
          _campusLabels = labels;
          _loading = false;
          _error = null;
        });
      } else {
        setState(() {
          _loading = false;
          _error = res is Map
              ? '${res['message'] ?? 'Community not found.'}'
              : 'Community not found.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'No connection. Pull down to try again.';
        });
      }
    }
  }

  // ------------------------------------------------------------- actions

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(msg), backgroundColor: error ? theme.error : null));
  }

  Future<void> _toggleMember() async {
    if (_busy) return;
    if (_isMember) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Leave ${_community['name']}?'),
          content: const Text('You will stop seeing its updates.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Leave')),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _busy = true);
    try {
      final res = await _db.rpc(
          _isMember ? 'leave_community_member' : 'join_community_member',
          params: {'p_community_id': _id});
      final ok = res is Map && res['success'] == true;
      _toast(
          '${res is Map ? (res['message'] ?? (ok ? 'Done.' : 'That did not work.')) : 'That did not work.'}',
          error: !ok);
      if (ok) await _load();
    } catch (_) {
      _toast('No connection. Try again.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleStore(Map<String, dynamic> s) async {
    final sid = '${s['id']}';
    if (_busyStores.contains(sid)) return;
    final linked = s['link_status'] != null;
    if (linked) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Unlink ${s['name']} from this community?'),
          content: const Text(
              'The store leaves the community and its group chat. You can link it again later.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Keep')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Unlink')),
          ],
        ),
      );
      if (ok != true) return;
    }
    setState(() => _busyStores.add(sid));
    try {
      final res = await _db.rpc(
          linked ? 'leave_my_community' : 'join_my_storefront_to_community',
          params: {'p_storefront_id': sid, 'p_community_id': _id});
      final ok = res is Map && res['success'] == true;
      _toast(
          '${res is Map ? (res['message'] ?? (ok ? 'Done.' : 'That did not work.')) : 'That did not work.'}',
          error: !ok);
      if (ok) await _load();
      if (!ok && res is Map && res['upgrade_required'] == true) {
        if (mounted)
          context.pushNamed('subscriptionPage',
              queryParameters: {
                'storefrontid': serializeParam(sid, ParamType.String)
              }.withoutNulls);
      }
    } catch (_) {
      _toast('No connection. Try again.', error: true);
    } finally {
      if (mounted) setState(() => _busyStores.remove(sid));
    }
  }

  void _openDiscussion() {
    final state = (_viewer['discussion'] as Map?)?['state'];
    if (state == 'feature_off') {
      _toast('Group chat is coming soon.');
      return;
    }
    context.pushNamed('groupChat',
        queryParameters: {'communityId': serializeParam(_id, ParamType.String)}
            .withoutNulls);
  }

  void _back() => context.safePop();

  // ------------------------------------------------------------- helpers

  String _compact(num? v) {
    final n = (v ?? 0).toInt();
    if (n >= 1000000)
      return '${(n / 1000000).toStringAsFixed(n % 1000000 == 0 ? 0 : 1)}M';
    if (n >= 1000)
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    return '$n';
  }

  String _month(String? raw) {
    final d = DateTime.tryParse(raw ?? '')?.toLocal();
    if (d == null) return '';
    const m = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${m[d.month - 1]} ${d.year}';
  }

  // ------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 7 (Pattern E group, simple centered
    // treatment). Mobile body below is untouched; this gate is
    // unreachable on a real phone.
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
    if (_loading)
      return Container(
          color: theme.primaryBackground,
          child:
              Center(child: CircularProgressIndicator(color: theme.secondary)));
    if (_error != null) {
      return Container(
        color: theme.primaryBackground,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.groups_outlined, size: 44, color: theme.secondaryText),
              const SizedBox(height: 10),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.primaryText, fontSize: 14)),
              const SizedBox(height: 10),
              Row(mainAxisSize: MainAxisSize.min, children: [
                TextButton(onPressed: _back, child: const Text('Go back')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _loading = true;
                      });
                      _load();
                    },
                    child: const Text('Try again')),
              ]),
            ],
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: theme.primaryBackground,
      child: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(theme),
              _identity(theme),
              _actions(theme),
              // Orija Campus: this community's trade fair, if it has one.
              if (_id.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: OrijaTradeFairCard(communityId: _id),
                ),
              if (_myStores.isNotEmpty) _myStoresCard(theme),
              const SizedBox(height: 14),
              _tabs(theme),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: _tabBody(theme)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(FlutterFlowTheme theme) {
    final c = _community;
    final cover = ((c['cover_url'] as String?) ?? '').isNotEmpty
        ? '${c['cover_url']}'
        : ((c['icon_url'] as String?) ?? '');
    final top = widget.embedded ? 0.0 : MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: widget.embedded ? 150 : 210,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(28))),
            child: cover.isEmpty
                ? Container(
                    color: theme.alternate,
                    child: Icon(Icons.groups,
                        size: 60, color: theme.secondaryText))
                : Image.network(cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: theme.alternate)),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(28)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55)
                  ]),
            ),
          ),
          if (!widget.embedded)
            Positioned(
              top: top + 8,
              left: 16,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _back,
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Color(0x82000000), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 22)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(FlutterFlowTheme theme, String label,
      {IconData? icon, Color? color}) {
    final col = color ?? theme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
          color: col.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: col),
            const SizedBox(width: 3)
          ],
          Text(label,
              style: TextStyle(
                  color: col, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _identity(FlutterFlowTheme theme) {
    final c = _community;
    final counts = _d['counts'] is Map
        ? Map<String, dynamic>.from(_d['counts'] as Map)
        : <String, dynamic>{};
    final desc = ((c['description'] as String?) ?? '').trim();
    final place = [c['city'], c['state']]
        .where((e) => '${e ?? ''}'.trim().isNotEmpty)
        .join(', ');
    final preview = ((_d['members_preview'] as List?) ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final members = (counts['members'] as num?)?.toInt() ?? 0;

    Widget stat(String label, String value) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(children: [
              Text(label,
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
              const SizedBox(height: 3),
              Text(value,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                  child: Text('${c['name']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800))),
              if (c['is_verified'] == true)
                Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Icon(Icons.verified_rounded,
                        size: 20, color: theme.secondary)),
              if (_isHead)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      final saved = await context.pushNamed('EditCommunityPage',
                          queryParameters: {
                            'communityId':
                                serializeParam(_id, ParamType.String),
                          }.withoutNulls);
                      if (saved == true) _load();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.edit_outlined,
                          size: 19, color: theme.secondaryText),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _chip(
                  theme,
                  _isMarket
                      ? 'Market'
                      : (c['type'] == 'institution'
                          ? 'Institution'
                          : 'Community'),
                  icon: _isMarket
                      ? Icons.storefront_outlined
                      : Icons.groups_outlined),
              if (((c['category'] as String?) ?? '').isNotEmpty)
                _chip(theme, '${c['category']}', color: theme.secondaryText),
              if (place.isNotEmpty)
                _chip(theme, place,
                    icon: Icons.place_outlined, color: theme.secondaryText),
              if (_isHead)
                _chip(theme, 'You are the head', icon: Icons.shield_outlined),
            ],
          ),
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => setState(() => _descOpen = !_descOpen),
              child: Text(desc,
                  maxLines: _descOpen ? null : 3,
                  overflow:
                      _descOpen ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: TextStyle(
                      color: theme.secondaryText, fontSize: 13, height: 1.4)),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.alternate)),
            child: Row(children: [
              stat('Members', _compact(counts['members'] as num?)),
              Container(width: 1, height: 30, color: theme.alternate),
              stat('Vendors', _compact(counts['vendors'] as num?)),
              Container(width: 1, height: 30, color: theme.alternate),
              stat('Posts',
                  _compact(((_d['street'] as List?) ?? const []).length)),
            ]),
          ),
          if (preview.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 30.0 +
                      20.0 * (preview.length > 6 ? 5 : preview.length - 1),
                  child: Stack(
                    children: [
                      for (var i = 0; i < preview.length && i < 6; i++)
                        Positioned(
                          left: i * 20.0,
                          child: Container(
                            width: 30,
                            height: 30,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.alternate,
                                border: Border.all(
                                    color: theme.primaryBackground, width: 2)),
                            child: ((preview[i]['avatar_url'] as String?) ?? '')
                                    .isEmpty
                                ? Icon(Icons.person,
                                    size: 15, color: theme.secondaryText)
                                : Image.network('${preview[i]['avatar_url']}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                        Icons.person,
                                        size: 15,
                                        color: theme.secondaryText)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      members > 6
                          ? '${preview.first['name'] ?? 'Someone'} and ${members - 1} others'
                          : (members == 1
                              ? '${preview.first['name'] ?? 'Someone'} is here'
                              : '$members members'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _actions(FlutterFlowTheme theme) {
    final disc = _viewer['discussion'] is Map
        ? Map<String, dynamic>.from(_viewer['discussion'] as Map)
        : <String, dynamic>{};
    final showDisc = disc['visible'] == true;
    final locked = disc['state'] == 'locked';
    final soon = disc['state'] == 'feature_off';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showDisc) ...[
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _openDiscussion,
                icon: Icon(
                    locked ? Icons.lock_outline_rounded : Icons.forum_outlined,
                    size: 20),
                label: Text(
                    soon
                        ? 'Discussion · coming soon'
                        : (locked
                            ? 'Discussion · renew your plan'
                            : 'Discussion'),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: soon ? theme.alternate : theme.secondary,
                  foregroundColor: soon ? theme.secondaryText : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    onPressed: _busy ? null : _toggleMember,
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          _isMember ? Colors.transparent : theme.secondary,
                      foregroundColor:
                          _isMember ? theme.secondary : Colors.white,
                      side: BorderSide(color: theme.secondary, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                    ),
                    child: _busy
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    _isMember ? theme.secondary : Colors.white))
                        : Text(_isMember ? 'Joined' : 'Join community',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              // Market and school heads both manage approvals (agents too).
              if (_isHead &&
                  (_isMarket || _community['type'] == 'institution')) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: () => context.pushNamed(
                          'MarketHeadDashboardPage',
                          queryParameters: {
                            'communityID': serializeParam(_id, ParamType.String)
                          }.withoutNulls),
                      icon: const Icon(Icons.dashboard_outlined, size: 18),
                      label: const Text('Dashboard',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: theme.primaryText,
                          side: BorderSide(color: theme.alternate, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22))),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _myStoresCard(FlutterFlowTheme theme) {
    // School communities are linked automatically, one per person: no "Link your store".
    if (_community['type'] == 'institution') return const SizedBox.shrink();
    final stores = _myStores;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.alternate)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isMarket ? 'Sell in this market' : 'Link your store',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(
                _isMarket
                    ? 'The market head approves stores before they appear.'
                    : 'Link a store here so members can find it and you can join the discussion.',
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 12, height: 1.35)),
            const SizedBox(height: 8),
            for (final s in stores)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: theme.alternate),
                      child: ((s['logo_url'] as String?) ?? '').isEmpty
                          ? Icon(Icons.storefront,
                              size: 17, color: theme.secondaryText)
                          : Image.network('${s['logo_url']}',
                              fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text('${s['name']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600))),
                    Builder(builder: (_) {
                      final ls = s['link_status'];
                      final busy = _busyStores.contains('${s['id']}');
                      final label = ls == 'approved'
                          ? 'Linked'
                          : (ls == 'pending' ? 'Pending' : 'Link store');
                      final on = ls != null;
                      return SizedBox(
                        height: 30,
                        child: OutlinedButton(
                          onPressed: busy ? null : () => _toggleStore(s),
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                on ? Colors.transparent : theme.secondary,
                            foregroundColor:
                                on ? theme.secondary : Colors.white,
                            side:
                                BorderSide(color: theme.secondary, width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(72, 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: busy
                              ? SizedBox(
                                  width: 13,
                                  height: 13,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          on ? theme.secondary : Colors.white))
                              : Text(label,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tabs(FlutterFlowTheme theme) {
    final stores = ((_d['stores'] as List?) ?? const []).length;
    Widget tab(int i, String label) {
      final active = _tab == i;
      return Expanded(
        child: InkWell(
          onTap: () => setState(() => _tab = i),
          child: Column(children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                // Shrinks a long label ("Accommodation") instead of wrapping.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label,
                      maxLines: 1,
                      style: TextStyle(
                          color: active ? theme.secondary : theme.secondaryText,
                          fontSize: 14,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500)),
                )),
            Container(
                height: 2.5,
                color: active ? theme.secondary : Colors.transparent),
          ]),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.alternate))),
      child: Row(children: [
        tab(0, 'Street'),
        // Orija Campus: hostels near the school, from approved agents.
        if (_community['type'] == 'institution') tab(3, 'Accommodation'),
        tab(1, 'Stores ($stores)'),
        tab(2, 'About')
      ]),
    );
  }

  Widget _tabBody(FlutterFlowTheme theme) {
    switch (_tab) {
      case 1:
        return _storesTab(theme);
      case 2:
        return _aboutTab(theme);
      case 3:
        return OrijaHostelsBrowse(communityId: _id);
      default:
        return _streetTab(theme);
    }
  }

  Widget _empty(FlutterFlowTheme theme, IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(children: [
          Icon(icon, size: 40, color: theme.secondaryText),
          const SizedBox(height: 8),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.secondaryText, fontSize: 13.5))
        ]),
      );

  Widget _streetTab(FlutterFlowTheme theme) {
    final ids = ((_d['street'] as List?) ?? const []).map((e) => '$e').toList();
    if (ids.isEmpty)
      return _empty(theme, Icons.forum_outlined,
          'No posts on the street yet.\nPosts tagged to this community show up here.');
    return Column(children: [
      for (final id in ids)
        Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrijaPostCard(key: ValueKey('street_$id'), postId: id))
    ]);
  }

  Widget _storesTab(FlutterFlowTheme theme) {
    var stores = ((_d['stores'] as List?) ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    if (stores.isEmpty)
      return _empty(
          theme,
          Icons.storefront_outlined,
          _isMarket
              ? 'No approved stores in this market yet.'
              : 'No stores are listed here yet.');
    final cats = <String>{
      for (final s in stores)
        if (((s['category'] as String?) ?? '').isNotEmpty) '${s['category']}'
    }.toList()
      ..sort();
    if (_category != null)
      stores = stores.where((s) => s['category'] == _category).toList();
    if (_sort == 'new') {
      stores
          .sort((a, b) => '${b['created_at']}'.compareTo('${a['created_at']}'));
    } else if (_sort == 'top') {
      stores.sort((a, b) => ((b['avg_rating'] as num?) ?? 0)
          .compareTo((a['avg_rating'] as num?) ?? 0));
    }

    Widget pill(String label, bool active, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: active,
            showCheckmark: false,
            selectedColor: theme.secondary,
            backgroundColor: theme.secondaryBackground,
            side: BorderSide(color: active ? theme.secondary : theme.alternate),
            labelStyle: TextStyle(
                color: active ? Colors.white : theme.primaryText,
                fontSize: 12.5,
                fontWeight: FontWeight.w600),
            onSelected: (_) => onTap(),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Grid of categories these stores actually exist in, to make
        // finding a store easier -- taps through to SubList (Stores +
        // Subcategories), scoped to this community. For a market, SubList
        // shows every approved vendor regardless of category (a market's
        // draw is breadth), narrowing by category only applies to the
        // Subcategories tab there.
        if (cats.isNotEmpty) ...[
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final slug = cats[i];
                final meta = _categoryMeta[slug];
                final name = (meta?['name'] as String?) ?? slug;
                final icon = (meta?['icon_url'] as String?) ?? '';
                return SizedBox(
                  width: 72,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.pushNamed('SubList', queryParameters: {
                      'name': name,
                      'categorySlug': slug,
                      'communityID': _id,
                      'communityType': '${_community['type'] ?? ''}',
                    }),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.alternate),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: icon.isEmpty
                              ? Icon(Icons.category_outlined,
                                  color: theme.secondaryText, size: 26)
                              : Image.network(icon,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                      Icons.category_outlined,
                                      color: theme.secondaryText,
                                      size: 26)),
                        ),
                        const SizedBox(height: 6),
                        Text(name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
        ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            pill('Top rated', _sort == 'top',
                () => setState(() => _sort = 'top')),
            pill('New', _sort == 'new', () => setState(() => _sort = 'new')),
            pill('A–Z', _sort == 'all', () => setState(() => _sort = 'all')),
          ]),
        ),
        if (cats.length > 1) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              pill('All categories', _category == null,
                  () => setState(() => _category = null)),
              for (final c in cats)
                pill(
                    c,
                    _category == c,
                    () =>
                        setState(() => _category = _category == c ? null : c)),
            ]),
          ),
        ],
        const SizedBox(height: 12),
        for (final s in (_sort == 'all'
            ? (stores
              ..sort((a, b) => '${a['name']}'
                  .toLowerCase()
                  .compareTo('${b['name']}'.toLowerCase())))
            : stores)) ...[
          _storeTile(theme, s),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _storeTile(FlutterFlowTheme theme, Map<String, dynamic> s) {
    final logo = (s['logo_url'] as String?) ?? '';
    final rating = (s['avg_rating'] as num?)?.toDouble();
    final reviews = (s['total_reviews'] as num?)?.toInt() ?? 0;
    final place = [s['city'], s['state']]
        .where((e) => '${e ?? ''}'.trim().isNotEmpty)
        .join(', ');
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.pushNamed('storefrontPage',
          queryParameters: {
            'storefontslug': serializeParam('${s['slug']}', ParamType.String)
          }.withoutNulls),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.alternate)),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: theme.alternate,
                  borderRadius: BorderRadius.circular(12)),
              child: logo.isEmpty
                  ? Icon(Icons.storefront, color: theme.secondaryText)
                  : Image.network(logo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.storefront, color: theme.secondaryText)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Text('${s['name']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: theme.primaryText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700))),
                      if (s['is_verified'] == true)
                        Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Icons.verified_rounded,
                                size: 15, color: theme.secondary)),
                      if (s['is_head_store'] == true)
                        Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child:
                                _chip(theme, 'Head', color: theme.secondary)),
                      if (_campusLabels['${s['id']}'] != null)
                        Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: _campusLabels['${s['id']}'] == 'student'
                                ? _chip(theme, '✓ Student',
                                    color: theme.success)
                                : _chip(theme, 'Nearby',
                                    color: theme.tertiary)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                      [
                        if (((s['category'] as String?) ?? '').isNotEmpty)
                          '${s['category']}',
                        if (place.isNotEmpty) place
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12)),
                  const SizedBox(height: 3),
                  Row(children: [
                    Icon(Icons.star_rounded, size: 14, color: theme.secondary),
                    const SizedBox(width: 2),
                    Text(
                        rating == null || reviews == 0
                            ? 'New'
                            : '${rating.toStringAsFixed(1)} ($reviews)',
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 10),
                    Icon(Icons.people_outline,
                        size: 14, color: theme.secondaryText),
                    const SizedBox(width: 3),
                    Text('${_compact(s['follower_count'] as num?)} followers',
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 12)),
                  ]),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _aboutTab(FlutterFlowTheme theme) {
    final c = _community;
    final head =
        _d['head'] is Map ? Map<String, dynamic>.from(_d['head'] as Map) : null;
    final rules = ((c['rules'] as List?) ?? const [])
        .map((e) => '${e ?? ''}'.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final tags = ((c['tags'] as List?) ?? const [])
        .map((e) => '$e')
        .where((e) => e.isNotEmpty)
        .toList();
    final desc = ((c['description'] as String?) ?? '').trim();

    Widget card(String title, Widget child) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.alternate)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ]),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (desc.isNotEmpty)
          card(
              'About',
              Text(desc,
                  style: TextStyle(
                      color: theme.secondaryText, fontSize: 13, height: 1.45))),
        if (head != null)
          card(
            _isMarket ? 'Market head' : 'Community head',
            Row(children: [
              Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: theme.alternate),
                child: ((head['avatar_url'] as String?) ?? '').isEmpty
                    ? Icon(Icons.person, color: theme.secondaryText)
                    : Image.network('${head['avatar_url']}', fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${head['name'] ?? ''}',
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      Text(
                          [head['city'], head['state']]
                              .where((e) => '${e ?? ''}'.trim().isNotEmpty)
                              .join(', '),
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 12)),
                    ]),
              ),
            ]),
          ),
        card(
          'Community rules',
          rules.isEmpty
              ? Text('The head has not added rules yet.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 13))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < rules.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 22,
                                  height: 22,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: theme.secondary
                                          .withValues(alpha: 0.15),
                                      shape: BoxShape.circle),
                                  child: Text('${i + 1}',
                                      style: TextStyle(
                                          color: theme.secondary,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800))),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(rules[i],
                                      style: TextStyle(
                                          color: theme.primaryText,
                                          fontSize: 13,
                                          height: 1.4))),
                            ]),
                      ),
                  ],
                ),
        ),
        card(
          'Details',
          Column(children: [
            _detail(
                theme,
                Icons.category_outlined,
                'Type',
                _isMarket
                    ? 'Market'
                    : (c['type'] == 'institution'
                        ? 'Institution'
                        : 'Community')),
            if (((c['category'] as String?) ?? '').isNotEmpty)
              _detail(
                  theme, Icons.sell_outlined, 'Category', '${c['category']}'),
            if (((c['address_line'] as String?) ?? '').isNotEmpty)
              _detail(theme, Icons.place_outlined, 'Location',
                  '${c['address_line']}'),
            if (_month(c['created_at'] as String?).isNotEmpty)
              _detail(theme, Icons.event_outlined, 'Started',
                  _month(c['created_at'] as String?)),
            _detail(theme, Icons.lock_open_outlined, 'Access',
                c['is_public'] == false ? 'Private' : 'Open to everyone'),
          ]),
        ),
        if (tags.isNotEmpty)
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final t in tags)
              _chip(theme, '#$t', color: theme.secondaryText)
          ]),
      ],
    );
  }

  Widget _detail(
          FlutterFlowTheme theme, IconData icon, String label, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          Icon(icon, size: 18, color: theme.secondaryText),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
          const Spacer(),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600))),
        ]),
      );
}
