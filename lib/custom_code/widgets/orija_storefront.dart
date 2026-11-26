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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_bag_intro.dart';
import '/custom_code/widgets/orija_edit_storefront.dart';
import '/custom_code/widgets/orija_share_storefront.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/custom_icons.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// A storefront's public page: cover and logo, name and verified badge, follow,
/// message and share, the description and intro video, the headline numbers
/// (followers, rating, orders) and three tabs: Products, Services and Reviews
/// (the rating breakdown lives there, with likes and replies on each review).
/// The owner also gets edit, payout, community links and a quick "add" menu.
/// It scrolls itself.
class OrijaStorefront extends StatefulWidget {
  const OrijaStorefront({
    super.key,
    this.width,
    this.height,
    required this.storefrontSlug,
  });

  final double? width;
  final double? height;
  final String? storefrontSlug;

  @override
  State<OrijaStorefront> createState() => _OrijaStorefrontState();
}

class _OrijaStorefrontState extends State<OrijaStorefront> {
  final _db = Supabase.instance.client;

  bool _loading = true;
  bool _notFound = false;
  Map<String, dynamic>? _s;
  // Orija Campus label for this store: {label: student|nearby, school}.
  Map<String, dynamic>? _campus;
  List<Map<String, dynamic>> _goods = [];
  List<Map<String, dynamic>> _services = [];
  bool _following = false;
  bool _busyFollow = false;
  bool _hasPayout = false;
  bool _descOpen = false;
  bool _menuOpen = false;
  int _tab = 0;
  // listing id -> bag item, for the listings this buyer already has in a bag.
  final Map<String, Map<String, dynamic>> _bag = {};
  final Set<String> _busy = {};

  bool get _isOwner => _s != null && _s!['owner_id'] == currentUserUid;
  String get _storeId => '${_s?['id'] ?? ''}';

