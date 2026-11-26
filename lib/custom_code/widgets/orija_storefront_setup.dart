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

/// Storefront setup, one short step at a time (PageView).
///
///   1 basics        name, description, category, sub-categories
///   2 look & feel   logo + cover (optional)
///   3 contact       phone, state/city/street, market (physical stores only)
///   4 get paid      bank + account number, verified before continuing
///   5 review        create
///
/// Payout is part of setup, not something to do later: buyers' payments are
/// split to the storefront's Paystack subaccount and listings are blocked
/// until one exists. Everything is created by the `seller-setup` function,
/// which verifies the bank account FIRST (a wrong account creates nothing),
/// then creates the storefront as the signed-in user, then the payout account.
/// If only the last step fails the storefront exists and the button turns into
/// "Retry payout setup" rather than creating a second storefront.
///
/// [storeType]: local (physical) | online | declutter | agent.
///
/// Hostel agents (storeType 'agent') get 7 steps: basics (category fixed to
/// Hostels), look, office and location (no market picker; address required),
/// areas and fees, verification (association card required, CAC optional),
/// get paid, review. The store joins the school community as pending: the
/// Market Head approves the agent once.
class OrijaStorefrontSetup extends StatefulWidget {
  const OrijaStorefrontSetup({
    super.key,
    this.width,
    this.height,
    this.storeType,
  });

  final double? width;
  final double? height;
  final String? storeType;

  @override
  State<OrijaStorefrontSetup> createState() => _OrijaStorefrontSetupState();
}

