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
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';

/// Link a storefront to communities.
///
/// Shows the storefront's plan and how many community slots it has used, the
/// communities it is already in (with approval status and a Leave button) and
/// the communities the owner belongs to that it can still join.
///
/// Joining and leaving go through `join_my_storefront_to_community` and
/// `leave_my_community`, which use the signed-in user's identity and enforce
/// the plan (active plan, slot limit, market rules). The server's plan
/// messages talk about upgrading; here they are replaced with neutral wording
/// so the same screen is safe in the iOS and Android builds.
///
/// A physical store's own market is shown as its home market and can't be left
/// from here (switching markets is a separate, approved request).
class OrijaConnectStorefront extends StatefulWidget {
  const OrijaConnectStorefront({
    super.key,
    this.width,
    this.height,
    required this.storeId,
  });

  final double? width;
  final double? height;
  final String? storeId;

  @override
  State<OrijaConnectStorefront> createState() => _OrijaConnectStorefrontState();
}

class _OrijaConnectStorefrontState extends State<OrijaConnectStorefront> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  Map<String, dynamic> _store = {};
  Map<String, dynamic> _access = {};
  List<Map<String, dynamic>> _linked = [];
  List<Map<String, dynamic>> _available = [];
  String? _busyId;
  String? _notice;
  bool _noticeIsError = false;
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.storeId;
    if (id == null || id.isEmpty) {
      setState(() {
        _error = 'No storefront selected.';
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = _store.isEmpty;
      _error = null;
    });
    try {
      final store = await _client
          .from('storefronts')
          .select('id, name, owner_id, market_community_id, storefront_type')
          .eq('id', id)
          .maybeSingle();
      if (store == null || store['owner_id'] != currentUserUid) {
        setState(() {
          _error = 'This storefront is not yours to manage.';
          _loading = false;
        });
        return;
      }

      final access = await _client
          .rpc('get_seller_access', params: {'p_storefront_id': id});

      final links = await _client
          .from('community_storefronts')
          .select('community_id, approval_status, rejected_reason')
          .eq('storefront_id', id);
      final visibleLinks = [
        for (final l in links)
          if (['approved', 'pending', 'rejected']
              .contains('${l['approval_status']}'))
            Map<String, dynamic>.from(l),
      ];

      final members = await _client
          .from('community_members_view')
          .select(
              'community_id, community_name, community_type, community_cover_url, community_icon_url, member_count, community_city, community_state')
          .eq('user_id', currentUserUid);

      final linkedIds = {for (final l in visibleLinks) '${l['community_id']}'};
      final ids = linkedIds.toList();
      final byId = <String, Map<String, dynamic>>{};
      if (ids.isNotEmpty) {
        final comms = await _client
            .from('communities')
            .select('id, name, type, cover_url, icon_url, member_count')
            .inFilter('id', ids);
        for (final c in comms) {
          byId['${c['id']}'] = Map<String, dynamic>.from(c);
        }
      }

      if (!mounted) return;
      setState(() {
        _store = Map<String, dynamic>.from(store);
        _access = access is Map ? Map<String, dynamic>.from(access) : {};
        _linked = [
          for (final l in visibleLinks)
            {...l, 'community': byId['${l['community_id']}'] ?? const {}},
        ];
        final seen = <String>{};
        _available = [
          for (final m in members)
            // School communities are linked automatically, one per person.
            if (!linkedIds.contains('${m['community_id']}') &&
                '${m['community_type']}' != 'institution' &&
                seen.add('${m['community_id']}'))
              Map<String, dynamic>.from(m),
        ];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load this screen. Check your connection.';
        _loading = false;
      });
    }
  }

  String _message(Map<String, dynamic> d) {
    switch (d['code']) {
      case 'NO_ACTIVE_SUBSCRIPTION':
        return 'This storefront needs an active plan to link to communities.';
      case 'PLAN_NO_COMMUNITY_ACCESS':
        return 'Your current plan does not include community links.';
      case 'COMMUNITY_SLOTS_EXCEEDED':
        return 'All your community slots are in use. Unlink one to link another.';
      case 'PLAN_NOT_FOUND':
        return 'We could not check your plan right now. Try again later.';
    }
    final m = d['message'];
    return m is String && m.isNotEmpty ? m : 'Something went wrong. Try again.';
  }

  Future<void> _join(String communityId) async {
    setState(() {
      _busyId = communityId;
      _notice = null;
    });
    Map<String, dynamic> d;
    try {
      final res = await _client.rpc('join_my_storefront_to_community', params: {
        'p_storefront_id': widget.storeId,
        'p_community_id': communityId,
      });
      d = res is Map ? Map<String, dynamic>.from(res) : {'success': false};
    } catch (_) {
      d = {'success': false, 'message': 'Check your connection and try again.'};
    }
    if (!mounted) return;
    setState(() {
      _busyId = null;
      _noticeIsError = d['success'] != true;
      _notice = _message(d);
    });
    if (d['success'] == true) _load();
  }

  Future<void> _leave(Map<String, dynamic> link) async {
    final t = FlutterFlowTheme.of(context);
    final name = '${(link['community'] as Map)['name'] ?? 'this community'}';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Unlink $name?',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        content: Text(
            'Your storefront will be removed from this community and its group chat. You stay a member of the community.',
            style: TextStyle(color: t.secondaryText, fontSize: 13.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Stay', style: TextStyle(color: t.secondaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Unlink',
                style: TextStyle(color: t.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final communityId = '${link['community_id']}';
    setState(() {
      _busyId = communityId;
      _notice = null;
    });
    Map<String, dynamic> d;
    try {
      final res = await _client.rpc('leave_my_community', params: {
        'p_storefront_id': widget.storeId,
        'p_community_id': communityId,
      });
      d = res is Map ? Map<String, dynamic>.from(res) : {'success': false};
    } catch (_) {
      d = {'success': false, 'message': 'Check your connection and try again.'};
    }
    if (!mounted) return;
    setState(() {
      _busyId = null;
      _noticeIsError = d['success'] != true;
      _notice = _message(d);
    });
    if (d['success'] == true) _load();
  }

  Future<void> _openJoinByCode() async {
    final id = widget.storeId;
    if (id == null || id.isEmpty) return;
    final res = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _JoinByCodeSheet(storefrontId: id),
    );
    if (res == null || !mounted) return;
    setState(() {
      _noticeIsError = false;
      _notice =
          'Application sent to ${res['community_name'] ?? 'the market'} -- waiting for the market head to approve.';
    });
    _load();
  }

  // ------------------------------------------------------------------- UI

  Widget _pill(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
      );

  Widget _avatar(FlutterFlowTheme t, Map c) {
    final url = (c['icon_url'] ??
        c['cover_url'] ??
        c['community_icon_url'] ??
        c['community_cover_url']) as String?;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 46,
        height: 46,
        color: t.primaryBackground,
        child: (url ?? '').isEmpty
            ? Icon(Icons.groups_rounded, color: t.secondaryText)
            : Image.network(url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.groups_rounded, color: t.secondaryText)),
      ),
    );
  }

  Widget _card(FlutterFlowTheme t, {required Widget child}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.alternate),
          ),
          child: child,
        ),
      );

  Widget _heading(FlutterFlowTheme t, String text, {String? sub}) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            if (sub != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(sub,
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
              ),
          ],
        ),
      );

  Widget _linkedRow(FlutterFlowTheme t, Map<String, dynamic> l) {
    final c = Map<String, dynamic>.from(l['community'] as Map);
    final id = '${l['community_id']}';
    final status = '${l['approval_status']}';
    final home = id == '${_store['market_community_id']}';
    final busy = _busyId == id;

    return _card(
      t,
      child: Row(children: [
        _avatar(t, c),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${c['name'] ?? 'Community'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Wrap(spacing: 6, runSpacing: 4, children: [
                if (c['type'] == 'market') _pill('Market', t.secondary),
                if (home) _pill('Home market', t.tertiary),
                if (status == 'approved') _pill('Approved', t.success),
                if (status == 'pending') _pill('Waiting for approval', t.info),
                if (status == 'rejected') _pill('Not approved', t.error),
              ]),
              if (status == 'rejected' &&
                  '${l['rejected_reason'] ?? ''}'.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${l['rejected_reason']}',
                      style: TextStyle(color: t.secondaryText, fontSize: 12)),
                ),
            ],
          ),
        ),
        if (!home)
          busy
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: t.secondary))
              : TextButton(
                  onPressed: () => _leave(l),
                  child: Text('Unlink', style: TextStyle(color: t.error)),
                ),
      ]),
    );
  }

  Widget _availableRow(FlutterFlowTheme t, Map<String, dynamic> m) {
    final id = '${m['community_id']}';
    final isMarket = m['community_type'] == 'market';
    final busy = _busyId == id;
    final where = [m['community_city'], m['community_state']]
        .where((e) => '${e ?? ''}'.isNotEmpty)
        .join(', ');

    return _card(
      t,
      child: Row(children: [
        _avatar(t, m),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${m['community_name'] ?? 'Community'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(
                  [
                    '${m['member_count'] ?? 0} members',
                    if (where.isNotEmpty) where,
                    if (isMarket) 'Needs the market head\'s approval',
                  ].join(' · '),
                  style: TextStyle(
                      color: t.secondaryText, fontSize: 12, height: 1.3)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: busy ? null : () => _join(id),
            style: ElevatedButton.styleFrom(
              backgroundColor: t.secondary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(isMarket ? 'Apply to link' : 'Link'),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);

    if (_loading) {
      return Container(
        color: t.primaryBackground,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: t.secondary),
      );
    }
    if (_error != null) {
      return Container(
        color: t.primaryBackground,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.primaryText, fontSize: 14.5)),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.goNamed('HomePage'),
            child: const Text('Go back'),
          ),
        ]),
      );
    }

    final used = _access['community_slots_used'];
    final max = _access['community_slots_max'];
    final hasPlan = _access['has_active_plan'] == true;
    final planName = _access['plan_name'];
    final slotLine = !hasPlan
        ? 'This storefront has no active plan, so it cannot link to communities.'
        : (max is num && max > 0
            ? '${planName ?? 'Your plan'} · $used of $max community slots used'
            : '${planName ?? 'Your plan'} does not include community links.');

    return Container(
      color: t.primaryBackground,
      child: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
            child: Row(children: [
              IconButton(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.goNamed('HomePage'),
                icon: Icon(Icons.arrow_back_rounded, color: t.primaryText),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Link to communities',
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w800)),
                    Text('${_store['name'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: t.secondaryText, fontSize: 12.5)),
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
            child: RefreshIndicator(
              color: t.secondary,
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                children: [
                  InkWell(
                    onTap: _openJoinByCode,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: t.secondaryBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: t.secondary.withValues(alpha: 0.4)),
                      ),
                      child: Row(children: [
                        Icon(Icons.qr_code_2_rounded,
                            color: t.secondary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Have a stall code?',
                                  style: TextStyle(
                                      color: t.primaryText,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700)),
                              Text('Link your storefront as a verified vendor',
                                  style: TextStyle(
                                      color: t.secondaryText, fontSize: 11.5)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: t.secondaryText),
                      ]),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: (hasPlan ? t.secondary : t.warning)
                          .withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      Icon(
                          hasPlan
                              ? Icons.workspace_premium_outlined
                              : Icons.info_outline_rounded,
                          color: hasPlan ? t.secondary : t.warning,
                          size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(slotLine,
                            style: TextStyle(
                                color: t.primaryText,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                  if (_notice != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_noticeIsError ? t.error : t.success)
                            .withValues(alpha: 0.11),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_notice!,
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 12.5,
                              height: 1.35)),
                    ),
                  ],
                  _heading(t, 'Linked',
                      sub: _linked.isEmpty
                          ? null
                          : 'Communities this storefront appears in'),
                  if (_linked.isEmpty)
                    Text('Not linked to any community yet.',
                        style: TextStyle(color: t.secondaryText, fontSize: 13))
                  else
                    for (final l in _linked) _linkedRow(t, l),
                  _heading(t, 'Suggested for your store',
                      sub:
                          'Joining makes you a member. Linking makes your store a vendor there. Join & Link does both.'),
                  OrijaSuggestedCommunities(
                    key: ValueKey('suggested_$_tick'),
                    storeId: widget.storeId,
                    limit: 8,
                    excludeJoined: true,
                    onChanged: () {
                      setState(() => _tick++);
                      _load();
                    },
                  ),
                  if (_available.isNotEmpty) ...[
                    _heading(t, 'Communities you are in',
                        sub:
                            'You are already a member. Link your store to become a vendor there.'),
                    for (final m in _available) _availableRow(t, m),
                  ],
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════ join-by-code sheet

/// "Have a stall code?" — redeems a physical QR-sticker code from a market
/// walkthrough and drops this storefront straight into that market's pending
/// queue, skipping search entirely. The market head still approves every
/// applicant (see join_market_by_code) -- this only removes the friction of
/// finding the right community.
class _JoinByCodeSheet extends StatefulWidget {
  const _JoinByCodeSheet({required this.storefrontId});
  final String storefrontId;

  @override
  State<_JoinByCodeSheet> createState() => _JoinByCodeSheetState();
}

class _JoinByCodeSheetState extends State<_JoinByCodeSheet> {
  final _client = Supabase.instance.client;
  final _codeCtrl = TextEditingController();
  final _referCtrl = TextEditingController();
  Timer? _referDebounce;
  List<Map<String, dynamic>> _referResults = [];
  Map<String, dynamic>? _referPicked;

  String? _photoUrl;
  bool _uploadingPhoto = false;
  bool _submitting = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    // Abandoned without submitting: the stall photo (if any) was uploaded
    // this session and is now an orphan on Cloudinary.
    if (!_submitted && _photoUrl != null) {
      Supabase.instance.client.functions.invoke('cloudinary-delete', body: {
        'urls': [_photoUrl]
      }).then((_) {}, onError: (_) {});
    }
    _codeCtrl.dispose();
    _referCtrl.dispose();
    _referDebounce?.cancel();
    super.dispose();
  }

  /// Uploads through the same shared action Create Post uses
  /// (pickUploadCloudinaryMedia) instead of a private reimplementation --
  /// gets client-side resize and the standard q_auto,f_auto transformation
  /// for free.
  Future<void> _pickPhoto() async {
    final selected = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
      imageQuality: 85,
    );
    if (selected == null || selected.isEmpty) return;
    setState(() {
      _uploadingPhoto = true;
      _error = null;
    });
    try {
      final file = selected.first;
      final res = await pickUploadCloudinaryMedia(
        [
          FFUploadedFile(
            name: file.originalFilename.isNotEmpty
                ? file.originalFilename
                : 'stall.jpg',
            bytes: file.bytes,
          )
        ],
        null,
        false,
        'market_application',
        1600,
        85,
        0,
      );
      final urls = List<String>.from((res as Map)['mediaUrls'] as List? ?? []);
      if (urls.isEmpty) throw Exception('no url');
      if (!mounted) return;
      setState(() => _photoUrl = urls.first);
    } catch (_) {
      if (mounted) {
        setState(() => _error = "Couldn't upload the photo. Try again.");
      }
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  void _onReferChanged(String v) {
    _referPicked = null;
    _referDebounce?.cancel();
    final q = v.trim();
    if (q.length < 2) {
      setState(() => _referResults = []);
      return;
    }
    _referDebounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final rows = await _client
            .from('storefronts')
            .select('id, name, logo_url')
            .ilike('name', '%$q%')
            .eq('is_active', true)
            .limit(6);
        if (!mounted) return;
        setState(() =>
            _referResults = List<Map<String, dynamic>>.from(rows as List));
      } catch (_) {}
    });
  }

  Future<void> _submit() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'Enter the code from your stall sticker.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final res = await _client.rpc('join_market_by_code', params: {
        'p_storefront_id': widget.storefrontId,
        'p_code': code,
        'p_photo_url': _photoUrl,
        'p_referred_by_storefront_id': _referPicked?['id'],
      });
      final d =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (!mounted) return;
      if (d['success'] == true) {
        _submitted = true;
        Navigator.of(context).pop(d);
        return;
      }
      setState(
          () => _error = _codeErrorMessage('${d['code'] ?? ''}', d['message']));
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Check your connection and try again.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _codeErrorMessage(String code, Object? fallback) {
    switch (code) {
      case 'CODE_INVALID':
        return "That code wasn't found. Double-check the letters and numbers on your sticker.";
      case 'CODE_ALREADY_USED':
        return 'This code has already been used by another storefront.';
      case 'CODE_REVOKED':
        return 'This code is no longer valid. Ask the market head for a new one.';
      case 'MARKET_UNAVAILABLE':
        return 'This market is not accepting applications right now.';
      case 'ALREADY_APPLIED':
        return 'This storefront already has an application or membership in that market.';
      case 'FORBIDDEN':
        return 'You can only do this for your own storefront.';
    }
    return fallback is String && fallback.isNotEmpty
        ? fallback
        : 'Something went wrong. Try again.';
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: t.primaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                        color: t.alternate,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text('Have a stall code?',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  "Enter the code from your market's sticker to apply instantly -- the market head still reviews every application.",
                  style: TextStyle(
                      color: t.secondaryText, fontSize: 12.5, height: 1.35),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3),
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'ABC123',
                    hintStyle: TextStyle(
                        color: t.secondaryText, letterSpacing: 3, fontSize: 20),
                    filled: true,
                    fillColor: t.secondaryBackground,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                  onChanged: (v) {
                    final upper = v.toUpperCase();
                    if (upper != v) {
                      _codeCtrl.value = _codeCtrl.value.copyWith(
                          text: upper,
                          selection:
                              TextSelection.collapsed(offset: upper.length));
                    }
                  },
                ),
                const SizedBox(height: 14),
                Text('Photo of your stall (optional)',
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _uploadingPhoto ? null : _pickPhoto,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: t.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: t.alternate),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _uploadingPhoto
                        ? Center(
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: t.secondary)))
                        : (_photoUrl != null
                            ? Image.network(_photoUrl!, fit: BoxFit.cover)
                            : Icon(Icons.add_a_photo_outlined,
                                color: t.secondaryText)),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Referred by (optional)',
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
                const SizedBox(height: 6),
                TextField(
                  controller: _referCtrl,
                  onChanged: _onReferChanged,
                  style: TextStyle(color: t.primaryText, fontSize: 13.5),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search a trader already in this market',
                    filled: true,
                    fillColor: t.secondaryBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    suffixIcon: _referPicked != null
                        ? Icon(Icons.check_circle, color: t.success, size: 20)
                        : null,
                  ),
                ),
                if (_referResults.isNotEmpty && _referPicked == null)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: t.secondaryBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: t.alternate),
                    ),
                    child: Column(
                      children: [
                        for (final r in _referResults)
                          ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: t.alternate,
                              backgroundImage:
                                  (r['logo_url'] as String?)?.isNotEmpty == true
                                      ? NetworkImage('${r['logo_url']}')
                                      : null,
                            ),
                            title: Text('${r['name']}',
                                style: TextStyle(
                                    color: t.primaryText, fontSize: 13.5)),
                            onTap: () => setState(() {
                              _referPicked = r;
                              _referCtrl.text = '${r['name']}';
                              _referResults = [];
                            }),
                          ),
                      ],
                    ),
                  ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: t.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(_error!,
                        style: TextStyle(color: t.primaryText, fontSize: 12.5)),
                  ),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Submit application',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
