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

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_location_picker.dart';
import '/custom_code/widgets/orija_media_field.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Edit an existing storefront: photos, details, contact + location,
/// visibility and the payout account.
///
/// Photos save the moment they are picked (and delete the picture they
/// replace); everything else saves with "Save changes". All writes go through
/// `update_my_storefront`, which checks ownership on the server, and payout
/// through `seller-setup`. Changing an existing payout account needs an email
/// code first (owner only, logged, and the seller is notified) so a stolen
/// session can't redirect a seller's money. The market a physical store
/// belongs to is shown but changed from the connect screen.
class OrijaEditStorefront extends StatefulWidget {
  const OrijaEditStorefront({
    super.key,
    this.width,
    this.height,
    required this.storefrontId,
  });

  final double? width;
  final double? height;
  final String? storefrontId;

  @override
  State<OrijaEditStorefront> createState() => _OrijaEditStorefrontState();
}

class _OrijaEditStorefrontState extends State<OrijaEditStorefront> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _loadError;
  Map<String, dynamic> _sf = {};

  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _phone = TextEditingController();
  final _youtube = TextEditingController();
  final _bio = TextEditingController();
  final _commission = TextEditingController();

  List<Map<String, String>> _cats = [];
  String? _category;
  List<Map<String, String>> _subOptions = [];
  final Set<String> _subs = {};
  bool _visible = true;
  bool _outside =
      false; // sells_outside_campus: reachable from the main Orija app too
  bool _accepts = false;
  OrijaLocationValue _loc = const OrijaLocationValue();

  String _returnPolicyTier = 'standard';
  final _returnPolicyNotes = TextEditingController();

  String? _marketName;
  String? _marketStatus;

  // Where your store shows: every community the store is linked to.
  List<Map<String, dynamic>> _places = [];
  String? _placeBusy;

  Future<void> _loadPlaces() async {
    final id = widget.storefrontId;
    if (id == null || id.isEmpty) return;
    try {
      final rows = await _client
          .from('community_storefronts')
          .select('approval_status, community_id, communities(id, name, type)')
          .eq('storefront_id', id)
          .inFilter('approval_status', ['approved', 'pending']);
      final list = <Map<String, dynamic>>[
        for (final r in rows)
          if (r['communities'] is Map)
            {
              'id': '${r['community_id']}',
              'name': '${(r['communities'] as Map)['name'] ?? 'Community'}',
              'type': '${(r['communities'] as Map)['type'] ?? ''}',
              'status': '${r['approval_status']}',
            }
      ];
      // School first, then live places, then waiting ones.
      int rank(Map<String, dynamic> p) =>
          p['type'] == 'institution' ? 0 : (p['status'] == 'approved' ? 1 : 2);
      list.sort((a, b) => rank(a).compareTo(rank(b)));
      if (mounted) setState(() => _places = list);
    } catch (_) {}
  }

  Future<void> _removePlace(Map<String, dynamic> p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove from ${p['name']}?'),
        content: const Text(
            'Your store stops showing there. You can add it again later.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep it')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Remove')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _placeBusy = p['id'] as String);
    var message = 'Removed.';
    try {
      final res = await _client.rpc('leave_my_community', params: {
        'p_storefront_id': widget.storefrontId,
        'p_community_id': p['id'],
      });
      if (!(res is Map && res['success'] == true)) {
        message =
            '${(res is Map ? res['message'] : null) ?? 'Could not remove it. Try again.'}';
      }
    } catch (_) {
      message = 'Check your connection and try again.';
    }
    if (!mounted) return;
    setState(() => _placeBusy = null);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    _loadPlaces();
  }

  Widget _placesSection(FlutterFlowTheme t) {
    return _section(t, 'Where your store shows', [
      if (_places.isEmpty)
        Text('Your store isn’t showing in any community yet.',
            style: TextStyle(color: t.secondaryText, fontSize: 13)),
      for (final p in _places)
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: t.alternate),
          ),
          child: Row(children: [
            Icon(
                p['type'] == 'institution'
                    ? Icons.school_outlined
                    : (p['type'] == 'market'
                        ? Icons.storefront_outlined
                        : Icons.groups_outlined),
                color: t.secondary,
                size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${p['name']}',
                      style: TextStyle(
                          color: t.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text(
                      p['type'] == 'institution'
                          ? 'Your school · always on'
                          : (p['status'] == 'approved'
                              ? 'Showing'
                              : 'Waiting for approval'),
                      style: TextStyle(
                          color: p['status'] == 'approved'
                              ? t.success
                              : t.secondaryText,
                          fontSize: 12)),
                ],
              ),
            ),
            if (p['type'] == 'institution')
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.lock_outline_rounded,
                    size: 18, color: t.secondaryText),
              )
            else if (_placeBusy == p['id'])
              const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else
              TextButton(
                onPressed: () => _removePlace(p),
                child: Text('Remove',
                    style: TextStyle(color: t.error, fontSize: 13)),
              ),
          ]),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () async {
            await context.pushNamed('ConnectStorefront',
                queryParameters: {
                  'storeID':
                      serializeParam(widget.storefrontId, ParamType.String),
                }.withoutNulls);
            _loadPlaces();
          },
          icon: Icon(Icons.add_rounded, color: t.secondary, size: 18),
          label: Text('Find more communities',
              style:
                  TextStyle(color: t.secondary, fontWeight: FontWeight.w700)),
        ),
      ),
    ]);
  }

  bool _saving = false;
  String? _error;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _load();
    _loadPlaces();
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _phone.dispose();
    _youtube.dispose();
    _bio.dispose();
    _commission.dispose();
    _returnPolicyNotes.dispose();
    super.dispose();
  }

  String get _type => '${_sf['storefront_type'] ?? 'online'}';
  bool get _isAgent => _type == 'agent';
  final _agentKey = GlobalKey<_AgentSettingsState>();

  Future<void> _load() async {
    final id = widget.storefrontId;
    if (id == null || id.isEmpty) {
      setState(() {
        _loadError = 'No storefront selected.';
        _loading = false;
      });
      return;
    }
    try {
      final row =
          await _client.from('storefronts').select().eq('id', id).maybeSingle();
      if (row == null || row['owner_id'] != currentUserUid) {
        setState(() {
          _loadError = 'This storefront is not yours to edit.';
          _loading = false;
        });
        return;
      }
      final cats = await _client
          .from('categories')
          .select('slug, name')
          .isFilter('parent_slug', null)
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      String? marketName;
      String? marketStatus;
      if (row['market_community_id'] != null) {
        final m = await _client
            .from('communities')
            .select('name')
            .eq('id', row['market_community_id'])
            .maybeSingle();
        final link = await _client
            .from('community_storefronts')
            .select('approval_status')
            .eq('storefront_id', id)
            .eq('community_id', row['market_community_id'])
            .maybeSingle();
        marketName = m?['name'] as String?;
        marketStatus = link?['approval_status'] as String?;
      }

      if (!mounted) return;
      _sf = Map<String, dynamic>.from(row);
      _name.text = '${row['name'] ?? ''}';
      _desc.text = '${row['description'] ?? ''}';
      _phone.text = ngPhoneDigitsFromAny('${row['pickup_phone'] ?? ''}');
      _youtube.text = '${row['youtube_url'] ?? ''}';
      _bio.text = '${row['declutter_bio'] ?? ''}';
      _commission.text =
          row['commission_rate'] == null ? '' : '${row['commission_rate']}';
      _category = row['category'] as String?;
      _visible = row['visibility'] != false;
      _outside = row['sells_outside_campus'] == true;
      _accepts = row['accepts_submissions'] == true;
      _subs
        ..clear()
        ..addAll(
            ((row['sub_categories'] as List?) ?? const []).map((e) => '$e'));
      _loc = OrijaLocationValue(
        stateName: row['state'] as String?,
        city: row['city'] as String?,
        address: (row['address_line'] as String?) ??
            (row['pickup_address_line1'] as String?),
      );
      _returnPolicyTier = '${row['return_policy_tier'] ?? 'standard'}';
      _returnPolicyNotes.text = '${row['return_policy_notes'] ?? ''}';
      _marketName = marketName;
      _marketStatus = marketStatus;
      setState(() {
        _cats = [
          for (final c in cats)
            {'slug': c['slug'] as String, 'name': c['name'] as String},
        ];
        _loading = false;
      });
      if (_category != null) _loadSubs(_category!, keep: true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Could not load this storefront. Check your connection.';
        _loading = false;
      });
    }
  }

  Future<void> _loadSubs(String slug, {bool keep = false}) async {
    if (!keep) setState(() => _subs.clear());
    try {
      final rows = await _client
          .from('subcategories')
          .select('slug, name')
          .eq('category_slug', slug)
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      if (!mounted || _category != slug) return;
      setState(() {
        _subOptions = [
          for (final r in rows)
            {'slug': r['slug'] as String, 'name': r['name'] as String},
        ];
      });
    } catch (_) {}
  }

  Future<Map<String, dynamic>> _update(Map<String, dynamic> fields) async {
    try {
      final res = await _client.rpc('update_my_storefront', params: {
        'p_storefront_id': widget.storefrontId,
        'p_fields': fields,
      });
      return res is Map ? Map<String, dynamic>.from(res) : {'success': false};
    } catch (_) {
      return {'success': false, 'error': 'network'};
    }
  }

  Future<bool> _savePhoto(String key, String url) async {
    final d = await _update({key: url});
    if (d['success'] == true) _sf[key] = url;
    return d['success'] == true;
  }

  String _norm(String? s) => (s ?? '').trim().toLowerCase();

  Future<void> _save() async {
    if (_name.text.trim().length < 3) {
      setState(() => _error = 'Give your storefront a name (3+ characters).');
      return;
    }
    if (_phone.text.trim().length != 10) {
      setState(() => _error = 'Enter a phone number buyers can reach.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    if (_isAgent) {
      final err = await _agentKey.currentState?.save();
      if (!mounted) return;
      if (err != null) {
        setState(() {
          _saving = false;
          _error = err;
        });
        return;
      }
    }

    final fields = <String, dynamic>{
      'name': _name.text.trim(),
      'description': _desc.text.trim(),
      'category': _category,
      'sub_categories': _subs.toList(),
      'youtube_url': _youtube.text.trim(),
      'visibility': _visible,
      if (!_isAgent) 'sells_outside_campus': _outside,
      'pickup_phone': '+234${_phone.text.trim()}',
      'return_policy_tier': _returnPolicyTier,
      'return_policy_notes': _returnPolicyNotes.text.trim(),
    };

    // Only touch the address (and so invalidate the courier address Terminal
    // has cached for it) when it actually changed.
    final changed = _loc.hasStateAndCity &&
        (_norm(_loc.stateName) != _norm(_sf['state'] as String?) ||
            _norm(_loc.city) != _norm(_sf['city'] as String?) ||
            _norm(_loc.address) != _norm(_sf['address_line'] as String?));
    if (changed) {
      fields.addAll({
        'country': 'NG',
        'state': _loc.stateName,
        'city': _loc.city,
        'address_line': _loc.address ?? '',
        'pickup_address_state': _loc.stateName,
        'pickup_address_city': _loc.city,
        'pickup_address_line1': _loc.address ?? '',
      });
    }

    if (_type == 'declutter') {
      fields['declutter_bio'] = _bio.text.trim();
      fields['accepts_submissions'] = _accepts;
      final rate = double.tryParse(_commission.text.trim());
      if (rate != null) fields['commission_rate'] = rate;
    }

    final d = await _update(fields);
    if (!mounted) return;
    if (d['success'] == true) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Storefront updated.'),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ));
      if (context.canPop()) context.pop();
    } else {
      setState(() {
        _saving = false;
        _error = 'Could not save your changes. Try again.';
      });
    }
  }

  /// Soft-closes this one storefront (is_active + visibility -> false)
  /// via the ownership-checked close_storefront RPC. Nothing is deleted --
  /// listings, orders and reviews all stay intact, same precedent as
  /// account deactivation elsewhere in the app. Confirms first since this
  /// immediately hides the store from buyers.
  Future<void> _closeStorefront() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Close this storefront?'),
        content: Text(
            'Buyers will no longer see "${_sf['name'] ?? 'this storefront'}" '
            'or be able to message or order from it. Your listings, past '
            'orders and reviews are kept. Contact support to reopen it '
            'later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Close storefront',
                style: TextStyle(color: FlutterFlowTheme.of(context).error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _closing = true;
      _error = null;
    });

    try {
      final res = await _client.rpc('close_storefront',
          params: {'p_storefront_id': widget.storefrontId});
      final r =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (!mounted) return;
      if (r['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Storefront closed.'),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ));
        if (context.canPop()) context.pop();
      } else {
        setState(() {
          _closing = false;
          _error = 'Could not close the storefront. Try again.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _closing = false;
          _error = 'Could not close the storefront. Try again.';
        });
      }
    }
  }

  Future<void> _openPayout() async {
    final ok = await showOrijaPayoutSheet(
      context,
      storefrontId: widget.storefrontId!,
      email: currentUserEmail,
      hasExisting: '${_sf['paystack_subaccount_code'] ?? ''}'.isNotEmpty,
    );
    if (ok == true) {
      final row = await _client
          .from('storefronts')
          .select()
          .eq('id', widget.storefrontId!)
          .maybeSingle();
      if (row != null && mounted) {
        setState(() => _sf = Map<String, dynamic>.from(row));
      }
    }
  }

  // ------------------------------------------------------------------- UI

  InputDecoration _dec(FlutterFlowTheme t, String label, {String? hint}) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: t.secondaryText, fontSize: 13),
      hintStyle: TextStyle(color: t.secondaryText, fontSize: 13),
      filled: true,
      fillColor: t.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: b(t.alternate),
      focusedBorder: b(t.secondary),
      border: b(t.alternate),
    );
  }

  Widget _section(FlutterFlowTheme t, String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(title,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
          ),
          ...children,
        ],
      ),
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
    if (_loadError != null) {
      return Container(
        color: t.primaryBackground,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_loadError!,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.primaryText, fontSize: 15)),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.goNamed('HomePage'),
            child: const Text('Go back'),
          ),
        ]),
      );
    }

    final hasPayout = '${_sf['paystack_subaccount_code'] ?? ''}'.isNotEmpty;
    final last4 = '${_sf['paystack_account_number'] ?? ''}';
    final typeLabel = _type == 'local'
        ? 'Physical store'
        : (_type == 'declutter' ? 'Declutter store' : 'Online store');

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
                child: Text('Edit storefront',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: t.secondary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(typeLabel,
                    style: TextStyle(
                        color: t.secondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _section(t, 'Photos', [
                    OrijaMediaField(
                      uploadContext: 'storefront_cover',
                      shape: 'wide',
                      height: 150,
                      label: 'Add a cover photo',
                      imageUrl: _sf['cover_url'] as String?,
                      onSave: (u) => _savePhoto('cover_url', u),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: OrijaMediaField(
                        uploadContext: 'storefront_logo',
                        shape: 'circle',
                        width: 104,
                        height: 104,
                        label: 'Add a logo',
                        imageUrl: _sf['logo_url'] as String?,
                        onSave: (u) => _savePhoto('logo_url', u),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Photos save as soon as you pick them.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: t.secondaryText, fontSize: 11.5)),
                  ]),
                  _section(t, 'Details', [
                    TextField(
                      controller: _name,
                      maxLength: 60,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(color: t.primaryText, fontSize: 14),
                      decoration: _dec(t, 'Storefront name'),
                    ),
                    TextField(
                      controller: _desc,
                      maxLines: 4,
                      maxLength: 400,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(color: t.primaryText, fontSize: 14),
                      decoration: _dec(t, 'Description'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final c in _cats)
                        ChoiceChip(
                          label: Text(c['name']!),
                          selected: _category == c['slug'],
                          showCheckmark: false,
                          selectedColor: t.secondary,
                          backgroundColor: t.secondaryBackground,
                          side: BorderSide(
                              color: _category == c['slug']
                                  ? t.secondary
                                  : t.alternate),
                          labelStyle: TextStyle(
                              fontSize: 12.5,
                              color: _category == c['slug']
                                  ? Colors.white
                                  : t.primaryText),
                          onSelected: (_) {
                            setState(() => _category = c['slug']);
                            _loadSubs(c['slug']!);
                          },
                        ),
                    ]),
                    if (_subOptions.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text('Sub-categories · ${_subs.length} of 5 chosen',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final s in _subOptions)
                          FilterChip(
                            label: Text(s['name']!),
                            selected: _subs.contains(s['slug']),
                            showCheckmark: false,
                            selectedColor: t.secondary.withValues(alpha: 0.18),
                            backgroundColor: t.secondaryBackground,
                            side: BorderSide(
                                color: _subs.contains(s['slug'])
                                    ? t.secondary
                                    : t.alternate),
                            labelStyle:
                                TextStyle(fontSize: 12.5, color: t.primaryText),
                            onSelected: (on) => setState(() {
                              if (on) {
                                if (_subs.length < 5) _subs.add(s['slug']!);
                              } else {
                                _subs.remove(s['slug']);
                              }
                            }),
                          ),
                      ]),
                    ],
                    const SizedBox(height: 14),
                    TextField(
                      controller: _youtube,
                      keyboardType: TextInputType.url,
                      style: TextStyle(color: t.primaryText, fontSize: 14),
                      decoration: _dec(t, 'YouTube link (optional)'),
                    ),
                  ]),
                  if (_isAgent)
                    _section(t, 'Agent settings', [
                      _AgentSettings(
                          key: _agentKey,
                          storefrontId: '${widget.storefrontId}'),
                    ]),
                  _section(
                      t,
                      _isAgent ? 'Office and location' : 'Contact and location',
                      [
                        ngPhoneField(t, _phone),
                        const SizedBox(height: 12),
                        OrijaLocationPicker(
                          initialState: _loc.stateName,
                          initialCity: _loc.city,
                          initialAddress: _loc.address,
                          onChanged: (v) => _loc = v,
                        ),
                        if (_marketName != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: t.secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: t.alternate),
                            ),
                            child: Row(children: [
                              Icon(Icons.storefront_outlined,
                                  color: t.secondary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_marketName!,
                                        style: TextStyle(
                                            color: t.primaryText,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.5)),
                                    Text(
                                        _marketStatus == 'approved'
                                            ? 'Verified by the market head'
                                            : (_marketStatus == 'rejected'
                                                ? 'Not approved by the market head'
                                                : 'Waiting for the market head to verify'),
                                        style: TextStyle(
                                            color: t.secondaryText,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ]),
                  if (_type == 'declutter')
                    _section(t, 'Declutter settings', [
                      TextField(
                        controller: _bio,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(color: t.primaryText, fontSize: 14),
                        decoration: _dec(t, 'About your declutter service'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _commission,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: TextStyle(color: t.primaryText, fontSize: 14),
                        decoration: _dec(t, 'Your commission (%)'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _accepts,
                        activeColor: t.secondary,
                        title: Text('Accept new item submissions',
                            style: TextStyle(
                                color: t.primaryText, fontSize: 13.5)),
                        onChanged: (v) => setState(() => _accepts = v),
                      ),
                    ]),
                  _placesSection(t),
                  _section(t, 'Visibility', [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _visible,
                      activeColor: t.secondary,
                      title: Text('Show my storefront to buyers',
                          style:
                              TextStyle(color: t.primaryText, fontSize: 13.5)),
                      subtitle: Text('Turn off to hide it without deleting.',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                      onChanged: (v) => setState(() => _visible = v),
                    ),
                    // Campus stores only reach students by default. On: buyers
                    // in the main Orija app can find and buy from this store too.
                    if (!_isAgent)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _outside,
                        activeColor: t.secondary,
                        title: Text('Sell outside campus',
                            style: TextStyle(
                                color: t.primaryText, fontSize: 13.5)),
                        subtitle: Text(
                            'Buyers on the main Orija app can find your store and order. Only turn it on if you can deliver or ship off campus.',
                            style: TextStyle(
                                color: t.secondaryText, fontSize: 12)),
                        onChanged: (v) => setState(() => _outside = v),
                      ),
                  ]),
                  if (!_isAgent)
                    _section(t, 'Return policy', [
                      DropdownButtonFormField<String>(
                        initialValue: _returnPolicyTier,
                        isExpanded: true,
                        dropdownColor: t.secondaryBackground,
                        style: TextStyle(color: t.primaryText, fontSize: 14),
                        decoration: _dec(t, 'Returns'),
                        items: const [
                          DropdownMenuItem(
                              value: 'none', child: Text('No returns')),
                          DropdownMenuItem(
                              value: 'standard', child: Text('7-day returns')),
                          DropdownMenuItem(
                              value: 'extended', child: Text('14-day returns')),
                        ],
                        onChanged: (v) =>
                            setState(() => _returnPolicyTier = v ?? 'standard'),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A damaged, wrong, or missing item is always refundable, '
                        'no matter which option is chosen above -- this only '
                        'covers a buyer changing their mind.',
                        style:
                            TextStyle(color: t.secondaryText, fontSize: 11.5),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _returnPolicyNotes,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(color: t.primaryText, fontSize: 14),
                        decoration: _dec(t, 'Notes for buyers (optional)',
                            hint:
                                'e.g. items must be unused and in original packaging'),
                      ),
                    ]),
                  _section(t, 'Danger zone', [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: t.secondaryBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: t.error.withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Close this storefront',
                              style: TextStyle(
                                  color: t.primaryText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(
                              'Hides it from buyers for good. Listings, '
                              'orders and reviews are kept -- contact '
                              'support to reopen it.',
                              style: TextStyle(
                                  color: t.secondaryText, fontSize: 12.5)),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: _closing ? null : _closeStorefront,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: t.error,
                              side: BorderSide(color: t.error),
                            ),
                            child: _closing
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: t.error),
                                  )
                                : const Text('Close storefront'),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  _section(t, 'Payout account', [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: t.secondaryBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: t.alternate),
                      ),
                      child: Row(children: [
                        Icon(
                            hasPayout
                                ? Icons.account_balance_rounded
                                : Icons.warning_amber_rounded,
                            color: hasPayout ? t.secondary : t.warning,
                            size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  hasPayout
                                      ? '${_sf['paystack_bank_name'] ?? 'Bank account'}'
                                      : 'No payout account yet',
                                  style: TextStyle(
                                      color: t.primaryText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(
                                  hasPayout
                                      ? '${_sf['paystack_account_name'] ?? ''} · ending ${last4.length >= 4 ? last4.substring(last4.length - 4) : last4}'
                                      : 'Add one to start listing items for sale.',
                                  style: TextStyle(
                                      color: t.secondaryText, fontSize: 12.5)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _openPayout,
                          child: Text(hasPayout ? 'Change' : 'Add',
                              style: TextStyle(
                                  color: t.secondary,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ]),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              border: Border(top: BorderSide(color: t.alternate)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_error!,
                      style: TextStyle(color: t.error, fontSize: 12.5)),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Save changes',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14.5)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Opens the shared payout-account sheet: email-code confirmation before
/// changing an existing account, then a searchable bank picker, account
/// number entry with live account-name verification, and save. Used by the
/// edit-storefront screen itself and by any other surface (storefront page
/// owner actions, the payout-account list) that needs to add or change a
/// storefront's payout details without duplicating this flow.
Future<bool?> showOrijaPayoutSheet(
  BuildContext context, {
  required String storefrontId,
  required String email,
  required bool hasExisting,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => OrijaPayoutSheet(
      storefrontId: storefrontId,
      email: email,
      hasExisting: hasExisting,
    ),
  );
}

/// Add or change the payout account. Changing one needs the emailed code
/// first; the server checks that the code was verified in the last 10 minutes.
class OrijaPayoutSheet extends StatefulWidget {
  const OrijaPayoutSheet({
    super.key,
    required this.storefrontId,
    required this.email,
    required this.hasExisting,
  });

  final String storefrontId;
  final String email;
  final bool hasExisting;

  @override
  State<OrijaPayoutSheet> createState() => _PayoutSheetState();
}

class _PayoutSheetState extends State<OrijaPayoutSheet> {
  final _client = Supabase.instance.client;
  final _code = TextEditingController();
  final _acct = TextEditingController();

  late String _stage; // intro | code | bank
  bool _busy = false;
  String? _error;

  List<Map<String, String>> _banks = [];
  String? _bankCode;
  String? _acctName;
  bool _resolving = false;

  @override
  void initState() {
    super.initState();
    _stage = widget.hasExisting ? 'intro' : 'bank';
    if (_stage == 'bank') _loadBanks();
  }

  @override
  void dispose() {
    _code.dispose();
    _acct.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _call(Map<String, dynamic> body) async {
    try {
      final res = await _client.functions.invoke('seller-setup', body: body);
      final d = res.data;
      return d is Map ? Map<String, dynamic>.from(d) : {'success': false};
    } on FunctionException catch (e) {
      final d = e.details;
      return d is Map
          ? Map<String, dynamic>.from(d)
          : {'success': false, 'message': 'Something went wrong. Try again.'};
    } catch (_) {
      return {'success': false, 'message': 'Check your connection.'};
    }
  }

  Future<void> _sendCode() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await getOtp(widget.email);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ok) {
        _stage = 'code';
      } else {
        _error = 'Could not send the code. Try again.';
      }
    });
  }

  Future<void> _verify() async {
    final code = _code.text.trim();
    if (code.length < 6) {
      setState(() => _error = 'Enter the 6-digit code from your email.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await confirmOtp(code, widget.email);
    if (!mounted) return;
    if (ok) {
      setState(() {
        _busy = false;
        _stage = 'bank';
      });
      _loadBanks();
    } else {
      setState(() {
        _busy = false;
        _error = 'That code did not work. Check it and try again.';
      });
    }
  }

  Future<void> _loadBanks() async {
    final d = await _call({'action': 'list_banks'});
    if (!mounted) return;
    final list = d['banks'];
    if (d['success'] == true && list is List) {
      setState(() => _banks = [
            for (final b in list)
              {'name': '${b['name']}', 'code': '${b['code']}'},
          ]);
    } else {
      setState(() => _error = 'Could not load banks. Close and try again.');
    }
  }

  Future<void> _resolve() async {
    final n = _acct.text.trim();
    final b = _bankCode;
    setState(() {
      _acctName = null;
      _error = null;
    });
    if (b == null || n.length != 10) return;
    setState(() => _resolving = true);
    final d = await _call(
        {'action': 'resolve_account', 'account_number': n, 'bank_code': b});
    if (!mounted || _acct.text.trim() != n || _bankCode != b) return;
    setState(() {
      _resolving = false;
      if (d['success'] == true) {
        _acctName = d['account_name'] as String?;
      } else {
        _error = (d['message'] as String?) ??
            'We could not verify that account. Check the number and bank.';
      }
    });
  }

  Future<void> _save() async {
    if (_acctName == null || _bankCode == null) {
      setState(
          () => _error = 'Choose a bank and enter a valid account number.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final d = await _call({
      'action': 'set_payout',
      'storefront_id': widget.storefrontId,
      'account_number': _acct.text.trim(),
      'bank_code': _bankCode,
    });
    if (!mounted) return;
    if (d['success'] == true) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _busy = false;
      if (d['code'] == 'OTP_REQUIRED') {
        _stage = 'intro';
        _error = 'For security, confirm a fresh email code first.';
      } else {
        _error = (d['message'] as String?) ??
            'Could not update the payout account. Try again.';
      }
    });
  }

  InputDecoration _dec(FlutterFlowTheme t, String label) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: t.secondaryText, fontSize: 13),
      filled: true,
      fillColor: t.primaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: b(t.alternate),
      focusedBorder: b(t.secondary),
      border: b(t.alternate),
    );
  }

  Widget _primary(FlutterFlowTheme t, String text, VoidCallback? onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _busy ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: t.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: _busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);

    Widget body;
    if (_stage == 'intro') {
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Confirm it is you',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
            'To protect your earnings we will email a 6-digit code to ${widget.email} before you can change your payout account.',
            style:
                TextStyle(color: t.secondaryText, fontSize: 13, height: 1.4)),
        const SizedBox(height: 16),
        _primary(t, 'Send code', _sendCode),
      ]);
    } else if (_stage == 'code') {
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Enter your code',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('We sent a code to ${widget.email}.',
            style: TextStyle(color: t.secondaryText, fontSize: 13)),
        const SizedBox(height: 14),
        TextField(
          controller: _code,
          keyboardType: TextInputType.number,
          maxLength: 8,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style:
              TextStyle(color: t.primaryText, fontSize: 18, letterSpacing: 4),
          decoration: _dec(t, 'Code'),
        ),
        const SizedBox(height: 6),
        _primary(t, 'Verify', _verify),
        TextButton(
          onPressed: _busy ? null : _sendCode,
          child:
              Text('Send a new code', style: TextStyle(color: t.secondaryText)),
        ),
      ]);
    } else {
      body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(widget.hasExisting ? 'New payout account' : 'Add payout account',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        bankPickerField(
          context,
          t,
          banks: _banks,
          selectedCode: _bankCode,
          onPicked: (b) {
            setState(() => _bankCode = b['code']);
            _resolve();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _acct,
          keyboardType: TextInputType.number,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(color: t.primaryText, fontSize: 14),
          decoration: _dec(t, 'Account number'),
          onChanged: (_) => _resolve(),
        ),
        if (_resolving)
          Text('Checking the account…',
              style: TextStyle(color: t.secondaryText, fontSize: 12.5))
        else if (_acctName != null)
          Row(children: [
            Icon(Icons.verified_rounded, color: t.success, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(_acctName!,
                  style: TextStyle(
                      color: t.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
            ),
          ]),
        const SizedBox(height: 14),
        _primary(t, 'Save payout account', _save),
      ]);
    }

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: t.secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                  color: t.alternate, borderRadius: BorderRadius.circular(2)),
            ),
            body,
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: t.error, fontSize: 12.5)),
              ),
          ]),
        ),
      ),
    );
  }
}