  @override
  void initState() {
    super.initState();
    // A shared link carries the sharer's referral code (?ref=CODE). Keep it so
    // the sign-up form can offer it if this visitor creates an account.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final ref = GoRouterState.of(context).uri.queryParameters['ref'] ?? '';
        if (RegExp(r'^[A-Za-z0-9]{4,20}$').hasMatch(ref)) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('orija_pending_ref', ref.toUpperCase());
        }
      } catch (_) {}
    });
    _load(first: true);
  }

  // ------------------------------------------------------------- loading

  Future<void> _load({bool first = false}) async {
    final slug = widget.storefrontSlug ?? '';
    if (slug.isEmpty) {
      if (mounted)
        setState(() {
          _loading = false;
          _notFound = true;
        });
      return;
    }
    try {
      final row = await _db
          .from('storefronts_with_review_summary')
          .select()
          .eq('slug', slug)
          .maybeSingle();
      if (row == null) {
        if (mounted)
          setState(() {
            _loading = false;
            _notFound = true;
          });
        return;
      }
      final s = Map<String, dynamic>.from(row);
      final id = '${s['id']}';
      final owner = s['owner_id'] == currentUserUid;

      final listings = await _db
          .from('listing_summary')
          .select(
              'id, type, title, description, photos, primary_image_url, price, currency, stock_quantity, pricing_type, starting_price, turnaround_hours, is_available, view_count, created_at, storefront_id')
          .eq('storefront_id', id)
          .order('created_at', ascending: false);
      final all = List<Map<String, dynamic>>.from(listings as List);

      var following = false;
      var hasPayout = false;
      final bag = <String, Map<String, dynamic>>{};
      if (currentUserUid.isNotEmpty) {
        if (!owner) {
          final f = await _db
              .from('follows')
              .select('id')
              .eq('storefront_id', id)
              .eq('follower_id', currentUserUid)
              .limit(1);
          following = (f as List).isNotEmpty;
          final items = await _db
              .from('bag_items')
              .select('id, bag_id, listing_id')
              .eq('buyer_id', currentUserUid)
              .eq('storefront_id', id);
          final list = List<Map<String, dynamic>>.from(items as List);
          if (list.isNotEmpty) {
            final bagIds = list.map((e) => '${e['bag_id']}').toSet().toList();
            final bags = await _db
                .from('bags')
                .select('id, status')
                .filter('id', 'in', '(${bagIds.join(',')})');
            final draft = {
              for (final b in (bags as List))
                if (b['status'] == 'draft') '${b['id']}',
            };
            for (final it in list) {
              if (draft.contains('${it['bag_id']}'))
                bag['${it['listing_id']}'] = it;
            }
          }
        } else {
          final p = await _db
              .from('storefronts')
              .select('paystack_subaccount_code')
              .eq('id', id)
              .maybeSingle();
          hasPayout =
              ((p?['paystack_subaccount_code'] as String?) ?? '').isNotEmpty;
        }
      }

      Map<String, dynamic>? campus;
      try {
        final res = await _db.rpc('get_campus_store_labels', params: {
          'p_storefront_ids': [id]
        });
        if (res is Map && res[id] is Map) {
          campus = Map<String, dynamic>.from(res[id] as Map);
        }
      } catch (_) {}

      if (!mounted) return;
      final goods = all
          .where((l) =>
              l['type'] == 'goods' && (owner || l['is_available'] != false))
          .toList();
      final services = all
          .where((l) =>
              l['type'] == 'services' && (owner || l['is_available'] != false))
          .toList();
      setState(() {
        _s = s;
        _campus = campus;
        _goods = goods;
        _services = services;
        _following = following;
        _hasPayout = hasPayout;
        _bag
          ..clear()
          ..addAll(bag);
        if (first && goods.isEmpty && services.isNotEmpty) _tab = 1;
        // Hostel agents: their hostels come first.
        if (first && '${s['storefront_type']}' == 'agent') _tab = 3;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
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

  void _back() {
    if (_isOwner) {
      context.pushNamed('profilePage');
    } else {
      context.safePop();
    }
  }

  /// Gates an action that needs an account. If the viewer is signed out,
  /// remembers this exact page (path + query) so the auth flow can send
  /// them back here instead of Home once they're signed in, then routes
  /// them into sign up. Returns true only when the caller may proceed now.
  Future<bool> _requireAuth() async {
    if (currentUserUid.isNotEmpty) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'orija_pending_redirect', GoRouterState.of(context).uri.toString());
    } catch (_) {}
    if (!mounted) return false;
    context.pushNamed('signuppage',
        queryParameters: {
          'isSignUp': serializeParam(true, ParamType.bool),
        }.withoutNulls);
    return false;
  }

  Future<void> _toggleFollow() async {
    if (_busyFollow || _isOwner) return;
    if (!await _requireAuth()) return;
    setState(() => _busyFollow = true);
    final was = _following;
    try {
      if (was) {
        await _db
            .from('follows')
            .delete()
            .match({'follower_id': currentUserUid, 'storefront_id': _storeId});
      } else {
        await _db
            .from('follows')
            .insert({'follower_id': currentUserUid, 'storefront_id': _storeId});
      }
      if (!mounted) return;
      setState(() {
        _following = !was;
        final n = (_s!['follower_count'] as num?)?.toInt() ?? 0;
        _s!['follower_count'] = (n + (was ? -1 : 1)).clamp(0, 1 << 30);
      });
    } catch (_) {
      _toast(
          was
              ? 'Could not unfollow. Try again.'
              : 'Could not follow. Try again.',
          error: true);
    } finally {
      if (mounted) setState(() => _busyFollow = false);
    }
  }

  /// Goes straight through the real signed-in user's Supabase session
  /// (not a stale API-Call config carrying a hardcoded anon-role token,
  /// which made openchat_storefront's own `auth.uid() = p_user_id` check
  /// fail every single time with UNAUTHORIZED).
  Future<void> _openChat() async {
    if (!await _requireAuth()) return;
    try {
      final res = await _db.rpc('openchat_storefront', params: {
        'p_user_id': currentUserUid,
        'p_storefront_id': _storeId,
      });
      final r =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (r['success'] == true) {
        if (!mounted) return;
        context.pushNamed('OrijaMessageThreadPage',
            queryParameters: {
              'threadId':
                  serializeParam(r['thread_id'] as String?, ParamType.String),
            }.withoutNulls);
      } else {
        _toast(
            (r['message'] as String?) ?? 'Could not open the chat. Try again.',
            error: true);
      }
    } catch (_) {
      _toast('Could not open the chat. Try again.', error: true);
    }
  }

  Future<void> _share() async {
    final slug = '${_s?['slug'] ?? widget.storefrontSlug ?? ''}';
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => OrijaShareStorefront(slug: slug),
    );
  }

  Future<void> _addToBag(Map<String, dynamic> l) async {
    final id = '${l['id']}';
    if (_busy.contains(id)) return;
    setState(() => _busy.add(id));
    try {
      final price = (l['price'] as num?) ?? 0;
      final res = await _db.rpc('add_to_bag', params: {
        'p_buyer_id': currentUserUid,
        'p_listing_id': id,
        'p_storefront_id': _storeId,
        'p_quantity': 1,
        'p_offer_price': price,
      });
      final r =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (!mounted) return;
      final code = r['code'] as String?;
      if (r['success'] == true || code == 'ALREADY_IN_BAG') {
        setState(() => _bag[id] = {
              'id': r['bag_item_id'],
              'bag_id': r['bag_id'],
              'listing_id': id
            });
        final theme = FlutterFlowTheme.of(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final snack = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(code == 'ALREADY_IN_BAG'
              ? 'Already in your bag. Find it in your chat with the seller.'
              : 'Added to your bag. Your bag lives in your chat with the seller.'),
          backgroundColor: theme.secondary,
          action: SnackBarAction(
            label: 'View in chat',
            textColor: Colors.white,
            onPressed: () => context.pushNamed('OrijaMessageThreadPage',
                queryParameters: {
                  'threadId':
                      serializeParam('${r['thread_id']}', ParamType.String)
                }.withoutNulls),
          ),
        ));
        Future.delayed(const Duration(seconds: 5), () {
          try {
            snack.close();
          } catch (_) {}
        });
        if (code != 'ALREADY_IN_BAG') {
          showOrijaBagIntroOnce(context, threadId: r['thread_id'] as String?);
        }
      } else {
        _toast('${r['message'] ?? 'Could not add to your bag.'}', error: true);
      }
    } catch (_) {
      _toast('Could not add to your bag. Try again.', error: true);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<void> _removeFromBag(Map<String, dynamic> l) async {
    final id = '${l['id']}';
    final item = _bag[id];
    if (item == null || _busy.contains(id)) return;
    setState(() => _busy.add(id));
    try {
      final res = await _db.rpc('remove_bag_item',
          params: {'p_buyer_id': currentUserUid, 'p_item_id': item['id']});
      if (res is Map && res['success'] == true) {
        if (mounted) setState(() => _bag.remove(id));
      } else {
        _toast(
            '${res is Map ? (res['message'] ?? 'Could not remove it.') : 'Could not remove it.'}',
            error: true);
      }
    } catch (_) {
      _toast('Could not remove it. Try again.', error: true);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  void _openListing(Map<String, dynamic> l) {
    context.pushNamed('listingdetailPage',
        queryParameters: {
          'listingId': serializeParam('${l['id']}', ParamType.String),
          'storefrontId': serializeParam(_storeId, ParamType.String),
        }.withoutNulls);
  }

  void _editListing(Map<String, dynamic> l) {
    context.pushNamed('createlistingPage',
        queryParameters: {
          'storeforntId': serializeParam(_storeId, ParamType.String),
          'listingId': serializeParam('${l['id']}', ParamType.String),
        }.withoutNulls);
  }

  // ------------------------------------------------------------- helpers

  String _naira(num? v) {
    final n = (v ?? 0).round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  String _compact(num? v) {
    final n = (v ?? 0).toInt();
    if (n >= 1000000)
      return '${(n / 1000000).toStringAsFixed(n % 1000000 == 0 ? 0 : 1)}M';
    if (n >= 1000)
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    return '$n';
  }

  String? _youtubeId(String? raw) {
    final v = (raw ?? '').trim();
    if (v.isEmpty) return null;
    final m = RegExp(
            r'(?:youtu\.be/|youtube\.com/(?:watch\?(?:.*&)?v=|embed/|shorts/|live/))([A-Za-z0-9_-]{11})')
        .firstMatch(v);
    return m?.group(1);
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
    if (_loading) {
      return Container(
        color: theme.primaryBackground,
        child: Center(child: CircularProgressIndicator(color: theme.secondary)),
      );
    }
    if (_notFound || _s == null) {
      return Container(
        color: theme.primaryBackground,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_outlined,
                  size: 44, color: theme.secondaryText),
              const SizedBox(height: 10),
              Text('This storefront could not be found.',
                  style: TextStyle(color: theme.primaryText, fontSize: 14)),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () => context.safePop(),
                  child: const Text('Go back')),
            ],
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: theme.primaryBackground,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _load,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(theme),
                  _identity(theme),
                  _stats(theme),
                  const SizedBox(height: 16),
                  _tabs(theme),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: _tabBody(theme),
                  ),
                  SizedBox(height: _isOwner ? 96 : 40),
                ],
              ),
            ),
          ),
          if (_isOwner) _ownerMenu(theme),
        ],
      ),
    );
  }

  /// Real labelled buttons in the storefront header: a filled primary action
  /// (Message, or Edit for the owner) and an outlined Share.
  Widget _pillButton(FlutterFlowTheme theme, IconData icon, String label,
          bool filled, VoidCallback onTap) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
                blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))
          ],
        ),
        child: Material(
          color: filled ? theme.primary : theme.secondaryBackground,
          shape: StadiumBorder(
              side:
                  BorderSide(color: filled ? theme.primary : theme.alternate)),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      size: 18,
                      color: filled ? Colors.white : theme.primaryText),
                  const SizedBox(width: 6),
                  Text(label,
                      style: TextStyle(
                          color: filled ? Colors.white : theme.primaryText,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _roundButton(FlutterFlowTheme theme, IconData icon, VoidCallback onTap,
          {String? tooltip}) =>
      Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))
          ],
        ),
        child: Material(
          color: theme.secondaryBackground,
          shape: CircleBorder(side: BorderSide(color: theme.alternate)),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Tooltip(
              message: tooltip ?? '',
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(icon, size: 20, color: theme.primaryText)),
            ),
          ),
        ),
      );

  Widget _header(FlutterFlowTheme theme) {
    final cover = (_s!['cover_url'] as String?) ?? '';
    final logo = (_s!['logo_url'] as String?) ?? '';
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: 292,
      child: Stack(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            clipBehavior: Clip.antiAlias,
            child: cover.isEmpty
                ? Container(
                    color: theme.alternate,
                    child: Icon(Icons.storefront_outlined,
                        size: 56, color: theme.secondaryText))
                : Image.network(cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: theme.alternate)),
          ),
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
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 22),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 0,
            child: Container(
              width: 96,
              height: 96,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.primaryBackground, width: 4),
              ),
              child: logo.isEmpty
                  ? Center(
                      child: Text(
                        (('${_s!['name'] ?? ''}').trim().isEmpty
                                ? '?'
                                : '${_s!['name']}'.trim().substring(0, 1))
                            .toUpperCase(),
                        style: TextStyle(
                            color: theme.secondary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800),
                      ),
                    )
                  : Image.network(logo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.storefront, color: theme.secondaryText)),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 6,
            child: Row(
              children: [
                if (_isOwner)
                  _pillButton(theme, Icons.mode_edit_outlined, 'Edit', true,
                      () {
                    context.pushNamed('editStorefront',
                        queryParameters: {
                          'storefrontID':
                              serializeParam(_storeId, ParamType.String)
                        }.withoutNulls);
                  })
                else
                  _pillButton(theme, Icons.chat_bubble_outline_rounded,
                      'Message', true, _openChat),
                const SizedBox(width: 10),
                _pillButton(theme, FFIcons.kforward, 'Share', false, _share),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // "✓ Student · <school>" or "Nearby · <school>".
  Widget _campusTag(FlutterFlowTheme theme) {
    final student = _campus!['label'] == 'student';
    final school = '${_campus!['school'] ?? ''}'.trim();
    final col = student ? theme.success : theme.tertiary;
    final text = student
        ? (school.isEmpty ? '✓ Student' : '✓ Student · $school')
        : (school.isEmpty ? 'Nearby' : 'Nearby · Near $school');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: col.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(student ? Icons.school_outlined : Icons.storefront_outlined,
              size: 14, color: col),
          const SizedBox(width: 4),
          Flexible(
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: col, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _identity(FlutterFlowTheme theme) {
    final name = '${_s!['name'] ?? ''}';
    final desc = ((_s!['description'] as String?) ?? '').trim();
    // `is_verified` is a DB-generated column that ORs in badge_market too,
    // but a market head's physical-market approval is a different, lesser
    // credential than real document-based verification (ID/CAC/SMEDAN) --
    // a store still needs to go through that process on its own. Checking
    // the three document badges directly (not is_verified, not
    // badge_market) keeps this checkmark meaning only the latter.
    final verified = _s!['badge_identity'] == true ||
        _s!['badge_cac'] == true ||
        _s!['badge_smedan'] == true;
    final place = [_s!['city'], _s!['state']]
        .where((e) => '${e ?? ''}'.trim().isNotEmpty)
        .join(', ');
    final vid = _youtubeId(_s!['youtube_url'] as String?);
    final returnPolicyLabel = switch (_s!['return_policy_tier']) {
      'none' => 'No returns',
      'extended' => '14-day returns',
      _ => '7-day returns',
    };
    final returnPolicyNotes =
        ((_s!['return_policy_notes'] as String?) ?? '').trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 5),
                      Icon(Icons.verified_rounded,
                          size: 20, color: theme.secondary),
                    ],
                  ],
                ),
              ),
              if (!_isOwner) _followButton(theme),
            ],
          ),
          if (place.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.place_outlined,
                    size: 14, color: theme.secondaryText),
                const SizedBox(width: 3),
                Flexible(
                    child: Text(place,
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 12))),
              ],
            ),
          ],
          if (_campus != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: _campusTag(theme),
            ),
          ],
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _descOpen = !_descOpen),
              child: Text(
                desc,
                maxLines: _descOpen ? null : 3,
                overflow:
                    _descOpen ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 12.5, height: 1.4),
              ),
            ),
          ],
          // Agents rent rooms, so no return policy line for them.
          if (_s!['storefront_type'] != 'agent') ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.assignment_return_outlined,
                    size: 14, color: theme.secondaryText),
                const SizedBox(width: 5),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: '$returnPolicyLabel. ',
                            style: TextStyle(
                                color: theme.secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        if (returnPolicyNotes.isNotEmpty)
                          TextSpan(
                              text: returnPolicyNotes,
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (vid != null) ...[
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => launchURL('https://www.youtube.com/watch?v=$vid'),
              child: Container(
                height: 190,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.secondary, width: 2),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                        'https://img.youtube.com/vi/$vid/hqdefault.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: theme.alternate)),
                    Container(color: Colors.black26),
                    const Center(
                        child: Icon(Icons.play_circle_fill_rounded,
                            size: 58, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
          if (_isOwner) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ownerAction(
                    theme,
                    Icons.groups_2_outlined,
                    'Community links',
                    () => context.pushNamed('ConnectStorefront',
                        queryParameters: {
                          'storeID': serializeParam(_storeId, ParamType.String)
                        }.withoutNulls),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ownerAction(
                    theme,
                    Icons.verified_user_outlined,
                    'Business verification',
                    () => context.pushNamed('storefrontVerificationPage',
                        queryParameters: {
                          'storefrontID':
                              serializeParam(_storeId, ParamType.String)
                        }.withoutNulls),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _ownerAction(FlutterFlowTheme theme, IconData icon, String label,
          VoidCallback onTap) =>
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.secondary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: theme.secondary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.secondary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );

  Widget _followButton(FlutterFlowTheme theme) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _busyFollow ? null : _toggleFollow,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: _following ? Colors.transparent : theme.secondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.secondary, width: 1.5),
        ),
        child: _busyFollow
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _following ? theme.secondary : Colors.white))
            : Text(_following ? 'Following' : 'Follow',
                style: TextStyle(
                    color: _following ? theme.secondary : Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _stats(FlutterFlowTheme theme) {
    final rating = (_s!['avg_rating'] as num?)?.toDouble();
    final reviews = (_s!['total_reviews'] as num?)?.toInt() ?? 0;

    Widget cell(String label, Widget value, {VoidCallback? onTap}) => Expanded(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(label,
                      style: TextStyle(
                          color: theme.secondaryText, fontSize: 11.5)),
                  const SizedBox(height: 3),
                  value,
                ],
              ),
            ),
          ),
        );
    TextStyle num_() => TextStyle(
        color: theme.primaryText, fontSize: 16, fontWeight: FontWeight.w800);
    Widget divider() => Container(width: 1, height: 30, color: theme.alternate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          children: [
            cell('Followers',
                Text(_compact(_s!['follower_count'] as num?), style: num_())),
            divider(),
            cell(
              'Rating',
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, size: 17, color: theme.secondary),
                  const SizedBox(width: 3),
                  Text(
                      rating == null || reviews == 0
                          ? '—'
                          : rating.toStringAsFixed(1),
                      style: num_()),
                ],
              ),
              onTap: () => setState(() => _tab = 2),
            ),
            divider(),
            cell('Orders',
                Text(_compact(_s!['total_orders'] as num?), style: num_())),
          ],
        ),
      ),
    );
  }

  Widget _tabs(FlutterFlowTheme theme) {
    final reviews = (_s!['total_reviews'] as num?)?.toInt() ?? 0;
    Widget tab(int i, String label, int? count) {
      final active = _tab == i;
      return Expanded(
        child: InkWell(
          onTap: () => setState(() => _tab = i),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  count == null ? label : '$label ($count)',
                  style: TextStyle(
                    color: active ? theme.secondary : theme.secondaryText,
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Container(
                  height: 2.5,
                  color: active ? theme.secondary : Colors.transparent),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.alternate))),
      child: Row(children: [
        if ('${_s!['storefront_type']}' == 'agent')
          tab(3, 'Accommodation', null)
        else ...[
          tab(0, 'Products', _goods.length),
          tab(1, 'Services', _services.length),
        ],
        tab(2, 'Reviews', reviews),
      ]),
    );
  }

  Widget _tabBody(FlutterFlowTheme theme) {
    switch (_tab) {
      case 1:
        return _servicesList(theme);
      case 2:
        return OrijaStoreReviews(
            storefrontId: _storeId, ownerId: '${_s!['owner_id']}');
      case 3:
        return OrijaHostelsBrowse(storefrontId: _storeId);
      default:
        return _productsGrid(theme);
    }
  }

  Widget _empty(FlutterFlowTheme theme, IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: [
            Icon(icon, size: 40, color: theme.secondaryText),
            const SizedBox(height: 8),
            Text(text,
                style: TextStyle(color: theme.secondaryText, fontSize: 13.5)),
          ],
        ),
      );

  // -------------------------------------------------------------- products

  Widget _productsGrid(FlutterFlowTheme theme) {
    if (_goods.isEmpty) {
      return _empty(theme, Icons.inventory_2_outlined,
          _isOwner ? 'You have no products yet.' : 'No products yet.');
    }
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < _goods.length; i++) {
      (i.isEven ? left : right).add(Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _productTile(theme, _goods[i], i)));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: left)),
        const SizedBox(width: 10),
        Expanded(child: Column(children: right)),
      ],
    );
  }

  Widget _productTile(
      FlutterFlowTheme theme, Map<String, dynamic> l, int index) {
    final id = '${l['id']}';
    final photos =
        (l['photos'] as List?)?.map((e) => '$e').toList() ?? const <String>[];
    final primaryImage = l['primary_image_url'] as String?;
    final image = withListingWatermark(
            (primaryImage != null && primaryImage.isNotEmpty)
                ? primaryImage
                : (photos.isEmpty ? '' : photos.first)) ??
        '';
    final price = (l['price'] as num?) ?? 0;
    final stock = (l['stock_quantity'] as num?)?.toInt();
    final soldOut = stock != null && stock < 1;
    final paused = l['is_available'] == false;
    final negotiable = l['pricing_type'] == 'negotiable';
    final inBag = _bag.containsKey(id);
    final busy = _busy.contains(id);
    final views = (l['view_count'] as num?)?.toInt() ?? 0;
    final desc = ((l['description'] as String?) ?? '').trim();

    Widget action;
    if (_isOwner) {
      action = _tileButton(theme, 'Edit', () => _editListing(l), filled: false);
    } else if (soldOut) {
      action = _tileButton(theme, 'Sold out', null, filled: false);
    } else if (inBag) {
      action = _tileButton(
          theme, busy ? '…' : 'Added', busy ? null : () => _removeFromBag(l),
          filled: true);
    } else {
      action = _tileButton(
          theme, busy ? '…' : 'Add to Bag', busy ? null : () => _addToBag(l),
          filled: false);
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openListing(l),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: index % 3 == 0 ? 0.92 : (index % 3 == 1 ? 1.1 : 1.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  image.isEmpty
                      ? Container(
                          color: theme.alternate,
                          child: Icon(Icons.image_outlined,
                              color: theme.secondaryText, size: 34))
                      : Image.network(image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: theme.alternate)),
                  if (paused)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Paused',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.5)),
                      ),
                    ),
                  if (!_isOwner)
                    Positioned(
                      top: 6,
                      right: 6,
                      child:
                          OrijaListingSaveButton(listingId: id, compact: true),
                    ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.remove_red_eye_outlined,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(_compact(views),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(_naira(price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.secondary,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 5),
                      Text(negotiable ? 'Negotiable' : 'Fixed',
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 10.5)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${l['title'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.25)),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 11.5,
                            height: 1.3)),
                  ],
                  const SizedBox(height: 10),
                  action,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tileButton(FlutterFlowTheme theme, String label, VoidCallback? onTap,
      {required bool filled}) {
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? theme.secondary : Colors.transparent,
          foregroundColor: filled ? Colors.white : theme.secondary,
          disabledForegroundColor: theme.secondaryText,
          side: BorderSide(
              color:
                  onTap == null && !filled ? theme.alternate : theme.secondary,
              width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(label,
            style:
                const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
      ),
    );
  }

  // -------------------------------------------------------------- services

  Widget _servicesList(FlutterFlowTheme theme) {
    if (_services.isEmpty) {
      return _empty(theme, Icons.handyman_outlined,
          _isOwner ? 'You have no services yet.' : 'No services yet.');
    }
    return Column(
      children: [
        for (final l in _services) ...[
          _serviceTile(theme, l),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  String _duration(int hours) {
    if (hours < 24) return '$hours hr${hours == 1 ? '' : 's'}';
    final d = (hours / 24).round();
    return '$d day${d == 1 ? '' : 's'}';
  }

  Widget _serviceTile(FlutterFlowTheme theme, Map<String, dynamic> l) {
    final photos =
        (l['photos'] as List?)?.map((e) => '$e').toList() ?? const <String>[];
    final primaryImage = l['primary_image_url'] as String?;
    final image = withListingWatermark(
            (primaryImage != null && primaryImage.isNotEmpty)
                ? primaryImage
                : (photos.isEmpty ? '' : photos.first)) ??
        '';
    final price = (l['price'] as num?) ?? 0;
    final from = (l['starting_price'] as num?) ?? 0;
    final hours = (l['turnaround_hours'] as num?)?.toInt();
    final paused = l['is_available'] == false;
    final negotiable = l['pricing_type'] == 'negotiable';
    final desc = ((l['description'] as String?) ?? '').trim();

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openListing(l),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 92,
              height: 92,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: theme.alternate,
                  borderRadius: BorderRadius.circular(10)),
              child: image.isEmpty
                  ? Icon(Icons.handyman_outlined, color: theme.secondaryText)
                  : Image.network(image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('${l['title'] ?? ''}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      ),
                      if (paused)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text('Paused',
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 11)),
                        ),
                    ],
                  ),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.secondaryText,
                            fontSize: 12,
                            height: 1.3)),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price > 0
                            ? _naira(price)
                            : (from > 0
                                ? 'From ${_naira(from)}'
                                : 'Ask for a quote'),
                        style: TextStyle(
                            color: theme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                      if (price > 0 && negotiable) ...[
                        const SizedBox(width: 6),
                        Text('Negotiable',
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 10.5)),
                      ],
                      const Spacer(),
                      if (hours != null) ...[
                        Icon(Icons.schedule_outlined,
                            size: 13, color: theme.secondaryText),
                        const SizedBox(width: 3),
                        Text(_duration(hours),
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 11.5)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: _isOwner
                        ? _tileButton(theme, 'Edit', () => _editListing(l),
                            filled: false)
                        : _tileButton(
                            theme, 'View and book', () => _openListing(l),
                            filled: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------- owner menu

  Widget _ownerMenu(FlutterFlowTheme theme) {
    Widget item(IconData icon, String label, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: theme.secondary,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                setState(() => _menuOpen = false);
                onTap();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5)),
                  ],
                ),
              ),
            ),
          ),
        );

    return Stack(
      children: [
        if (_menuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _menuOpen = false),
              child: Container(color: const Color(0x961E0C00)),
            ),
          ),
        Positioned(
          right: 18,
          bottom: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_menuOpen) ...[
                item(Icons.edit_note_rounded, 'Street post', () {
                  context.pushNamed('createPost',
                      queryParameters: {
                        'storeID': serializeParam(_storeId, ParamType.String)
                      }.withoutNulls);
                }),
                if ('${_s!['storefront_type']}' == 'agent')
                  item(Icons.apartment_rounded, 'My hostels', () {
                    context.pushNamed('myHostels',
                        queryParameters: {
                          'storefrontId':
                              serializeParam(_storeId, ParamType.String)
                        }.withoutNulls);
                  })
                else
                  item(Icons.sell_outlined, 'Create listing', () {
                    context.pushNamed('createlistingPage',
                        queryParameters: {
                          'storeforntId':
                              serializeParam(_storeId, ParamType.String)
                        }.withoutNulls);
                  }),
              ],
              FloatingActionButton(
                heroTag: 'storefront_menu',
                backgroundColor: theme.secondary,
                foregroundColor: Colors.white,
                elevation: 3,
                onPressed: () => setState(() => _menuOpen = !_menuOpen),
                child: Icon(_menuOpen ? Icons.close_rounded : Icons.add_rounded,
                    size: 28),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