class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});
  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _OrijaStorefrontSetupState extends State<OrijaStorefrontSetup> {
  final _client = Supabase.instance.client;
  final _pages = PageController();

  // Steps by name, so agent stores can add two without renumbering.
  List<String> get _stepIds => _isAgent
      ? const [
          'basics',
          'look',
          'contact',
          'agent',
          'verify',
          'payout',
          'review'
        ]
      : const ['basics', 'look', 'contact', 'payout', 'review'];

  static const _stepTitles = {
    'basics': 'The basics',
    'look': 'Look and feel',
    'contact': 'Contact and location',
    'agent': 'Areas and fees',
    'verify': 'Verification',
    'payout': 'Get paid',
    'review': 'Review',
  };

  List<String> get _titles => [
        for (final id in _stepIds)
          (id == 'contact' && _isAgent)
              ? 'Office and location'
              : _stepTitles[id]!
      ];

  // Hostel agent details (agent stores only).
  final List<String> _areas = [];
  final _areaInput = TextEditingController();
  String _feeType = 'percent';
  final _feeValue = TextEditingController(text: '10');
  final _inspectionFee = TextEditingController(text: '2000');
  Uint8List? _cardBytes;
  String _cardExt = 'jpg';
  Uint8List? _cacBytes;
  String _cacExt = 'jpg';

  int _step = 0;
  bool _loading = true;
  String? _blocked;

  late final String _type;

  // basics
  final _name = TextEditingController();
  final _desc = TextEditingController();
  List<Map<String, String>> _cats = [];
  String? _category;
  List<Map<String, String>> _subOptions = [];
  final Set<String> _subs = {};

  // look
  String? _logoUrl;
  String? _coverUrl;

  // contact
  final _phoneDigits = TextEditingController();
  OrijaLocationValue _loc = const OrijaLocationValue();
  String? _presetState;
  String? _presetCity;
  List<Map<String, dynamic>> _markets = [];
  String? _marketId;

  // Where your store shows: the school community (always on) and up to two
  // optional places, linked right after the store is created.
  String? _schoolName;
  String _schoolLabel = '';
  List<Map<String, dynamic>> _suggest = [];
  final Set<String> _pickedPlaces = {};
  List<Map<String, String>> _shownIn = [];

  // payout
  List<Map<String, String>> _banks = [];
  String? _bankCode;
  final _acct = TextEditingController();
  String? _acctName;
  String? _acctError;
  bool _resolving = false;
  bool _banksFailed = false;

  // submit
  bool _submitting = false;
  String? _error;
  String? _createdId;
  String?
      _linkStoreId; // set once the store exists: the "link to communities" step

  @override
  void initState() {
    super.initState();
    final t = (widget.storeType ?? '').trim().toLowerCase();
    _type = (t == 'local' || t == 'declutter' || t == 'agent') ? t : 'online';
    _bootstrap();
  }

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    _desc.dispose();
    _phoneDigits.dispose();
    _acct.dispose();
    _areaInput.dispose();
    _feeValue.dispose();
    _inspectionFee.dispose();
    super.dispose();
  }

  bool get _isLocal => _type == 'local';
  bool get _isAgent => _type == 'agent';
  List<String> _schoolAreas = [];
  Map<String, dynamic>? _head;

  Future<void> _bootstrap() async {
    try {
      if (_type == 'declutter') {
        final flags = await _client.rpc('get_client_flags');
        final on = flags is Map && flags['declutter_enabled'] == true;
        if (!on) {
          if (!mounted) return;
          setState(() {
            _blocked = 'Declutter storefronts are coming soon.';
            _loading = false;
          });
          return;
        }
      }

      final cats = await _client
          .from('categories')
          .select('slug, name')
          .isFilter('parent_slug', null)
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      final profile = await _client
          .from('users')
          .select('phone, state, city')
          .eq('id', currentUserUid)
          .maybeSingle();

      List markets = const [];
      if (_isLocal) {
        markets = await _client
            .from('communities')
            .select('id, name, city, state')
            .eq('type', 'market')
            .eq('is_active', true)
            .order('name', ascending: true);
      }

      // The school community the store will show in (set at sign-up).
      try {
        final campus = await _client.rpc('get_my_campus_status');
        if (campus is Map && campus['institution_id'] != null) {
          _schoolName = campus['school_name'] as String?;
          _schoolLabel = _isAgent
              ? 'Waiting for the Market Head · Agent'
              : (campus['student_verified'] == true
                  ? 'Live · ✓ Student'
                  : (campus['campus_role'] == 'nearby'
                      ? 'Live · Nearby'
                      : 'Live'));
        }
      } catch (_) {}

      // Agents: the school's area list and the Market Head's contact.
      if (_isAgent) {
        try {
          final info = await _client.rpc('get_my_school_agent_info');
          if (info is Map) {
            _schoolAreas = [
              for (final a in (info['areas'] as List? ?? const [])) '$a'
            ];
            _head = info['head'] is Map
                ? Map<String, dynamic>.from(info['head'] as Map)
                : null;
          }
        } catch (_) {}
      }

      if (!mounted) return;
      setState(() {
        _cats = [
          for (final c in cats)
            {'slug': c['slug'] as String, 'name': c['name'] as String},
        ];
        _phoneDigits.text =
            ngPhoneDigitsFromAny(profile?['phone'] as String? ?? '');
        _presetState = profile?['state'] as String?;
        _presetCity = profile?['city'] as String?;
        _markets = [for (final m in markets) Map<String, dynamic>.from(m)];
        _loading = false;
        if (_isAgent) _category = 'hostels';
      });
      if (_isAgent) _loadSubs('hostels');
      _loadBanks();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _blocked = 'Could not load the setup form. Check your connection.';
        _loading = false;
      });
    }
  }

  Future<void> _loadSubs(String categorySlug) async {
    setState(() {
      _subOptions = [];
      _subs.clear();
    });
    try {
      final rows = await _client
          .from('subcategories')
          .select('slug, name')
          .eq('category_slug', categorySlug)
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      if (!mounted || _category != categorySlug) return;
      setState(() {
        _subOptions = [
          for (final r in rows)
            {'slug': r['slug'] as String, 'name': r['name'] as String},
        ];
      });
    } catch (_) {}
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
      return {
        'success': false,
        'message': 'Something went wrong. Check your connection.',
      };
    }
  }

  Future<void> _loadBanks() async {
    setState(() => _banksFailed = false);
    final d = await _call({'action': 'list_banks'});
    if (!mounted) return;
    final list = d['banks'];
    if (d['success'] == true && list is List) {
      setState(() {
        _banks = [
          for (final b in list)
            {'name': '${b['name']}', 'code': '${b['code']}'},
        ];
      });
    } else {
      setState(() => _banksFailed = true);
    }
  }

  Future<void> _resolve() async {
    final number = _acct.text.trim();
    final bank = _bankCode;
    setState(() {
      _acctName = null;
      _acctError = null;
    });
    if (bank == null || number.length != 10) return;
    setState(() => _resolving = true);
    final d = await _call({
      'action': 'resolve_account',
      'account_number': number,
      'bank_code': bank,
    });
    if (!mounted || _acct.text.trim() != number || _bankCode != bank) return;
    setState(() {
      _resolving = false;
      if (d['success'] == true) {
        _acctName = d['account_name'] as String?;
      } else {
        _acctError = (d['message'] as String?) ??
            'We could not verify that account. Check the number and bank.';
      }
    });
  }

  // ---------------------------------------------------------------- steps

  String? _validate(int step) {
    if (step < 0 || step >= _stepIds.length) return null;
    switch (_stepIds[step]) {
      case 'basics':
        if (_name.text.trim().length < 3) {
          return _isAgent
              ? 'Give your agency a name (at least 3 characters).'
              : 'Give your storefront a name (at least 3 characters).';
        }
        if (_category == null) return 'Choose a category.';
        return null;
      case 'contact':
        if (_phoneDigits.text.trim().length != 10) {
          return 'Enter a phone number buyers and couriers can reach.';
        }
        if (!_loc.hasStateAndCity) return 'Choose your state and city.';
        if (_isLocal && (_loc.address ?? '').isEmpty) {
          return 'Add the street address of your shop.';
        }
        if (_isAgent && (_loc.address ?? '').isEmpty) {
          return 'Add your office address. The Market Head checks it.';
        }
        if (_isLocal && _marketId == null) {
          return 'Choose the market your shop belongs to.';
        }
        return null;
      case 'agent':
        if (_areas.isEmpty) {
          return _schoolAreas.isNotEmpty
              ? 'Choose at least one area you cover.'
              : 'Add at least one area you cover.';
        }
        if (num.tryParse(_feeValue.text.trim()) == null) {
          return 'Enter your agent fee.';
        }
        if (num.tryParse(_inspectionFee.text.trim().replaceAll(',', '')) ==
            null) {
          return 'Enter your inspection fee.';
        }
        return null;
      case 'verify':
        // Optional here: "Skip for now". The Market Head sees it is missing
        // and the agent can add it later in Edit storefront.
        return null;
      case 'payout':
        if (_bankCode == null) return 'Choose your bank.';
        if (_acctName == null) {
          return 'Enter your 10-digit account number so we can verify it.';
        }
        return null;
      default:
        return null;
    }
  }

  void _go(int step) {
    setState(() {
      _step = step;
      _error = null;
    });
    _pages.animateToPage(step,
        duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    if (_stepIds[step] == 'contact' && !_isAgent) _loadSuggestions();
  }

  /// Up to two optional places to also show the store: markets in the same
  /// city (online and declutter stores; physical shops pick their market
  /// above) and the most popular community matching the category.
  Future<void> _loadSuggestions() async {
    try {
      final out = <Map<String, dynamic>>[];
      final city = (_loc.city ?? _presetCity ?? '').trim();
      if (!_isLocal && city.isNotEmpty) {
        final m = await _client
            .from('communities')
            .select('id, name, city, type')
            .eq('type', 'market')
            .eq('is_active', true)
            .ilike('city', city)
            .order('member_count', ascending: false)
            .limit(1);
        out.addAll([for (final r in m) Map<String, dynamic>.from(r)]);
      }
      if (_category != null) {
        final c = await _client
            .from('communities')
            .select('id, name, city, type, member_count')
            .eq('category', _category!)
            .eq('is_active', true)
            .not('type', 'in', '(institution,market)')
            .order('member_count', ascending: false)
            .limit(1);
        out.addAll([for (final r in c) Map<String, dynamic>.from(r)]);
      }
      if (!mounted) return;
      setState(() {
        _suggest = out;
        _pickedPlaces.removeWhere((id) => !out.any((r) => r['id'] == id));
      });
    } catch (_) {}
  }

  Widget _placeRow(FlutterFlowTheme t,
      {required IconData icon,
      required Color tint,
      required String title,
      required String sub,
      Color? subColor,
      Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.alternate),
      ),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              color: tint, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: t.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
              const SizedBox(height: 2),
              Text(sub,
                  style: TextStyle(
                      color: subColor ?? t.secondaryText, fontSize: 12)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ]),
    );
  }

  /// Agents: the school's Market Head, so they can call to speed up approval.
  Widget _headContact(FlutterFlowTheme t) {
    final h = _head;
    final digits = '${h?['phone'] ?? ''}'.replaceAll(RegExp(r'[^0-9]'), '');
    final intl = digits.startsWith('234')
        ? digits
        : (digits.startsWith('0') ? '234${digits.substring(1)}' : digits);
    final name = '${h?['name'] ?? ''}'.trim();
    Widget btn(IconData icon, String label, String url) => Expanded(
          child: SizedBox(
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () => launchURL(url),
              icon: Icon(icon, size: 17, color: t.secondary),
              label: Text(label,
                  style: TextStyle(
                      color: t.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: t.secondary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        );
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.alternate),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.support_agent_rounded, color: t.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.isEmpty ? 'Market Head' : 'Market Head: $name',
                    style: TextStyle(
                        color: t.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(
                    intl.length >= 10
                        ? 'Call or message them after you finish to get approved faster.'
                        : 'They’ll be notified when you finish and review you soon.',
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
              ],
            ),
          ),
        ]),
        if (intl.length >= 10) ...[
          const SizedBox(height: 10),
          Row(children: [
            btn(Icons.call_outlined, 'Call', 'tel:+$intl'),
            const SizedBox(width: 8),
            btn(Icons.chat_outlined, 'WhatsApp', 'https://wa.me/$intl'),
          ]),
        ],
      ]),
    );
  }

  Widget _whereItShows(FlutterFlowTheme t) {
    if (_schoolName == null && _suggest.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 18),
        _label(t, 'Where your store shows'),
        if (_schoolName != null)
          _placeRow(t,
              icon: Icons.school_outlined,
              tint: t.primary,
              title: _schoolName!,
              sub: '$_schoolLabel · your school, always on',
              subColor: t.success,
              trailing: Icon(Icons.lock_outline_rounded,
                  size: 18, color: t.secondaryText)),
        if (_isAgent && _schoolName != null) _headContact(t),
        for (final s in _suggest)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() {
              final id = s['id'] as String;
              _pickedPlaces.contains(id)
                  ? _pickedPlaces.remove(id)
                  : _pickedPlaces.add(id);
            }),
            child: _placeRow(t,
                icon: s['type'] == 'market'
                    ? Icons.storefront_outlined
                    : Icons.groups_outlined,
                tint: s['type'] == 'market' ? t.success : t.tertiary,
                title: '${s['name']}',
                sub: s['type'] == 'market'
                    ? 'Market in ${s['city'] ?? 'your city'}'
                    : 'Matches your category',
                trailing: Icon(
                    _pickedPlaces.contains(s['id'])
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: _pickedPlaces.contains(s['id'])
                        ? t.secondary
                        : t.secondaryText)),
          ),
        Text('You can change this later in Edit storefront.',
            style: TextStyle(color: t.secondaryText, fontSize: 12)),
      ],
    );
  }

  /// Links the ticked places and builds the "Your store shows in" list.
  Future<void> _linkPlaces(String storeId) async {
    final shown = <Map<String, String>>[];
    if (_schoolName != null) {
      shown.add({'name': _schoolName!, 'status': _schoolLabel, 'ok': '1'});
    }
    if (_isLocal && _marketId != null) {
      final m = _markets.firstWhere((e) => e['id'] == _marketId,
          orElse: () => const {});
      shown.add({
        'name': '${m['name'] ?? 'Your market'}',
        'status': 'Waiting for the market head',
        'ok': '0'
      });
    }
    for (final s in _suggest.where((s) => _pickedPlaces.contains(s['id']))) {
      try {
        final r = await _client.rpc('join_my_storefront_to_community',
            params: {'p_storefront_id': storeId, 'p_community_id': s['id']});
        final ok = r is Map && r['success'] == true;
        final pending = r is Map &&
            '${r['code'] ?? r['status'] ?? ''}'
                .toLowerCase()
                .contains('pending');
        shown.add({
          'name': '${s['name']}',
          'status': ok
              ? (pending ? 'Waiting for approval' : 'Showing')
              : '${(r is Map ? r['message'] : null) ?? 'Could not add it'}',
          'ok': ok && !pending ? '1' : '0'
        });
      } catch (_) {
        shown.add(
            {'name': '${s['name']}', 'status': 'Could not add it', 'ok': '0'});
      }
    }
    if (mounted) setState(() => _shownIn = shown);
  }

  void _next() {
    final problem = _validate(_step);
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    _go(_step + 1);
  }

  void _back() {
    if (_step > 0) {
      _go(_step - 1);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('HomePage');
    }
  }

  String _friendly(Map<String, dynamic> d) {
    switch (d['error'] ?? d['code']) {
      case 'subscription_required':
        return 'You need an active plan to open a storefront.';
      case 'storefront_limit_reached':
        return 'Your plan has reached its storefront limit.';
      case 'declutter_coming_soon':
        return 'Declutter storefronts are coming soon.';
      case 'market_community_required':
      case 'invalid_market_community':
        return 'Choose the market your shop belongs to.';
      case 'OTP_REQUIRED':
        return 'Confirm the email code we sent you first.';
    }
    final m = d['message'];
    return m is String && m.isNotEmpty
        ? m
        : 'Could not create your storefront. Try again.';
  }

  Future<void> _submit() async {
    for (var s = 0; s < _stepIds.length; s++) {
      final problem = _validate(s);
      if (problem != null) {
        _go(s);
        setState(() => _error = problem);
        return;
      }
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    if (_createdId != null) {
      // Storefront already exists; only the payout account is missing.
      final d = await _call({
        'action': 'set_payout',
        'storefront_id': _createdId,
        'account_number': _acct.text.trim(),
        'bank_code': _bankCode,
      });
      if (!mounted) return;
      if (d['success'] == true) return _done(_createdId!);
      setState(() {
        _submitting = false;
        _error = _friendly(d);
      });
      return;
    }

    final d = await _call({
      'action': 'create_storefront',
      'name': _name.text.trim(),
      'category': _category,
      'storefront_type': _type,
      'sub_categories': _subs.toList(),
      'description': _desc.text.trim(),
      'country': 'NG',
      'state': _loc.stateName,
      'city': _loc.city,
      'address_line': _loc.address,
      'phone': '+234\${_phoneDigits.text.trim()}',
      'logo_url': _logoUrl,
      'cover_url': _coverUrl,
      if (_isLocal) 'market_community_id': _marketId,
      'account_number': _acct.text.trim(),
      'bank_code': _bankCode,
    });
    if (!mounted) return;

    final id = d['storefront_id'] as String?;
    if (d['success'] == true && id != null) {
      if (d['payout_ok'] == true) return _done(id);
      setState(() {
        _createdId = id;
        _submitting = false;
        _error = (d['payout_error'] as String?) ??
            'Your storefront is created but the payout account is not set up yet.';
      });
      return;
    }
    setState(() {
      _submitting = false;
      _error = _friendly(d);
    });
  }

  /// The store exists. Link the places ticked in step 3, then show where the
  /// store shows before the celebration.
  Future<void> _done(String id) async {
    if (_isAgent) await _saveAgentProfile(id);
    await _linkPlaces(id);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _linkStoreId = id;
    });
  }

  void _finish(String id) {
    context.pushReplacementNamed(
      'celebrationPage',
      queryParameters: {
        'storefrontID': id,
        'storename': _name.text.trim(),
      },
    );
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

  Widget _heading(FlutterFlowTheme t, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: t.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(sub,
              style: TextStyle(
                  color: t.secondaryText, fontSize: 13, height: 1.35)),
        ],
      ),
    );
  }

  Widget _label(FlutterFlowTheme t, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: TextStyle(
                color: t.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      );

  Widget _page(Widget child) {
    return _KeepAlive(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: child,
      ),
    );
  }

  Widget _basics(FlutterFlowTheme t) {
    return _page(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _isAgent
            ? _heading(t, 'Tell us about your agency',
                'Students see this on your hostels. You can change it any time.')
            : _heading(t, 'Tell us about your storefront',
                'This is what buyers see first. You can change it any time.'),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          maxLength: 60,
          style: TextStyle(color: t.primaryText, fontSize: 14),
          decoration: _dec(t, _isAgent ? 'Agency name' : 'Storefront name',
              hint: _isAgent ? 'e.g. Sola Homes' : null),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _desc,
          maxLines: 4,
          maxLength: 400,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(color: t.primaryText, fontSize: 14),
          decoration: _isAgent
              ? _dec(t, 'About your agency',
                  hint:
                      'How long you have been an agent, how students reach you')
              : _dec(t, 'What do you sell?',
                  hint: 'A few lines about your products and your story'),
        ),
        const SizedBox(height: 10),
        if (!_isAgent) _label(t, 'Category'),
        if (!_isAgent)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in _cats)
                ChoiceChip(
                  label: Text(c['name']!),
                  selected: _category == c['slug'],
                  showCheckmark: false,
                  selectedColor: t.secondary,
                  backgroundColor: t.secondaryBackground,
                  side: BorderSide(
                      color:
                          _category == c['slug'] ? t.secondary : t.alternate),
                  labelStyle: TextStyle(
                    fontSize: 12.5,
                    color:
                        _category == c['slug'] ? Colors.white : t.primaryText,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _category = c['slug'];
                      _error = null;
                    });
                    _loadSubs(c['slug']!);
                  },
                ),
            ],
          ),
        if (_subOptions.isNotEmpty) ...[
          const SizedBox(height: 18),
          _label(
              t,
              _isAgent
                  ? 'Room types you handle · ${_subs.length} chosen'
                  : 'Sub-categories · ${_subs.length} of 5 chosen'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
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
                  labelStyle: TextStyle(
                      fontSize: 12.5,
                      color: t.primaryText,
                      fontWeight: _subs.contains(s['slug'])
                          ? FontWeight.w700
                          : FontWeight.w400),
                  onSelected: (on) => setState(() {
                    if (on) {
                      if (_subs.length < (_isAgent ? 6 : 5)) {
                        _subs.add(s['slug']!);
                      }
                    } else {
                      _subs.remove(s['slug']);
                    }
                  }),
                ),
            ],
          ),
        ],
      ],
    ));
  }

  Widget _look(FlutterFlowTheme t) {
    return _page(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(t, 'Make it yours',
            'A logo and a cover photo build trust. Both are optional now.'),
        _label(t, 'Cover photo'),
        OrijaMediaField(
          uploadContext: 'storefront_cover',
          shape: 'wide',
          height: 150,
          label: 'Add a cover photo',
          imageUrl: _coverUrl,
          onSave: (url) async {
            setState(() => _coverUrl = url);
            return true;
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(children: [
            OrijaMediaField(
              uploadContext: 'storefront_logo',
              shape: 'circle',
              width: 104,
              height: 104,
              label: 'Add a logo',
              imageUrl: _logoUrl,
              onSave: (url) async {
                setState(() => _logoUrl = url);
                return true;
              },
            ),
            const SizedBox(height: 8),
            Text('Logo',
                style: TextStyle(color: t.secondaryText, fontSize: 12)),
          ]),
        ),
      ],
    ));
  }

  Widget _contact(FlutterFlowTheme t) {
    return _page(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(
            t,
            _isAgent
                ? 'Where is your office?'
                : (_isLocal
                    ? 'Where is your shop?'
                    : 'Where do you ship from?'),
            _isAgent
                ? 'Students and the Market Head see your office address.'
                : (_isLocal
                    ? 'Buyers find your shop by market and location.'
                    : 'Couriers collect orders from here, so make it accurate.')),
        ngPhoneField(t, _phoneDigits),
        const SizedBox(height: 14),
        OrijaLocationPicker(
          initialState: _loc.stateName ?? _presetState,
          initialCity: _loc.city ?? _presetCity,
          initialAddress: _loc.address,
          onChanged: (v) => _loc = v,
        ),
        if (_isLocal) ...[
          const SizedBox(height: 18),
          _label(t, 'Your market'),
          if (_markets.isEmpty)
            Text('No markets are open for registration yet.',
                style: TextStyle(color: t.secondaryText, fontSize: 13))
          else
            for (final m in _markets)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _marketId = m['id'] as String),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: t.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              _marketId == m['id'] ? t.secondary : t.alternate,
                          width: _marketId == m['id'] ? 1.6 : 1),
                    ),
                    child: Row(children: [
                      Icon(Icons.storefront_outlined,
                          color: t.secondary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${m['name']}',
                                style: TextStyle(
                                    color: t.primaryText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5)),
                            if ((m['city'] ?? '').toString().isNotEmpty)
                              Text('${m['city']}, ${m['state'] ?? ''}',
                                  style: TextStyle(
                                      color: t.secondaryText, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (_marketId == m['id'])
                        Icon(Icons.check_circle, color: t.secondary, size: 20),
                    ]),
                  ),
                ),
              ),
          const SizedBox(height: 4),
          Text(
              'The market head verifies your shop before it shows in the market.',
              style: TextStyle(
                  color: t.secondaryText, fontSize: 12, height: 1.35)),
        ],
        _whereItShows(t),
      ],
    ));
  }

  // ------------------------------------------------------- agent stores only

  Future<void> _pickDoc(bool card) async {
    try {
      final x = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 1800, imageQuality: 85);
      if (x == null) return;
      final bytes = await x.readAsBytes();
      final name = x.name.toLowerCase();
      final ext = name.endsWith('.png') ? 'png' : 'jpg';
      if (!mounted) return;
      setState(() {
        if (card) {
          _cardBytes = bytes;
          _cardExt = ext;
        } else {
          _cacBytes = bytes;
          _cacExt = ext;
        }
        _error = null;
      });
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not open your photos.');
    }
  }

  Future<String?> _uploadDoc(Uint8List? bytes, String ext, String kind) async {
    if (bytes == null) return null;
    final path =
        '$currentUserUid/agent-$kind-${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _client.storage.from('student-ids').uploadBinary(path, bytes,
        fileOptions: FileOptions(
            contentType: ext == 'png' ? 'image/png' : 'image/jpeg',
            upsert: false));
    return path;
  }

  /// Saves areas, fees and the uploaded cards once the agent store exists.
  Future<void> _saveAgentProfile(String storeId) async {
    try {
      final card = await _uploadDoc(_cardBytes, _cardExt, 'card');
      final cac = await _uploadDoc(_cacBytes, _cacExt, 'cac');
      await _client.rpc('upsert_my_agent_profile', params: {
        'p_storefront_id': storeId,
        'p_areas': _areas,
        'p_fee_type': _feeType,
        'p_fee_value': num.tryParse(_feeValue.text.trim()) ?? 0,
        'p_inspection_fee':
            num.tryParse(_inspectionFee.text.trim().replaceAll(',', '')) ?? 0,
        'p_card_path': card,
        'p_cac_path': cac,
      });
    } catch (_) {
      // The store exists; the agent can finish this in Edit storefront.
    }
  }

  Widget _agentStep(FlutterFlowTheme t) {
    void addArea() {
      final v = _areaInput.text.trim();
      if (v.isEmpty || _areas.any((a) => a.toLowerCase() == v.toLowerCase())) {
        return;
      }
      setState(() {
        _areas.add(v);
        _areaInput.clear();
        _error = null;
      });
    }

    return _page(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(t, 'Areas and fees',
            'Students filter hostels by area and see your fees next to the rent.'),
        _label(
            t,
            _schoolAreas.isNotEmpty
                ? 'Areas you cover near ${_schoolName ?? 'the school'} · ${_areas.length} chosen'
                : 'Areas you cover near ${_schoolName ?? 'the school'}'),
        if (_schoolAreas.isNotEmpty)
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final a in _schoolAreas)
              FilterChip(
                label: Text(a),
                selected: _areas.contains(a),
                showCheckmark: false,
                selectedColor: t.secondary,
                backgroundColor: t.secondaryBackground,
                side: BorderSide(
                    color: _areas.contains(a) ? t.secondary : t.alternate),
                labelStyle: TextStyle(
                    fontSize: 12.5,
                    color: _areas.contains(a) ? Colors.white : t.primaryText),
                onSelected: (_) => setState(() {
                  _areas.contains(a) ? _areas.remove(a) : _areas.add(a);
                  _error = null;
                }),
              ),
          ]),
        if (_schoolAreas.isEmpty) ...[
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final a in _areas)
              InputChip(
                label: Text(a),
                onDeleted: () => setState(() => _areas.remove(a)),
                backgroundColor: t.secondary.withValues(alpha: 0.15),
                side: BorderSide(color: t.secondary),
                labelStyle: TextStyle(color: t.primaryText, fontSize: 12.5),
              ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _areaInput,
                textCapitalization: TextCapitalization.words,
                onSubmitted: (_) => addArea(),
                style: TextStyle(color: t.primaryText, fontSize: 14),
                decoration: _dec(t, 'Add an area', hint: 'e.g. Oke-Baale'),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: addArea,
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: t.secondary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text('Add', style: TextStyle(color: t.secondary)),
              ),
            ),
          ]),
        ],
        const SizedBox(height: 18),
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
                  onSelected: (_) => setState(() {
                    _feeType = f.$1;
                    _feeValue.text = f.$1 == 'percent' ? '10' : '20000';
                  }),
                ),
              ),
            ),
        ]),
        const SizedBox(height: 10),
        TextField(
          controller: _feeValue,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: t.primaryText, fontSize: 14),
          decoration: _dec(
              t,
              _feeType == 'percent'
                  ? 'Agent fee (% of rent)'
                  : 'Agent fee (₦)'),
        ),
        const SizedBox(height: 18),
        _label(t, 'Inspection fee'),
        TextField(
          controller: _inspectionFee,
          keyboardType: TextInputType.number,
          style: TextStyle(color: t.primaryText, fontSize: 14),
          decoration: _dec(t, 'Inspection fee (₦)'),
        ),
        const SizedBox(height: 6),
        Text(
            'Students pay it when they book. Orija keeps 10% and the rest goes to your Orija wallet straight away.',
            style:
                TextStyle(color: t.secondaryText, fontSize: 12, height: 1.35)),
      ],
    ));
  }

  Widget _docTile(FlutterFlowTheme t,
      {required String title,
      required String sub,
      required bool required,
      required Uint8List? bytes,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bytes != null
              ? t.success.withValues(alpha: 0.07)
              : t.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: bytes != null
                  ? t.success.withValues(alpha: 0.5)
                  : t.alternate),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 44,
              child: bytes != null
                  ? Image.memory(bytes, fit: BoxFit.cover)
                  : Container(
                      color: t.alternate,
                      child:
                          Icon(Icons.badge_outlined, color: t.secondaryText)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(
                    child: Text(title,
                        style: TextStyle(
                            color: t.primaryText,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                  ),
                  const SizedBox(width: 6),
                  Text(required ? 'Required' : 'Optional',
                      style: TextStyle(
                          color: required ? t.error : t.secondaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 2),
                Text(bytes != null ? 'Added · tap to replace' : sub,
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _verifyStep(FlutterFlowTheme t) {
    return _page(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(t, 'Verification',
            'The ${_schoolName ?? 'school'} Market Head checks these before your hostels show to students. Only they and Orija can see them.'),
        _docTile(t,
            title: 'Association card',
            sub: 'Your estate agents’ association card, with your photo',
            required: true,
            bytes: _cardBytes,
            onTap: () => _pickDoc(true)),
        _docTile(t,
            title: 'CAC certificate',
            sub: 'For registered agencies',
            required: false,
            bytes: _cacBytes,
            onTap: () => _pickDoc(false)),
      ],
    ));
  }

  Widget _payout(FlutterFlowTheme t) {
    return _page(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(t, 'Where should we pay you?',
            'Sales are paid straight to this account. It is needed before you can list anything.'),
        if (_banksFailed)
          InkWell(
            onTap: _loadBanks,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.alternate),
              ),
              child: Text('Could not load banks. Tap to retry.',
                  style: TextStyle(color: t.error, fontSize: 13)),
            ),
          )
        else if (_banks.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.alternate),
            ),
            child: Text('Loading banks…',
                style: TextStyle(color: t.secondaryText, fontSize: 13)),
          )
        else
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
          Row(children: [
            SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: t.secondary)),
            const SizedBox(width: 8),
            Text('Checking the account…',
                style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
          ])
        else if (_acctName != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: t.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Icon(Icons.verified_rounded, color: t.success, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_acctName!,
                    style: TextStyle(
                        color: t.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5)),
              ),
            ]),
          )
        else if (_acctError != null)
          Text(_acctError!, style: TextStyle(color: t.error, fontSize: 12.5)),
        const SizedBox(height: 14),
        Text(
            'Changing this account later needs a code we email to you, so nobody else can redirect your money.',
            style:
                TextStyle(color: t.secondaryText, fontSize: 12, height: 1.35)),
      ],
    ));
  }

  Widget _review(FlutterFlowTheme t) {
    String catName(String? s) => _cats.firstWhere((c) => c['slug'] == s,
        orElse: () => {'name': '—'})['name']!;
    String bankName() => _banks.firstWhere((b) => b['code'] == _bankCode,
        orElse: () => {'name': '—'})['name']!;
    final typeLabel = _isAgent
        ? 'Hostel agent'
        : (_isLocal
            ? 'Physical store'
            : (_type == 'declutter' ? 'Declutter store' : 'Online store'));

    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 104,
                child: Text(k,
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
              ),
              Expanded(
                child: Text(v,
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        );

    return _page(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _heading(t, 'Ready to open?', 'Check the details, then create.'),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.alternate),
          ),
          child: Column(children: [
            row('Type', typeLabel),
            row('Name', _name.text.trim()),
            row('Category', catName(_category)),
            row('Phone', '+234 ${_phoneDigits.text.trim()}'),
            row('Location',
                '${_loc.city ?? ''}, ${_loc.stateName ?? ''}'.trim()),
            if ((_loc.address ?? '').isNotEmpty) row('Address', _loc.address!),
            row('Payout', '${bankName()} · ${_acctName ?? ''}'),
          ]),
        ),
        const SizedBox(height: 12),
        Text(
            'Your first storefront starts with a free trial. Your plan is shown on your profile.',
            style:
                TextStyle(color: t.secondaryText, fontSize: 12, height: 1.35)),
      ],
    ));
  }

  /// After creating the store: suggested communities, with Join & Link.
  Widget _linkStep(FlutterFlowTheme t) {
    return Container(
      color: t.primaryBackground,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: t.success, size: 44),
                    const SizedBox(height: 10),
                    Text('${_name.text.trim()} is ready',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 21,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(
                        'Add your first listing so people have something to buy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: t.secondaryText, fontSize: 13, height: 1.4)),
                    const SizedBox(height: 22),
                    if (_shownIn.isNotEmpty) ...[
                      _label(t, 'Your store shows in'),
                      for (final p in _shownIn)
                        _placeRow(t,
                            icon: p['name'] == _schoolName
                                ? Icons.school_outlined
                                : Icons.groups_outlined,
                            tint: p['name'] == _schoolName
                                ? t.primary
                                : t.tertiary,
                            title: p['name']!,
                            sub: p['status']!,
                            subColor:
                                p['ok'] == '1' ? t.success : t.secondaryText),
                      const SizedBox(height: 4),
                      Text('Change this any time in Edit storefront.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _finish(_linkStoreId!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.secondary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Continue',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    final t = FlutterFlowTheme.of(context);

    if (_loading) {
      return Container(
        color: t.primaryBackground,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: t.secondary),
      );
    }

    if (_blocked != null) {
      return Container(
        color: t.primaryBackground,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_top_rounded, color: t.secondary, size: 44),
              const SizedBox(height: 12),
              Text(_blocked!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _back, child: const Text('Go back')),
            ],
          ),
        ),
      );
    }

    if (_linkStoreId != null) return _linkStep(t);

    final last = _step == _titles.length - 1;
    final label = last
        ? (_createdId != null
            ? 'Retry payout setup'
            : (_isAgent ? 'Create agent account' : 'Create storefront'))
        : (_stepIds[_step] == 'verify' && _cardBytes == null
            ? 'Skip for now'
            : 'Continue');

    return Container(
      color: t.primaryBackground,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(children: [
                IconButton(
                  onPressed: _submitting ? null : _back,
                  icon: Icon(Icons.arrow_back_rounded, color: t.primaryText),
                ),
                Expanded(
                  child: Text(_titles[_step],
                      style: TextStyle(
                          color: t.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                Text('${_step + 1} of ${_titles.length}',
                    style: TextStyle(color: t.secondaryText, fontSize: 12.5)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_step + 1) / _titles.length,
                  minHeight: 4,
                  color: t.secondary,
                  backgroundColor: t.alternate,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PageView(
                controller: _pages,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final id in _stepIds)
                    switch (id) {
                      'basics' => _basics(t),
                      'look' => _look(t),
                      'contact' => _contact(t),
                      'agent' => _agentStep(t),
                      'verify' => _verifyStep(t),
                      'payout' => _payout(t),
                      _ => _review(t),
                    },
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: BoxDecoration(
                color: t.secondaryBackground,
                border: Border(top: BorderSide(color: t.alternate)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(_error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: t.error, fontSize: 12.5)),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : (last ? _submit : _next),
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
                          : Text(label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14.5)),
                    ),
                  ),
                  if (_step == 1)
                    TextButton(
                      onPressed: _next,
                      child: Text('Skip for now',
                          style: TextStyle(color: t.secondaryText)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A phone field fixed to +234 (Nigeria): the prefix is shown, not typed,
/// and only the 10 digits after it are collected. Terminal Africa expects
/// this exact shape for pickup/delivery contacts, so every phone number this
/// app collects is stored the same way rather than however each seller or
/// buyer happens to type theirs.
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