/// A searchable bank picker. Nigeria has 40+ banks, too many for a plain
/// dropdown to be usable -- this opens a sheet with a search box instead.
/// Returns the picked {'code': ..., 'name': ...}, or null if dismissed.
Future<Map<String, String>?> showBankSearchSheet(
  BuildContext context,
  FlutterFlowTheme theme,
  List<Map<String, String>> banks,
) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _BankSearchSheet(theme: theme, banks: banks),
  );
}

/// Tappable field that opens the bank search sheet and shows the current
/// selection, matching the look of the surrounding text fields.
Widget bankPickerField(
  BuildContext context,
  FlutterFlowTheme theme, {
  required List<Map<String, String>> banks,
  required String? selectedCode,
  required ValueChanged<Map<String, String>> onPicked,
}) {
  final selected = selectedCode == null
      ? null
      : banks.firstWhere((b) => b['code'] == selectedCode,
          orElse: () => const {});
  final label = (selected != null && (selected['name'] ?? '').isNotEmpty)
      ? selected['name']!
      : (banks.isEmpty ? 'Loading banks…' : 'Choose your bank');

  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: banks.isEmpty
        ? null
        : () async {
            final picked = await showBankSearchSheet(context, theme, banks);
            if (picked != null) onPicked(picked);
          },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: 'Bank',
        labelStyle: TextStyle(color: theme.secondaryText, fontSize: 13),
        filled: true,
        fillColor: theme.secondaryBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        suffixIcon: Icon(Icons.search, color: theme.secondaryText, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.alternate),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.alternate),
        ),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: (selected != null && (selected['name'] ?? '').isNotEmpty)
              ? theme.primaryText
              : theme.secondaryText,
          fontSize: 14,
        ),
      ),
    ),
  );
}

