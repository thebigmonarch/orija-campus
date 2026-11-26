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

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Communities worth linking a store to, matched on the store's category and
/// area. Joining and linking are different things: JOIN makes you a member,
/// LINK makes your store a vendor there. Each suggestion offers "Join & Link",
/// which does both at once; a community you already belong to just offers
/// "Link". Every action uses signed-in database functions that check you own the
/// store and enforce the plan (a market's head still approves a link).
///
/// It does not scroll on its own, so it can sit inside another page.
class OrijaSuggestedCommunities extends StatefulWidget {
  const OrijaSuggestedCommunities({
    super.key,
    this.width,
    this.height,
    required this.storeId,
    this.limit,
    this.excludeJoined,
    this.onChanged,
  });

  final double? width;
  final double? height;
  final String? storeId;
  final int? limit;

  /// Leave out communities the owner already belongs to (a page that lists those separately).
  final bool? excludeJoined;

  /// Called after a store was linked, so a surrounding page can refresh.
  final VoidCallback? onChanged;

  @override
  State<OrijaSuggestedCommunities> createState() =>
      _OrijaSuggestedCommunitiesState();
}

class _OrijaSuggestedCommunitiesState extends State<OrijaSuggestedCommunities> {
  final _db = Supabase.instance.client;
  bool _loading = true;
  List<Map<String, dynamic>> _items = [];
  String? _busyId;
  String? _notice;
  bool _noticeError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant OrijaSuggestedCommunities old) {
    super.didUpdateWidget(old);
    if (old.storeId != widget.storeId) _load();
  }

  Future<void> _load() async {
    final id = widget.storeId ?? '';
    if (id.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final res = await _db.rpc('suggest_communities_for_store',
          params: {'p_storefront_id': id, 'p_limit': widget.limit ?? 8});
      if (!mounted) return;
      setState(() {
        _items = res is List
            ? res
                .map((e) => Map<String, dynamic>.from(e as Map))
                .where((e) =>
                    !(widget.excludeJoined == true && e['joined'] == true))
                // School communities are linked automatically, one per person: no Join & Link.
                .where((e) => e['type'] != 'institution')
                .toList()
            : [];
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _plainMessage(Map d) {
    switch (d['code']) {
      case 'NO_ACTIVE_SUBSCRIPTION':
        return 'This store needs an active plan to link to communities.';
      case 'PLAN_NO_COMMUNITY_ACCESS':
        return 'Your current plan does not include community links.';
      case 'COMMUNITY_SLOTS_EXCEEDED':
        return 'All your community slots are in use. Unlink one to link another.';
    }
    final m = d['message'];
    return m is String && m.isNotEmpty ? m : 'Something went wrong. Try again.';
  }

  Future<void> _act(Map<String, dynamic> c) async {
    final cid = '${c['id']}';
    if (_busyId != null) return;
    setState(() {
      _busyId = cid;
      _notice = null;
    });
    Map<String, dynamic> d;
    try {
      final res = await _db.rpc('join_and_link_community',
          params: {'p_storefront_id': widget.storeId, 'p_community_id': cid});
      d = res is Map ? Map<String, dynamic>.from(res) : {'success': false};
    } catch (_) {
      d = {'success': false, 'message': 'Check your connection and try again.'};
    }
    if (!mounted) return;
    final ok = d['success'] == true;
    setState(() {
      _busyId = null;
      _noticeError = !ok;
      // The server's own text says what happened; only plan problems are reworded.
      _notice = ok
          ? '${d['message']}'
          : (d['joined'] == true ? '${d['message']}' : _plainMessage(d));
    });
    if (ok || d['joined'] == true) {
      await _load();
      if (ok) widget.onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    if (_loading) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2))));
    }
    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
            'No suggestions right now. Find communities from Explore, then link your store here.',
            style:
                TextStyle(color: t.secondaryText, fontSize: 13, height: 1.4)),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_notice != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: (_noticeError ? t.error : t.success)
                    .withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(10)),
            child: Text(_notice!,
                style: TextStyle(
                    color: t.primaryText, fontSize: 12.5, height: 1.35)),
          ),
        for (final c in _items) ...[
          _row(t, c),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _row(FlutterFlowTheme t, Map<String, dynamic> c) {
    final image = ((c['cover_url'] as String?) ?? '').isNotEmpty
        ? '${c['cover_url']}'
        : ((c['icon_url'] as String?) ?? '');
    final joined = c['joined'] == true;
    final market = c['type'] == 'market';
    final busy = _busyId == '${c['id']}';
    final where = [c['city'], c['state']]
        .where((e) => '${e ?? ''}'.trim().isNotEmpty)
        .join(', ');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: t.alternate)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: image.isEmpty
                      ? Container(
                          color: t.alternate,
                          child: Icon(Icons.groups, color: t.secondaryText))
                      : Image.network(image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: t.alternate)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                            child: Text('${c['name']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: t.primaryText,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700))),
                        if (c['is_verified'] == true)
                          Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(Icons.verified_rounded,
                                  size: 15, color: t.secondary)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        '${(c['member_count'] as num?)?.toInt() ?? 0} members',
                        '${(c['vendor_count'] as num?)?.toInt() ?? 0} vendors',
                        if (where.isNotEmpty) where
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: t.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _pill('${c['reason']}', t.secondary),
              if (market) _pill('Market · head approves', t.info),
              if (joined) _pill('You are a member', t.success),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: busy || _busyId != null ? null : () => _act(c),
              icon: busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Icon(joined ? Icons.link_rounded : Icons.group_add_outlined,
                      size: 18),
              label: Text(
                  joined
                      ? (market ? 'Apply to link' : 'Link my store')
                      : (market ? 'Join & apply to link' : 'Join & Link'),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: t.alternate,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
      );
}