class _BankSearchSheet extends StatefulWidget {
  const _BankSearchSheet({required this.theme, required this.banks});
  final FlutterFlowTheme theme;
  final List<Map<String, String>> banks;

  @override
  State<_BankSearchSheet> createState() => _BankSearchSheetState();
}

class _BankSearchSheetState extends State<_BankSearchSheet> {
  final _query = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final filtered = _q.trim().isEmpty
        ? widget.banks
        : widget.banks
            .where((b) =>
                (b['name'] ?? '').toLowerCase().contains(_q.toLowerCase()))
            .toList();

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                    color: theme.alternate,
                    borderRadius: BorderRadius.circular(2)),
              ),
              TextField(
                controller: _query,
                autofocus: true,
                onChanged: (v) => setState(() => _q = v),
                style: TextStyle(color: theme.primaryText, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search banks',
                  hintStyle: TextStyle(color: theme.secondaryText),
                  prefixIcon: Icon(Icons.search, color: theme.secondaryText),
                  filled: true,
                  fillColor: theme.primaryBackground,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.alternate),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.alternate),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('No banks match that search.',
                            style: TextStyle(color: theme.secondaryText)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final b = filtered[i];
                          return ListTile(
                            title: Text(b['name'] ?? '',
                                style: TextStyle(color: theme.primaryText)),
                            onTap: () => Navigator.of(context).pop(b),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A phone field fixed to +234 (Nigeria): the prefix is shown, not typed,
/// and only the 10 digits after it are collected. Terminal Africa expects
/// this exact shape for pickup/delivery contacts, so every phone number this
/// app collects is stored the same way rather than however each seller or
/// buyer happens to type theirs. Duplicated from orija_storefront_setup.dart
/// (each custom widget is an independent compilation unit).
String ngPhoneDigitsFromAny(String raw) {
  var d = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (d.startsWith('234')) d = d.substring(3);
  if (d.startsWith('0')) d = d.substring(1);
  if (d.length > 10) d = d.substring(d.length - 10);
  return d;
}

Widget ngPhoneField(
  FlutterFlowTheme theme,
  TextEditingController controller, {
  bool validateForm = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.phone,
    maxLength: 10,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ],
    style: TextStyle(color: theme.primaryText, fontSize: 13.5),
    validator: validateForm
        ? (v) => (v == null || v.trim().length != 10)
            ? 'Enter a 10-digit number'
            : null
        : null,
    decoration: InputDecoration(
      labelText: 'Phone number',
      prefixText: '+234  ',
      prefixStyle: TextStyle(
          color: theme.primaryText,
          fontSize: 13.5,
          fontWeight: FontWeight.w600),
      counterText: '',
      labelStyle: TextStyle(color: theme.secondaryText, fontSize: 12.5),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.alternate),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.alternate),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.secondary),
      ),
    ),
  );
}

// ============================================== agent stores: Agent settings

class _AgentSettings extends StatefulWidget {
  const _AgentSettings({super.key, required this.storefrontId});
  final String storefrontId;

  @override
  State<_AgentSettings> createState() => _AgentSettingsState();
}

String _nairaFmt(num? v) {
  final s = (v ?? 0).round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '₦$b';
}

InputDecoration _agentDec(FlutterFlowTheme t, String label,
    {String? hint, String? prefix}) {
  OutlineInputBorder b(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c));
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixText: prefix,
    labelStyle: TextStyle(color: t.secondaryText, fontSize: 13),
    hintStyle: TextStyle(color: t.secondaryText, fontSize: 13),
    filled: true,
    fillColor: t.secondaryBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: b(t.alternate),
    focusedBorder: b(t.secondary),
    border: b(t.alternate),
  );
}

class _AgentSettingsState extends State<_AgentSettings> {
  final _db = Supabase.instance.client;
  bool _loading = true;
  final List<String> _areas = [];
  final _areaInput = TextEditingController();
  String _feeType = 'percent';
  final _feeValue = TextEditingController();
  final _inspectionFee = TextEditingController();
  String? _cardPath;
  String _cardStatus = 'pending';
  String? _cacPath;
  Uint8List? _cardBytes;
  String _cardExt = 'jpg';
  Uint8List? _cacBytes;
  String _cacExt = 'jpg';
  Map<String, dynamic> _times = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _areaInput.dispose();
    _feeValue.dispose();
    _inspectionFee.dispose();
    super.dispose();
  }

  String get _id => widget.storefrontId;

  Future<void> _load() async {
    if (_id.isEmpty) return;
    try {
      final p =
          await _db.rpc('get_agent_profile', params: {'p_storefront_id': _id});
      final s = await _db
          .from('agent_inspection_settings')
          .select()
          .eq('storefront_id', _id)
          .maybeSingle();
      if (!mounted) return;
      final m = p is Map ? p : const {};
      setState(() {
        _areas
          ..clear()
          ..addAll([for (final a in ((m['areas'] as List?) ?? const [])) '$a']);
        _feeType = '${m['agent_fee_type'] ?? 'percent'}';
        _feeValue.text = _plain(m['agent_fee_value'] ?? 10);
        _inspectionFee.text = _plain(m['inspection_fee'] ?? 2000);
        _cardPath = m['association_card_path'] as String?;
        _cacPath = m['cac_path'] as String?;
        _cardStatus = '${m['card_status'] ?? 'pending'}';
        _times = s == null ? {} : Map<String, dynamic>.from(s);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _plain(dynamic v) {
    final n = num.tryParse('$v') ?? 0;
    return n == n.roundToDouble() ? '${n.round()}' : '$n';
  }

  Future<String?> _upload(Uint8List? bytes, String ext, String kind) async {
    if (bytes == null) return null;
    final path =
        '$currentUserUid/agent-$kind-${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _db.storage.from('student-ids').uploadBinary(path, bytes,
        fileOptions: FileOptions(
            contentType: ext == 'png' ? 'image/png' : 'image/jpeg',
            upsert: false));
    return path;
  }

  /// Returns an error message, or null when saved.
  Future<String?> save() async {
    if (_loading || _id.isEmpty) return null;
    if (_areas.isEmpty) return 'Add at least one area you cover.';
    final fee = num.tryParse(_feeValue.text.trim());
    if (fee == null || fee < 0 || (_feeType == 'percent' && fee > 100)) {
      return 'Check your agent fee.';
    }
    final insp = num.tryParse(_inspectionFee.text.replaceAll(',', '').trim());
    if (insp == null || insp < 0) return 'Check your inspection fee.';
    try {
      final card = await _upload(_cardBytes, _cardExt, 'card');
      final cac = await _upload(_cacBytes, _cacExt, 'cac');
      final res = await _db.rpc('upsert_my_agent_profile', params: {
        'p_storefront_id': _id,
        'p_areas': _areas,
        'p_fee_type': _feeType,
        'p_fee_value': fee,
        'p_inspection_fee': insp,
        'p_card_path': card,
        'p_cac_path': cac,
      });
      if (res is Map && res['success'] != true) {
        return '${res['message'] ?? 'Could not save your agent settings.'}';
      }
      return null;
    } catch (_) {
      return 'Could not save your agent settings. Check your connection.';
    }
  }

  Future<void> _pick(bool card) async {
    try {
      final x = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 1800, imageQuality: 85);
      if (x == null) return;
      final bytes = await x.readAsBytes();
      final ext = x.name.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
      if (!mounted) return;
      setState(() {
        if (card) {
          _cardBytes = bytes;
          _cardExt = ext;
        } else {
          _cacBytes = bytes;
          _cacExt = ext;
        }
      });
    } catch (_) {}
  }

  void _addArea() {
    final v = _areaInput.text.trim();
    if (v.isEmpty || _areas.any((a) => a.toLowerCase() == v.toLowerCase()))
      return;
    setState(() {
      _areas.add(v);
      _areaInput.clear();
    });
  }

  String _timesSummary() {
    final w = (_times['weekly_hours'] as Map?) ?? const {};
    const order = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final open =
        order.where((d) => w[d] is List && (w[d] as List).length == 2).length;
    final slot = _times['slot_minutes'] ?? 60;
    return open == 0
        ? 'No inspection days set'
        : '$open days a week · $slot-minute slots';
  }

  Future<void> _openTimes() async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) =>
          _InspectionTimesScreen(storefrontId: _id, initial: _times),
    ));
    if (saved == true) _load();
  }

  Widget _label(FlutterFlowTheme t, String s) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(s,
            style: TextStyle(
                color: t.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      );

  Widget _docRow(FlutterFlowTheme t,
      {required String title,
      required String status,
      required Color statusColor,
      required bool picked,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.alternate),
      ),
      child: Row(children: [
        Icon(Icons.badge_outlined, color: t.secondaryText, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    color: t.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5)),
            const SizedBox(height: 2),
            Text(
                picked
                    ? 'New photo added · sent for review when you save'
                    : status,
                style: TextStyle(
                    color: picked ? t.secondary : statusColor, fontSize: 12)),
          ]),
        ),
        TextButton(
            onPressed: onTap, child: Text(picked ? 'Change' : 'Replace')),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator(color: t.secondary)),
      );
    }
    final (cardText, cardColor) = (_cardPath ?? '').isEmpty
        ? ('Not uploaded. The Market Head needs it to approve you.', t.error)
        : switch (_cardStatus) {
            'approved' => ('Approved by the Market Head', t.success),
            'rejected' => ('Not approved. Upload a clearer card.', t.error),
            _ => ('Waiting for the Market Head', t.warning),
          };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _openTimes,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: t.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.secondary.withValues(alpha: 0.35)),
            ),
            child: Row(children: [
              Icon(Icons.schedule_rounded, color: t.secondary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Inspection times',
                          style: TextStyle(
                              color: t.primaryText,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      Text(_timesSummary(),
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                    ]),
              ),
              Icon(Icons.chevron_right_rounded, color: t.secondaryText),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        _label(t, 'Areas you cover'),
        if (_areas.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (final a in _areas)
                InputChip(
                  label: Text(a),
                  onDeleted: () => setState(() => _areas.remove(a)),
                  backgroundColor: t.secondary.withValues(alpha: 0.12),
                  side: BorderSide(color: t.secondary),
                  labelStyle: TextStyle(color: t.primaryText, fontSize: 12.5),
                ),
            ]),
          ),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _areaInput,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => _addArea(),
              style: TextStyle(color: t.primaryText, fontSize: 14),
              decoration: _agentDec(t, 'Add an area', hint: 'e.g. Oke-Baale'),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _addArea,
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: t.secondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text('Add', style: TextStyle(color: t.secondary)),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        _label(t, 'Agent fee'),
        Row(children: [
          for (final f in const [
            ('percent', 'Percent of rent'),
            ('flat', 'Flat amount')
          ])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: SizedBox(
                      width: double.infinity,
                      child: Text(f.$2, textAlign: TextAlign.center)),
                  selected: _feeType == f.$1,
                  showCheckmark: false,
                  selectedColor: t.secondary,
                  backgroundColor: t.secondaryBackground,
                  side: BorderSide(
                      color: _feeType == f.$1 ? t.secondary : t.alternate),
                  labelStyle: TextStyle(
                      fontSize: 12.5,
                      color: _feeType == f.$1 ? Colors.white : t.primaryText),
                  onSelected: (_) => setState(() => _feeType = f.$1),
                ),
              ),
            ),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _feeValue,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: t.primaryText, fontSize: 14),
              decoration: _agentDec(
                  t, _feeType == 'percent' ? 'Agent fee (%)' : 'Agent fee',
                  prefix: _feeType == 'percent' ? null : '₦ '),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _inspectionFee,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: t.primaryText, fontSize: 14),
              decoration: _agentDec(t, 'Inspection fee', prefix: '₦ '),
            ),
          ),
        ]),
        const SizedBox(height: 6),
        Builder(builder: (_) {
          final f =
              num.tryParse(_inspectionFee.text.replaceAll(',', '').trim()) ?? 0;
          return Text(
              'You get ${_nairaFmt(f * 0.9)} per booking. Orija keeps ${_nairaFmt(f * 0.1)} (10%).',
              style: TextStyle(color: t.secondaryText, fontSize: 12));
        }),
        const SizedBox(height: 14),
        _label(t, 'Verification'),
        _docRow(t,
            title: 'Association card',
            status: cardText,
            statusColor: cardColor,
            picked: _cardBytes != null,
            onTap: () => _pick(true)),
        _docRow(t,
            title: 'CAC certificate · optional',
            status: (_cacPath ?? '').isEmpty ? 'Not added' : 'Added',
            statusColor: t.secondaryText,
            picked: _cacBytes != null,
            onTap: () => _pick(false)),
      ],
    );
  }
}

// ------------------------------------------------------------ inspection times

class _InspectionTimesScreen extends StatefulWidget {
  const _InspectionTimesScreen(
      {required this.storefrontId, required this.initial});
  final String storefrontId;
  final Map<String, dynamic> initial;

  @override
  State<_InspectionTimesScreen> createState() => _InspectionTimesScreenState();
}

class _InspectionTimesScreenState extends State<_InspectionTimesScreen> {
  static const _days = [
    ('mon', 'Monday'),
    ('tue', 'Tuesday'),
    ('wed', 'Wednesday'),
    ('thu', 'Thursday'),
    ('fri', 'Friday'),
    ('sat', 'Saturday'),
    ('sun', 'Sunday'),
  ];
  final Map<String, List<String>?> _hours = {};
  int _slot = 60;
  int _notice = 3;
  final List<DateTime> _off = [];
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    final w = (i['weekly_hours'] as Map?) ??
        const {
          'mon': ['09:00', '17:00'],
          'tue': ['09:00', '17:00'],
          'wed': ['09:00', '17:00'],
          'thu': ['09:00', '17:00'],
          'fri': ['09:00', '17:00'],
          'sat': ['10:00', '14:00'],
        };
    for (final d in _days) {
      final v = w[d.$1];
      _hours[d.$1] = v is List && v.length == 2 ? ['${v[0]}', '${v[1]}'] : null;
    }
    _slot = (i['slot_minutes'] as num?)?.toInt() ?? 60;
    _notice = (i['min_notice_hours'] as num?)?.toInt() ?? 3;
    for (final d in ((i['days_off'] as List?) ?? const [])) {
      final p = DateTime.tryParse('$d');
      if (p != null &&
          !p.isBefore(DateTime.now().subtract(const Duration(days: 1))))
        _off.add(p);
    }
    _off.sort();
  }

  TimeOfDay _tod(String s) {
    final p = s.split(':');
    return TimeOfDay(
        hour: int.tryParse(p[0]) ?? 9,
        minute: int.tryParse(p.length > 1 ? p[1] : '0') ?? 0);
  }

  String _hm(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _pretty(String s) {
    final t = _tod(s);
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute == 0 ? '' : ':${t.minute.toString().padLeft(2, '0')}';
    return '$h$m ${t.hour < 12 ? 'am' : 'pm'}';
  }

  String _date(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${w[d.weekday - 1]} ${d.day} ${m[d.month - 1]}';
  }

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickTime(String day, int idx) async {
    final cur = _hours[day]!;
    final picked =
        await showTimePicker(context: context, initialTime: _tod(cur[idx]));
    if (picked == null) return;
    setState(() => _hours[day]![idx] = _hm(picked));
  }

  Future<void> _addDayOff() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 180)),
    );
    if (d == null || _off.any((x) => _iso(x) == _iso(d))) return;
    setState(() => _off
      ..add(d)
      ..sort());
  }

  Future<void> _save() async {
    for (final d in _days) {
      final h = _hours[d.$1];
      if (h != null && h[0].compareTo(h[1]) >= 0) {
        setState(() =>
            _error = '${d.$2}: the end time must be after the start time.');
        return;
      }
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.from('agent_inspection_settings').upsert({
        'storefront_id': widget.storefrontId,
        'weekly_hours': {
          for (final d in _days)
            if (_hours[d.$1] != null) d.$1: _hours[d.$1],
        },
        'slot_minutes': _slot,
        'min_notice_hours': _notice,
        'days_off': [for (final d in _off) _iso(d)],
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Could not save your inspection times. Try again.';
        });
      }
    }
  }

  Widget _segment<T>(
      FlutterFlowTheme t, List<(T, String)> opts, T value, ValueChanged<T> on) {
    return Row(children: [
      for (final o in opts)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: SizedBox(
                  width: double.infinity,
                  child: Text(o.$2, textAlign: TextAlign.center)),
              selected: value == o.$1,
              showCheckmark: false,
              selectedColor: t.secondary,
              backgroundColor: t.secondaryBackground,
              side:
                  BorderSide(color: value == o.$1 ? t.secondary : t.alternate),
              labelStyle: TextStyle(
                  fontSize: 12.5,
                  color: value == o.$1 ? Colors.white : t.primaryText),
              onSelected: (_) => on(o.$1),
            ),
          ),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    Widget head(String s, [String? sub]) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s,
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
            if (sub != null) ...[
              const SizedBox(height: 2),
              Text(sub,
                  style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
            ],
          ]),
        );
    return Scaffold(
      backgroundColor: t.primaryBackground,
      appBar: AppBar(
        backgroundColor: t.secondaryBackground,
        elevation: 1,
        iconTheme: IconThemeData(color: t.primaryText),
        title: Text('Inspection times',
            style: TextStyle(
                color: t.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          head('Weekly hours',
              'Students book a time inside these hours. Times are Lagos time.'),
          Container(
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: t.alternate),
            ),
            child: Column(children: [
              for (var i = 0; i < _days.length; i++)
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                  decoration: BoxDecoration(
                    border: i == 0
                        ? null
                        : Border(top: BorderSide(color: t.alternate)),
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 92,
                      child: Text(_days[i].$2,
                          style: TextStyle(
                              color: _hours[_days[i].$1] == null
                                  ? t.secondaryText
                                  : t.primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5)),
                    ),
                    Expanded(
                      child: _hours[_days[i].$1] == null
                          ? Text('Closed',
                              style: TextStyle(
                                  color: t.secondaryText, fontSize: 13))
                          : Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        minimumSize: const Size(0, 40)),
                                    onPressed: () => _pickTime(_days[i].$1, 0),
                                    child:
                                        Text(_pretty(_hours[_days[i].$1]![0])),
                                  ),
                                  Text('–',
                                      style: TextStyle(color: t.secondaryText)),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        minimumSize: const Size(0, 40)),
                                    onPressed: () => _pickTime(_days[i].$1, 1),
                                    child:
                                        Text(_pretty(_hours[_days[i].$1]![1])),
                                  ),
                                ]),
                    ),
                    Switch(
                      value: _hours[_days[i].$1] != null,
                      activeColor: t.secondary,
                      onChanged: (v) => setState(() =>
                          _hours[_days[i].$1] = v ? ['09:00', '17:00'] : null),
                    ),
                  ]),
                ),
            ]),
          ),
          head('Each inspection takes'),
          _segment<int>(t, const [(30, '30 minutes'), (60, '1 hour')], _slot,
              (v) => setState(() => _slot = v)),
          head('Book at least',
              'How much notice you need before an inspection.'),
          _segment<int>(t, const [(1, '1 hour'), (3, '3 hours'), (24, '1 day')],
              _notice, (v) => setState(() => _notice = v)),
          head('Days off',
              'No bookings on these dates, e.g. travel or holidays.'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final d in _off)
              InputChip(
                label: Text(_date(d)),
                onDeleted: () => setState(() => _off.remove(d)),
                backgroundColor: t.secondaryBackground,
                side: BorderSide(color: t.alternate),
                labelStyle: TextStyle(color: t.primaryText, fontSize: 12.5),
              ),
            ActionChip(
              avatar: Icon(Icons.add_rounded, size: 18, color: t.secondary),
              label: Text('Add a day off',
                  style: TextStyle(color: t.secondary, fontSize: 12.5)),
              backgroundColor: t.secondaryBackground,
              side: BorderSide(color: t.secondary.withValues(alpha: 0.5)),
              onPressed: _addDayOff,
            ),
          ]),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!, style: TextStyle(color: t.error, fontSize: 13)),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _busy ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.secondary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white))
                  : const Text('Save inspection times',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ),
      ),
    );
  }
}
