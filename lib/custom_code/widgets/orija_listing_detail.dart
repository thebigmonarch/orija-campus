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
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/custom_icons.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/report_bottom_sheet_widget.dart';
import '/custom_code/widgets/orija_bag_intro.dart';
import '/custom_code/widgets/orija_listing_save_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_youtube_player.dart';

/// Listing detail, rebuilt in custom code with the same look as before (full
/// bleed photo hero with the title and seller over it, price beside a stats
/// pill, Description, Listing Details, and the bottom bar). What changed:
///
/// Fixed
///  * The quantity stepper did `stockQuantity!`, so any listing without a
///    stock number (every service) crashed the page.
///  * "Add to bag" never checked whether the item was already in your bag.
///  * Category / sub-category printed as raw slugs ("food-drinks"), the
///    condition as lowercase, an empty description as the text "null", and a
///    seller with no reviews as five dim stars.
///  * Unavailable and sold-out listings still offered "Add to bag".
///  * Your own views were counted.
/// Added
///  * Share, save, and report; a seller card with Follow, Message and Visit
///    store; Make an offer on negotiable listings; real review previews;
///    delivery and size info; "More from this store" and "Similar" rows;
///    honest low-stock and sold-out states; a buyer-protection note.
///  * Services get "Message to book" instead of a quantity stepper.
///  * Owners get Edit, Pause / Resume, Share and their listing stats.
///  * A more-menu (Hide this listing / Hide all from this seller / Report)
///    instead of a lone Report icon, matching the post card's menu.
class OrijaListingDetail extends StatefulWidget {
  const OrijaListingDetail({
    super.key,
    this.width,
    this.height,
    this.listingId,
    this.storefrontId,
  });

  final double? width;
  final double? height;
  final String? listingId;
  final String? storefrontId;

  @override
  State<OrijaListingDetail> createState() => _OrijaListingDetailState();
}

class _OrijaListingDetailState extends State<OrijaListingDetail> {
  final PageController _pages = PageController();
  int _page = 0;

  bool _loading = true;
  Map<String, dynamic>? _l; // listing_summary row
  Map<String, dynamic> _x = {}; // extra listing columns
  Map<String, dynamic>? _store;
  String? _categoryName;
  String? _subcategoryName;
  List<Map<String, dynamic>> _attrDefs =
      []; // category_attribute_defs, category + subcategory rows
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> _moreFromStore = [];
  List<Map<String, dynamic>> _similar = [];

  bool _following = false;
  bool _descOpen = false;
  int _qty = 1;
  bool _busy = false;

  // bag state
  String? _bagItemId;
  String? _bagId;
  String? _bagStatus;
  int _bagQty = 1;

  SupabaseClient get _db => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------- loading

  Future<void> _load() async {
    final id = widget.listingId;
    if (id == null || id.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    try {
      final summary =
          await _db.from('listing_summary').select().eq('id', id).maybeSingle();
      if (summary == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      final l = Map<String, dynamic>.from(summary);
      final storeId = (l['storefront_id'] as String?) ?? widget.storefrontId;
      final isOwner = l['vendor_id'] == currentUserUid;

      final extra = await _db
          .from('listings')
          .select(
              'is_negotiable, size_band, weight_kg, is_fragile, delivery_method, service_mode, attributes, primary_image_url, photos, is_made_to_order, return_policy_tier')
          .eq('id', id)
          .maybeSingle();
      // Orija Campus: a hostel room type opens on its hostel page.
      final hostelId = (extra?['attributes'] as Map?)?['hostel_id'];
      if (hostelId != null && '$hostelId'.isNotEmpty && mounted) {
        context.pushReplacementNamed('hostelPage',
            queryParameters: {'hostelId': '$hostelId'});
        return;
      }
      final store = storeId == null
          ? null
          : await _db
              .from('storefronts_with_review_summary')
              .select(
                  'id, name, slug, logo_url, city, state, is_verified, avg_rating, review_count:total_reviews, badge_market, market_community_id, return_policy_tier, return_policy_notes, owner_id')
              .eq('id', storeId)
              .maybeSingle();
      final marketId =
          store == null ? null : store['market_community_id'] as String?;
      final market = marketId == null
          ? null
          : await _db
              .from('communities')
              .select('id, name, slug, is_verified')
              .eq('id', marketId)
              .maybeSingle();
      // "Sold by" shows the individual seller (their own name/photo), not
      // just the business branding -- buyers are trusting a person, and
      // the storefront card already has its own full identity on the
      // storefront page itself.
      final ownerId = store == null ? null : store['owner_id'] as String?;
      final owner = ownerId == null
          ? null
          : await _db
              .from('user_public_profile')
              .select('first_name, last_name, avatar_url')
              .eq('id', ownerId)
              .maybeSingle();

      final category = l['category'] as String?;
      final sub = l['subcategory'] as String?;
      String? catName, subName;
      if (category != null && category.isNotEmpty) {
        final c = await _db
            .from('categories')
            .select('name')
            .eq('slug', category)
            .maybeSingle();
        catName = c?['name'] as String?;
        if (sub != null && sub.isNotEmpty) {
          final s = await _db
              .from('subcategories')
              .select('name')
              .eq('slug', sub)
              .eq('category_slug', category)
              .maybeSingle();
          subName = s?['name'] as String?;
        }
        final defs = await _db
            .from('category_attribute_defs')
            .select()
            .eq('category_slug', category)
            .order('sort_order', ascending: true);
        _attrDefs = List<Map<String, dynamic>>.from(defs).where((d) {
          final s2 = d['subcategory_slug'] as String?;
          return s2 == null || s2 == sub;
        }).toList();
      }

      final reviews = storeId == null
          ? <dynamic>[]
          : await _db
              .from('reviews')
              .select(
                  'id, overall_rating, comment, created_at, vendor_reply, users!reviews_reviewer_id_fkey(first_name, last_name, avatar_url, oja_tier, oja_tier_title)')
              .eq('storefront_id', storeId)
              .eq('status', 'visible')
              .order('created_at', ascending: false)
              .limit(3);

      final more = storeId == null
          ? <dynamic>[]
          : await _db
              .from('listings')
              .select(
                  'id, title, price, primary_image_url, photos, storefront_id')
              .eq('storefront_id', storeId)
              .eq('is_available', true)
              .neq('id', id)
              .order('created_at', ascending: false)
              .limit(10);
      final similar = (category == null || category.isEmpty)
          ? <dynamic>[]
          : await _db
              .from('listings')
              .select(
                  'id, title, price, primary_image_url, photos, storefront_id')
              .eq('category', category)
              .eq('is_available', true)
              .neq('id', id)
              .neq('storefront_id', storeId ?? '')
              .order('created_at', ascending: false)
              .limit(10);

      var following = false;
      String? bagItemId, bagId, bagStatus;
      var bagQty = 1;
      // An anonymous viewer has no uid to filter these by -- `currentUserUid`
      // is '' when signed out, and eq()-ing a uuid column against '' throws
      // a Postgres cast error that used to abort the whole load.
      if (!isOwner && currentUserUid.isNotEmpty) {
        if (storeId != null) {
          final f = await _db
              .from('follows')
              .select('storefront_id')
              .eq('follower_id', currentUserUid)
              .eq('storefront_id', storeId)
              .limit(1);
          following = (f as List).isNotEmpty;
        }
        final bag = await _db
            .from('bag_items')
            .select('id, bag_id, quantity, bags!inner(status)')
            .eq('buyer_id', currentUserUid)
            .eq('listing_id', id)
            // Items of finished bags (ordered, cancelled, abandoned) stay in the
            // table for the record; only an open bag means "in your bag".
            .inFilter(
                'bags.status', const ['draft', 'sent', 'vendor_confirmed'])
            .order('created_at', ascending: false)
            .limit(1);
        final rows = bag as List;
        if (rows.isNotEmpty) {
          final b = Map<String, dynamic>.from(rows.first as Map);
          bagItemId = b['id'] as String?;
          bagId = b['bag_id'] as String?;
          bagQty = (b['quantity'] as num?)?.toInt() ?? 1;
          bagStatus =
              b['bags'] is Map ? (b['bags'] as Map)['status'] as String? : null;
        }
      }
      if (!isOwner) {
        // Views: your own don't count; the database drops duplicates.
        // Anonymous visitors send a real SQL NULL (not '') so the dedupe
        // trigger -- which treats a NULL viewer as "never dedupe" -- still
        // counts each of their visits.
        _db.from('listing_views').insert({
          'listing_id': id,
          'storefront_id': storeId,
          'viewer_id': currentUserUid.isEmpty ? null : currentUserUid,
        }).then((_) {}, onError: (_) {});
      }

      // listing_summary (the view `l` came from) never carried
      // primary_image_url -- only the multi-photo `photos` array. A listing
      // that only ever got a cover photo set (seed data, or predating the
      // gallery feature) has an empty `photos`, so the hero and the share
      // sheet both rendered as if the listing had no photo at all even
      // though `listings.primary_image_url` was set. Merge it in from the
      // `extra` select instead of reading a column that was never there.
      if (extra != null && extra['primary_image_url'] != null) {
        l['primary_image_url'] = extra['primary_image_url'];
      }
      if (!mounted) return;
      setState(() {
        _l = l;
        _x = extra == null ? {} : Map<String, dynamic>.from(extra);
        _store = store == null
            ? null
            : {
                ...Map<String, dynamic>.from(store),
                if (market != null) 'market_name': market['name'],
                if (market != null) 'market_id': market['id'],
                if (market != null) 'market_is_verified': market['is_verified'],
                if (owner != null)
                  'owner_name': [owner['first_name'], owner['last_name']]
                      .where((e) => e != null && (e as String).isNotEmpty)
                      .join(' '),
                if (owner != null) 'owner_avatar_url': owner['avatar_url'],
              };
        _categoryName = catName;
        _subcategoryName = subName;
        _reviews = List<Map<String, dynamic>>.from(reviews);
        _moreFromStore = List<Map<String, dynamic>>.from(more);
        _similar = List<Map<String, dynamic>>.from(similar);
        _following = following;
        _bagItemId = bagItemId;
        _bagId = bagId;
        _bagStatus = bagStatus;
        _bagQty = bagQty;
        _loading = false;
      });
    } catch (e) {
      // This single catch wraps the whole load (listing, storefront,
      // reviews, "more from store", similar listings, bag/follow state) --
      // any one query throwing lands here and the page falls back to
      // "This listing isn't available" with zero clue why. That's exactly
      // how an anon-permission error on the reviews' embedded users join
      // silently broke the entire page for signed-out visitors (not just
      // reviews) until it was traced through a debugger session instead
      // of a log line. Logging it costs nothing and would have made that
      // a five-minute fix instead of a long investigation.
      debugPrint('[OrijaListingDetail] _load failed: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  // ------------------------------------------------------------- helpers

  String _naira(num? v) {
    final n = v ?? 0;
    final fixed = n.toStringAsFixed(n % 1 == 0 ? 0 : 2);
    final parts = fixed.split('.');
    final s = parts[0];
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf${parts.length > 1 ? '.${parts[1]}' : ''}';
  }

  String _title(String s) => s
      .replaceAll(RegExp(r'[-_]+'), ' ')
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  String _compact(num? v) {
    final n = (v ?? 0).toDouble();
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.round().toString();
  }

  String _ago(String? iso) {
    final t = DateTime.tryParse(iso ?? '')?.toLocal();
    if (t == null) return '';
    final d = DateTime.now().difference(t);
    if (d.inDays < 1) return 'today';
    if (d.inDays < 30) return '${d.inDays}d ago';
    if (d.inDays < 365) return '${(d.inDays / 30).floor()}mo ago';
    return '${(d.inDays / 365).floor()}y ago';
  }

  void _toast(String m, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(m, style: const TextStyle(color: Colors.white)),
        backgroundColor: error ? FlutterFlowTheme.of(context).error : null,
      ));
  }

  bool get _isOwner => _l?['vendor_id'] == currentUserUid;
  bool get _isService => _l?['type'] == 'services';
  bool get _available => _l?['is_available'] != false;
  int? get _stock => (_l?['stock_quantity'] as num?)?.toInt();
  bool get _soldOut => !_isService && _stock != null && _stock! < 1;
  bool get _canBuy => _available && !_soldOut;
  // Offers are accepted by the server only when is_negotiable is true, so the
  // Make-an-offer button follows that flag alone. The "Negotiable" label also
  // honours pricing_type, because older listings set only that one.
  bool get _canOffer => _x['is_negotiable'] == true;
  bool get _negotiable => _canOffer || _l?['pricing_type'] == 'negotiable';
  num? get _startingPrice => _l?['starting_price'] as num?;
  bool get _fromPrice => _price <= 0 && (_startingPrice ?? 0) > 0;
  num get _price => (_l?['price'] as num?) ?? 0;
  String get _storeId =>
      (_l?['storefront_id'] as String?) ?? widget.storefrontId ?? '';
  bool get _inBag => _bagItemId != null;
  bool get _bagEditable => _bagStatus == null || _bagStatus == 'draft';

  // ---------------------------------------------------------- interactions

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

  Future<void> _addToBag({double? offer, String? note}) async {
    if (_busy) return;
    if (!await _requireAuth()) return;
    setState(() => _busy = true);
    try {
      final res = await _db.rpc('add_to_bag', params: {
        'p_buyer_id': currentUserUid,
        'p_listing_id': widget.listingId,
        'p_storefront_id': _storeId,
        'p_quantity': _isService ? 1 : _qty,
        'p_offer_price': offer ?? _price,
        if (note != null && note.isNotEmpty) 'p_note': note,
      });
      final r =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (!mounted) return;
      final code = r['code'] as String?;
      if (r['success'] == true || code == 'ALREADY_IN_BAG') {
        setState(() {
          _bagItemId = r['bag_item_id'] as String?;
          _bagId = r['bag_id'] as String?;
          _bagStatus = 'draft';
          if (r['success'] == true) _bagQty = _isService ? 1 : _qty;
        });
        final threadId = r['thread_id'] as String?;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // A snackbar with an action can stay up until dismissed, so it is
        // also closed on a timer.
        final snack = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(offer != null && offer != _price
              ? 'Offer added to your bag. Your bag lives in your chat with the seller.'
              : (code == 'ALREADY_IN_BAG'
                  ? 'Already in your bag. Find it in your chat with the seller.'
                  : 'Added to your bag. Your bag lives in your chat with the seller.')),
          action: SnackBarAction(
              label: 'View in chat',
              onPressed: () {
                if ((threadId ?? '').isNotEmpty) {
                  context.pushNamed('OrijaMessageThreadPage',
                      queryParameters: {
                        'threadId': serializeParam(threadId, ParamType.String),
                      }.withoutNulls);
                } else {
                  _openBag();
                }
              }),
        ));
        Future.delayed(const Duration(seconds: 5), () {
          try {
            snack.close();
          } catch (_) {}
        });
        if (code != 'ALREADY_IN_BAG') {
          showOrijaBagIntroOnce(context, threadId: threadId);
        }
      } else {
        _toast('${r['message'] ?? 'Could not add to bag'}', error: true);
      }
    } catch (_) {
      if (mounted)
        _toast('Could not add to bag. Please try again.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Books a service: the buyer says when and where, and (where the price is
  /// negotiable or a "from" price) what they can pay. It goes into the bag, the
  /// seller confirms the price there, and the buyer pays from the same place.
  Future<void> _bookService() async {
    if (_busy) return;
    if (!await _requireAuth()) return;
    final theme = FlutterFlowTheme.of(context);
    final priceController = TextEditingController();
    final noteController = TextEditingController();
    final askPrice = _canOffer || _price <= 0;
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 18, 20, 20 + MediaQuery.viewInsetsOf(sheetContext).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book this service',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
                _price > 0
                    ? 'Listed at ${_naira(_price)}. The seller confirms the final price, then you pay. You confirm the job once it is done.'
                    : 'The seller sends you a price, then you pay. You confirm the job once it is done.',
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 12.5, height: 1.4)),
            const SizedBox(height: 14),
            TextField(
              controller: noteController,
              autofocus: true,
              minLines: 2,
              maxLines: 4,
              style: TextStyle(color: theme.primaryText),
              decoration: InputDecoration(
                labelText: 'When and where do you need it?',
                hintText:
                    'e.g. Saturday morning, my place in Lekki. Any details help.',
                filled: true,
                fillColor: theme.primaryBackground,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (askPrice) ...[
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: theme.primaryText),
                decoration: InputDecoration(
                  prefixText: '₦ ',
                  labelText: _price > 0
                      ? 'Your offer (optional)'
                      : 'Your budget (optional)',
                  filled: true,
                  fillColor: theme.primaryBackground,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final v = double.tryParse(
                      priceController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
                  Navigator.pop(sheetContext,
                      {'offer': v, 'note': noteController.text.trim()});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Send booking request',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
    priceController.dispose();
    noteController.dispose();
    if (result == null || !mounted) return;
    final offer = (result['offer'] as num?)?.toDouble();
    await _addToBag(
        offer: (offer != null && offer > 0) ? offer : null,
        note: result['note'] as String?);
    if (mounted && _inBag) _openBag();
  }

  void _openBag() {
    if (_bagId == null) return;
    context.pushNamed('OrijaBuyerBagPage', queryParameters: {'bagId': _bagId!});
  }

  Future<void> _removeFromBag() async {
    if (_bagItemId == null || _busy) return;
    setState(() => _busy = true);
    try {
      final res = await _db.rpc('remove_bag_item',
          params: {'p_buyer_id': currentUserUid, 'p_item_id': _bagItemId});
      final ok = res is Map && res['success'] == true;
      if (!mounted) return;
      if (ok) {
        setState(() {
          _bagItemId = null;
          _bagId = null;
          _bagStatus = null;
          _qty = 1;
        });
        _toast('Removed from your bag');
      } else {
        _toast(
            '${res is Map ? (res['message'] ?? 'Could not remove') : 'Could not remove'}',
            error: true);
      }
    } catch (_) {
      if (mounted) _toast('Could not remove. Please try again.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setBagQty(int q) async {
    if (_bagItemId == null || _busy || q < 1) return;
    final max = _stock;
    if (max != null && q > max) return _toast('Only $max left in stock.');
    setState(() => _busy = true);
    try {
      final res = await _db.rpc('update_bag_item', params: {
        'p_buyer_id': currentUserUid,
        'p_item_id': _bagItemId,
        'p_quantity': '$q',
      });
      final ok = res is Map && res['success'] == true;
      if (!mounted) return;
      if (ok) {
        setState(() => _bagQty = q);
      } else {
        _toast(
            '${res is Map ? (res['message'] ?? 'Could not update') : 'Could not update'}',
            error: true);
      }
    } catch (_) {
      if (mounted) _toast('Could not update. Please try again.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _message() async {
    if (_storeId.isEmpty) return;
    if (!await _requireAuth()) return;
    try {
      final res = await _db.rpc('openchat_storefront',
          params: {'p_storefront_id': _storeId, 'p_user_id': currentUserUid});
      final r =
          res is Map ? Map<String, dynamic>.from(res) : <String, dynamic>{};
      if (!mounted) return;
      if (r['success'] == true && r['thread_id'] != null) {
        context.pushNamed('OrijaMessageThreadPage',
            queryParameters: {'threadId': '${r['thread_id']}'});
      } else {
        _toast('${r['message'] ?? 'Could not open the chat'}', error: true);
      }
    } catch (_) {
      if (mounted)
        _toast('Could not open the chat. Please try again.', error: true);
    }
  }

  Future<void> _toggleFollow() async {
    if (_storeId.isEmpty) return;
    if (!await _requireAuth()) return;
    final was = _following;
    setState(() => _following = !was);
    try {
      if (was) {
        await _db
            .from('follows')
            .delete()
            .match({'follower_id': currentUserUid, 'storefront_id': _storeId});
      } else {
        await _db.from('follows').insert({
          'follower_id': currentUserUid,
          'storefront_id': _storeId,
          'source': 'listing'
        });
      }
    } catch (_) {
      if (mounted) setState(() => _following = was);
    }
  }

  Future<void> _share() async {
    final l = _l!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShareListingSheet(
        listing: l,
        storeName: _store?['name'] as String?,
        priceLabel:
            _fromPrice ? 'from ${_naira(_startingPrice)}' : _naira(_price),
        specRows: _detailRows(),
      ),
    );
  }

  Future<void> _report() async {
    final id = widget.listingId;
    if (id == null) return;
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: ReportBottomSheetWidget(
            title: 'Listing', reportType: 'listing', targetId: id),
      ),
    );
  }

  /// Hides just this one listing from this viewer's feeds and browse results
  /// going forward (new listing_hides table).
  Future<void> _hideListing() async {
    final id = widget.listingId;
    if (id == null) return;
    try {
      await _db
          .from('listing_hides')
          .upsert({'user_id': currentUserUid, 'listing_id': id});
      if (!mounted) return;
      _toast("Hidden. You won't see this listing in your feed.");
    } catch (_) {
      if (mounted) _toast('Could not hide this listing.', error: true);
    }
  }

  /// Hides every post and listing from this seller going forward (new
  /// user_hides table) -- softer than a block: messaging, following and
  /// visiting their storefront directly still work.
  Future<void> _hideSeller() async {
    final sellerId = _l?['vendor_id'] as String?;
    if (sellerId == null || sellerId.isEmpty) return;
    try {
      await _db
          .from('user_hides')
          .upsert({'user_id': currentUserUid, 'hidden_user_id': sellerId});
      if (!mounted) return;
      _toast("You won't see posts or listings from this seller anymore.");
    } catch (_) {
      if (mounted) _toast('Could not hide this seller.', error: true);
    }
  }

  Future<void> _showMenu() async {
    final theme = FlutterFlowTheme.of(context);
    final sellerName = '${_store?['name'] ?? 'this seller'}';
    Widget tile(IconData icon, String label, VoidCallback action,
            {Color? color}) =>
        ListTile(
          leading: Icon(icon, color: color ?? theme.primaryText),
          title: Text(label,
              style:
                  TextStyle(color: color ?? theme.primaryText, fontSize: 14)),
          onTap: () {
            Navigator.of(context).pop();
            action();
          },
        );
    await showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            tile(Icons.visibility_off_outlined, 'Hide this listing',
                _hideListing),
            tile(Icons.person_off_outlined, 'Hide all from $sellerName',
                _hideSeller),
            tile(Icons.flag_outlined, 'Report listing', _report,
                color: theme.error),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePause() async {
    final now = _available;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(now ? 'Pause this listing?' : 'Resume this listing?'),
        content: Text(now
            ? 'Buyers won\'t be able to see or buy it until you resume it.'
            : 'It will be visible and available to buy again.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(now ? 'Pause' : 'Resume')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _db
          .from('listings')
          .update({'is_available': !now}).eq('id', widget.listingId!);
      if (mounted) setState(() => _l!['is_available'] = !now);
    } catch (_) {
      if (mounted) _toast('Could not update the listing.', error: true);
    }
  }

  Future<void> _makeOffer() async {
    final controller = TextEditingController();
    final noteController = TextEditingController();
    final theme = FlutterFlowTheme.of(context);
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 18, 20, 20 + MediaQuery.viewInsetsOf(sheetContext).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Make an offer',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
                'Asking price ${_naira(_price)}. The seller can accept or counter in your bag.',
                style: TextStyle(
                    color: theme.secondaryText, fontSize: 12.5, height: 1.4)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: [
                for (final pct in [5, 10, 15, 20])
                  ActionChip(
                    label: Text('-$pct%'),
                    onPressed: () => controller.text =
                        (_price * (100 - pct) / 100).round().toString(),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(color: theme.primaryText),
              decoration: InputDecoration(
                prefixText: '₦ ',
                labelText: 'Your offer',
                filled: true,
                fillColor: theme.primaryBackground,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              style: TextStyle(color: theme.primaryText),
              decoration: InputDecoration(
                labelText: 'Note to the seller (optional)',
                filled: true,
                fillColor: theme.primaryBackground,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final v = double.tryParse(
                      controller.text.replaceAll(RegExp(r'[^0-9.]'), ''));
                  if (v == null || v <= 0) return;
                  Navigator.pop(sheetContext,
                      {'offer': v, 'note': noteController.text.trim()});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(_inBag ? 'Update my offer' : 'Add offer to bag',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;
    final offer = (result['offer'] as num).toDouble();
    if (_inBag && _bagEditable) {
      setState(() => _busy = true);
      try {
        final res = await _db.rpc('update_bag_item', params: {
          'p_buyer_id': currentUserUid,
          'p_item_id': _bagItemId,
          'p_offer_price': '$offer',
          if ((result['note'] as String).isNotEmpty) 'p_note': result['note'],
        });
        if (!mounted) return;
        final ok = res is Map && res['success'] == true;
        _toast(
            ok
                ? 'Offer updated'
                : '${res is Map ? (res['message'] ?? 'Could not update the offer') : 'Could not update the offer'}',
            error: !ok);
      } catch (_) {
        if (mounted) _toast('Could not update the offer.', error: true);
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    } else {
      await _addToBag(offer: offer, note: result['note'] as String?);
    }
  }

  void _openListing(Map<String, dynamic> item) {
    context.pushNamed('listingdetailPage', queryParameters: {
      'listingId': '${item['id']}',
      'storefrontId': '${item['storefront_id'] ?? _storeId}',
    });
  }

  // ------------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) {
      return Container(
          color: theme.primaryBackground,
          child:
              Center(child: CircularProgressIndicator(color: theme.primary)));
    }
    if (_l == null) {
      return Container(
        color: theme.primaryBackground,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.primaryText),
                    onPressed: () => context.pop()),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 52, color: theme.secondaryText),
                      const SizedBox(height: 12),
                      Text('This listing isn\'t available.',
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      color: theme.primaryBackground,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hero(theme),
                  if (!_available && !_isOwner)
                    _banner(theme, 'This listing is no longer available.'),
                  if (_isOwner && !_available)
                    _banner(theme, 'Paused. Buyers can\'t see this listing.'),
                  _priceRow(theme),
                  if (!_isOwner &&
                      _canBuy &&
                      !_isService &&
                      _canOffer &&
                      (!_inBag || _bagEditable))
                    _offerRow(theme),
                  if (!_isOwner &&
                      _canBuy &&
                      (_isService || (_negotiable && !_canOffer)))
                    _chatHint(theme),
                  _divider(theme),
                  _sellerCard(theme),
                  if (_youtubeOk) ...[_divider(theme), _video(theme)],
                  if ((_l!['description'] as String? ?? '')
                      .trim()
                      .isNotEmpty) ...[_divider(theme), _description(theme)],
                  _divider(theme),
                  _details(theme),
                  _divider(theme),
                  _reviewsSection(theme),
                  _protection(theme),
                  if (_moreFromStore.isNotEmpty)
                    _row(theme, 'More from ${_store?['name'] ?? 'this store'}',
                        _moreFromStore),
                  if (_similar.isNotEmpty)
                    _row(theme, 'Similar listings', _similar),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _bottomBar(theme),
        ],
      ),
    );
  }

  bool get _youtubeOk {
    final u = (_l?['youtube_url'] as String?)?.trim() ?? '';
    return u.isNotEmpty &&
        (u.contains('youtube.com') || u.contains('youtu.be'));
  }

  Widget _divider(FlutterFlowTheme theme) =>
      Divider(thickness: 2, height: 32, color: theme.alternate);

  Widget _banner(FlutterFlowTheme theme, String text) => Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.error.withValues(alpha: 0.4)),
        ),
        child: Text(text,
            style: TextStyle(color: theme.primaryText, fontSize: 13)),
      );

  Widget _circleButton({required Widget child, VoidCallback? onTap}) => InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
              color: Color(0x82000000), shape: BoxShape.circle),
          child: child,
        ),
      );

  Widget _hero(FlutterFlowTheme theme) {
    final l = _l!;
    // `photos` alone misses listings that only ever got a primary_image_url
    // (seed/demo data, or an older listing predating the multi-photo
    // gallery) -- this was the actual cause of a real, empty-looking hero
    // image on a listing that clearly had a cover photo set.
    final rawPhotos = List<String>.from(l['photos'] as List? ?? []);
    final primary = l['primary_image_url'] as String?;
    final photos = ((primary != null && primary.isNotEmpty)
            ? [primary, ...rawPhotos.where((p) => p != primary)]
            : rawPhotos)
        .map((p) => withListingWatermark(p) ?? '')
        .toList();
    final top = MediaQuery.of(context).padding.top;
    final store = _store;
    final avg =
        ((store?['avg_rating'] ?? l['avg_rating']) as num?)?.toDouble() ?? 0;
    final count =
        ((store?['review_count'] ?? l['review_count']) as num?)?.toInt() ?? 0;
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Positioned.fill(
            child: photos.isEmpty
                ? Container(
                    color: theme.alternate,
                    child: Icon(Icons.image_outlined,
                        size: 56, color: theme.secondaryText))
                : PageView.builder(
                    controller: _pages,
                    itemCount: photos.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => openOrijaImageViewer(context, photos, i),
                      child: Image.network(photos[i],
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit.cover),
                    ),
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 220,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x0086370E),
                      Color(0x9B000000),
                      Colors.black
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: top + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                _circleButton(
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.goNamed('HomePage'),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24),
                ),
                const Spacer(),
                _circleButton(
                    onTap: _share,
                    child: const Icon(FFIcons.kforward,
                        color: Colors.white, size: 20)),
                const SizedBox(width: 8),
                if (!_isOwner) ...[
                  OrijaListingSaveButton(listingId: widget.listingId),
                  const SizedBox(width: 8),
                  _circleButton(
                      onTap: _showMenu,
                      child: const Icon(Icons.more_vert,
                          color: Colors.white, size: 20)),
                ],
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l['title'] as String? ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    final slug = store?['slug'] ?? l['storefront_slug'];
                    if (slug != null)
                      context.pushNamed('storefrontPage',
                          queryParameters: {'storefontslug': '$slug'});
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ((store?['logo_url'] ?? l['storefront_logo_url'])
                                        as String? ??
                                    '')
                                .isEmpty
                            ? Container(
                                color: theme.alternate,
                                child: Icon(Icons.storefront_outlined,
                                    color: theme.secondaryText))
                            : Image.network(
                                (store?['logo_url'] ?? l['storefront_logo_url'])
                                    as String,
                                fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                      '${store?['name'] ?? l['storefront_name'] ?? ''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                ),
                                if (store?['is_verified'] == true) ...[
                                  const SizedBox(width: 4),
                                  Icon(Icons.verified_rounded,
                                      size: 15, color: theme.secondary),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            count == 0
                                ? const Text('No reviews yet',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12))
                                : Row(
                                    children: [
                                      for (var i = 1; i <= 5; i++)
                                        Icon(
                                            i <= avg.round()
                                                ? Icons.star_rounded
                                                : Icons.star_outline_rounded,
                                            size: 18,
                                            color: const Color(0xFFFFC94D)),
                                      const SizedBox(width: 6),
                                      Text(
                                          '${avg.toStringAsFixed(1)} ($count ${count == 1 ? 'review' : 'reviews'})',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (photos.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < photos.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: i == _page ? 18 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: i == _page ? theme.secondary : Colors.white,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _priceRow(FlutterFlowTheme theme) {
    final l = _l!;
    final priceLabel =
        _negotiable ? 'Negotiable' : (_fromPrice ? 'Starting price' : 'Fixed');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                          _fromPrice
                              ? 'From ${_naira(_startingPrice)}'
                              : _naira(_price),
                          style: TextStyle(
                              color: theme.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(priceLabel,
                          style: TextStyle(
                              color: theme.secondaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.alternate),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 4,
                        color: Color(0x7B86370E),
                        offset: Offset(0, 2))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _stat(theme, Icons.visibility_outlined,
                        _compact(l['view_count'] as num?), 'Views'),
                    const SizedBox(width: 14),
                    _stat(theme, Icons.favorite_border_rounded,
                        _compact(l['save_count'] as num?), 'Saves'),
                    const SizedBox(width: 14),
                    _stat(theme, Icons.shopping_bag_outlined,
                        _compact(l['order_count'] as num?), 'Orders'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _chip(theme, _isService ? 'Service' : 'Goods', theme.primary),
              if (!_isService && (_l!['condition'] as String?) != null)
                _chip(
                    theme, _title('${_l!['condition']}'), theme.secondaryText),
              if (l['is_featured'] == true)
                _chip(theme, 'Featured', theme.secondary),
              if (_soldOut)
                _chip(theme, 'Sold out', theme.error)
              else if (!_isService && _stock != null && _stock! <= 5)
                _chip(theme, 'Only $_stock left', theme.error),
              if (_x['is_fragile'] == true)
                _chip(theme, 'Fragile', theme.tertiary),
            ],
          ),
          if (_isOwner)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Posted ${_ago(l['created_at'] as String?)}',
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
            ),
        ],
      ),
    );
  }

  Widget _stat(
          FlutterFlowTheme theme, IconData icon, String value, String label) =>
      Tooltip(
        message: label,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 19, color: theme.primaryText),
            const SizedBox(width: 4),
            Text(value,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _chip(FlutterFlowTheme theme, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
      );

  Widget _offerRow(FlutterFlowTheme theme) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: OutlinedButton.icon(
          onPressed: _makeOffer,
          icon: const Icon(Icons.local_offer_outlined, size: 18),
          label: Text(_inBag ? 'Change my offer' : 'Make an offer'),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.secondary,
            side: BorderSide(color: theme.secondary),
            minimumSize: const Size.fromHeight(44),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );

  /// Services (and older negotiable listings) agree the price and details in
  /// the chat rather than through a bag offer.
  Widget _chatHint(FlutterFlowTheme theme) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _message,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.alternate),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline_rounded,
                    size: 20, color: theme.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                      _isService
                          ? (_negotiable
                              ? 'The price is negotiable. Message the seller to agree the price, date and place.'
                              : 'Message the seller to agree the date, place and any details.')
                          : 'The price is negotiable. Message the seller to agree it.',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12.5,
                          height: 1.4)),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.secondaryText),
              ],
            ),
          ),
        ),
      );

  Widget _sellerCard(FlutterFlowTheme theme) {
    final store = _store;
    if (store == null) return const SizedBox.shrink();
    final place = [store['city'], store['state']]
        .where((e) => e != null && (e as String).isNotEmpty)
        .join(', ');
    final count = (store['review_count'] as num?)?.toInt() ?? 0;
    final avg = (store['avg_rating'] as num?)?.toDouble() ?? 0;
    final ownerName = (store['owner_name'] as String? ?? '').trim();
    final ownerAvatar = store['owner_avatar_url'] as String?;
    // "Sold by" introduces the person a buyer is trusting, not the
    // business -- the storefront's own name/logo/rating/badges already
    // have their full page one tap away via "Visit store" below. There's
    // no personal identity-verification badge (verification lives on the
    // storefront), so no checkmark shows here -- just who you're buying
    // from. Falls back to the storefront name if the owner's profile
    // somehow has no name set, so this never renders blank.
    final displayName = ownerName.isNotEmpty ? ownerName : '${store['name']}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sold by',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 48,
                  height: 48,
                  color: theme.alternate,
                  child: (ownerAvatar ?? '').isEmpty
                      ? Icon(Icons.person_outline, color: theme.secondaryText)
                      : Image.network(ownerAvatar!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700)),
                    Text(
                        [
                          if (place.isNotEmpty) place,
                          count == 0
                              ? 'No reviews yet'
                              : '${avg.toStringAsFixed(1)} ★ ($count)',
                        ].join(' · '),
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 12)),
                    if ((store['market_name'] as String? ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: InkWell(
                          onTap: () {
                            final mid = store['market_id'];
                            if (mid != null) {
                              context.pushNamed('community',
                                  queryParameters: {'communityID': '$mid'});
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.storefront_rounded,
                                  size: 12, color: theme.secondary),
                              const SizedBox(width: 4),
                              Text('${store['market_name']}',
                                  style: TextStyle(
                                      color: theme.secondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                              if (store['market_is_verified'] == true) ...[
                                const SizedBox(width: 3),
                                Icon(Icons.verified_rounded,
                                    size: 11, color: theme.secondary),
                              ],
                            ]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final slug = store['slug'];
                    if (slug != null)
                      context.pushNamed('storefrontPage',
                          queryParameters: {'storefontslug': '$slug'});
                  },
                  style: _smallButton(theme),
                  child: const Text('Visit store'),
                ),
              ),
              if (!_isOwner) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _toggleFollow,
                    style: _smallButton(theme, active: !_following),
                    child: Text(_following ? 'Following' : 'Follow'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _message,
                    icon:
                        const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('Message'),
                    style: _smallButton(theme),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  ButtonStyle _smallButton(FlutterFlowTheme theme, {bool active = false}) =>
      OutlinedButton.styleFrom(
        foregroundColor: active ? theme.primary : theme.primaryText,
        side: BorderSide(color: active ? theme.primary : theme.alternate),
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
      );

  Widget _video(FlutterFlowTheme theme) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Video',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterFlowYoutubePlayer(
                url: (_l!['youtube_url'] as String).trim(),
                width: double.infinity,
                height: 200,
                autoPlay: false,
                looping: true,
                mute: false,
                showControls: true,
                showFullScreen: true,
                strictRelatedVideos: true,
              ),
            ),
          ],
        ),
      );

  Widget _description(FlutterFlowTheme theme) {
    final text = (_l!['description'] as String).trim();
    final long = text.length > 220;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(text,
              maxLines: long && !_descOpen ? 5 : null,
              overflow: long && !_descOpen ? TextOverflow.ellipsis : null,
              style: TextStyle(
                  color: theme.primaryText, fontSize: 14, height: 1.45)),
          if (long)
            TextButton(
              onPressed: () => setState(() => _descOpen = !_descOpen),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
              child: Text(_descOpen ? 'Show less' : 'Read more',
                  style: TextStyle(color: theme.primary)),
            ),
        ],
      ),
    );
  }

  /// Turns the seller-entered attributes jsonb into ['label', 'value'] rows
  /// for the Listing Details table, using _attrDefs for the label and, for
  /// dropdown/choice_chip fields, the human-readable option text.
  List<List<String>> _specRows() {
    final values = _x['attributes'];
    if (values is! Map || values.isEmpty || _attrDefs.isEmpty) return const [];
    final out = <List<String>>[];
    for (final d in _attrDefs) {
      final key = '${d['field_key']}';
      final v = values[key];
      if (v == null || v == '') continue;
      final label = '${d['label'] ?? key}';
      final type = '${d['field_type']}';
      final unit = d['unit'] as String?;
      final options = (d['options'] as List?)
              ?.whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          const <Map<String, dynamic>>[];
      String text;
      switch (type) {
        case 'switch':
          text = v == true ? 'Yes' : 'No';
          break;
        case 'dropdown':
        case 'choice_chip':
          if (v == 'other') {
            final custom = values['${key}_other'];
            text = (custom is String && custom.isNotEmpty) ? custom : 'Other';
          } else {
            final match =
                options.firstWhere((o) => o['value'] == v, orElse: () => {});
            text = '${match['label'] ?? v}';
          }
          break;
        case 'choice_chip_multi':
          if (v is! List || v.isEmpty) continue;
          text = v.map((one) {
            final match =
                options.firstWhere((o) => o['value'] == one, orElse: () => {});
            return '${match['label'] ?? one}';
          }).join(', ');
          break;
        case 'number':
          text = unit != null ? '${v} ${unit}' : '${v}';
          break;
        default:
          text = '${v}';
      }
      out.add([label, text]);
    }
    return out;
  }

  /// The same label/value rows the "Listing Details" section renders, shared
  /// with the share sheet so a shared listing carries its full specification.
  List<List<String>> _detailRows() {
    final l = _l!;
    return <List<String>>[
      ['Listing type', _isService ? 'Service' : 'Goods'],
      if ((l['category'] as String?)?.isNotEmpty == true)
        ['Category', _categoryName ?? _title('${l['category']}')],
      if ((l['subcategory'] as String?)?.isNotEmpty == true)
        ['Sub-category', _subcategoryName ?? _title('${l['subcategory']}')],
      if (!_isService && l['condition'] != null)
        ['Condition', _title('${l['condition']}')],
      if (!_isService && _stock != null)
        ['Stock quantity', _stock! < 1 ? 'Sold out' : '$_stock'],
      if (_isService && (l['turnaround_hours'] as num?) != null)
        ['Typical duration', _duration((l['turnaround_hours'] as num).toInt())],
      if (!_isService && _x['is_made_to_order'] == true) ...[
        ['Fulfilment', 'Made to order'],
        if ((l['turnaround_hours'] as num?) != null)
          [
            'Typical time to make',
            _duration((l['turnaround_hours'] as num).toInt())
          ],
      ],
      ['Return policy', _returnPolicyLabel()],
      if (_isService && (_x['service_mode'] as String?)?.isNotEmpty == true)
        [
          'How it works',
          switch (_x['service_mode']) {
            'remote' => 'Done remotely',
            'at_buyer' => 'At your place',
            _ => 'At the seller’s place'
          }
        ],
      if (!_isService && (_x['delivery_method'] as String?)?.isNotEmpty == true)
        ['Delivery', _title('${_x['delivery_method']}')],
      if (!_isService && (_x['size_band'] as String?)?.isNotEmpty == true)
        ['Package size', _title('${_x['size_band']}')],
      if (!_isService && (_x['weight_kg'] as num?) != null)
        ['Weight', '${_x['weight_kg']} kg'],
      [
        'Price',
        _negotiable ? 'Negotiable' : (_fromPrice ? 'Starting price' : 'Fixed')
      ],
      ..._specRows(),
    ];
  }

  Widget _details(FlutterFlowTheme theme) {
    final rows = _detailRows();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Listing Details',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Expanded(
                      child: Text(r[0],
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 14))),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(r[1],
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(color: theme.primaryText, fontSize: 14)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _duration(int hours) {
    if (hours < 24) return 'About $hours ${hours == 1 ? 'hour' : 'hours'}';
    final d = (hours / 24).round();
    return 'About $d ${d == 1 ? 'day' : 'days'}';
  }

  /// The listing's own override wins; otherwise falls back to the
  /// storefront's default (which the backend always sets, so this never
  /// ends up with nothing to show).
  String _returnPolicyLabel() {
    final tier = (_x['return_policy_tier'] as String?)?.isNotEmpty == true
        ? _x['return_policy_tier'] as String
        : (_store?['return_policy_tier'] as String? ?? 'standard');
    return switch (tier) {
      'none' => 'No returns',
      'extended' => '14-day returns',
      _ => '7-day returns',
    };
  }

  Widget _reviewsSection(FlutterFlowTheme theme) {
    final store = _store;
    final count = (store?['review_count'] as num?)?.toInt() ?? 0;
    final avg = (store?['avg_rating'] as num?)?.toDouble() ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Reviews',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              if (count > 0)
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 18, color: Color(0xFFFFC94D)),
                    const SizedBox(width: 3),
                    Text('${avg.toStringAsFixed(1)} · $count',
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
              'Reviews are for ${store?['name'] ?? 'this store'}, from buyers whose orders were ${_isService ? 'completed' : 'delivered'}.',
              style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
          const SizedBox(height: 10),
          if (_reviews.isEmpty)
            Text('No reviews yet.',
                style: TextStyle(color: theme.secondaryText, fontSize: 13))
          else
            for (final r in _reviews) _review(theme, r),
          if (count > _reviews.length)
            TextButton(
              onPressed: () {
                final slug = store?['slug'];
                if (slug != null)
                  context.pushNamed('storefrontPage',
                      queryParameters: {'storefontslug': '$slug'});
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text('See all $count reviews',
                  style: TextStyle(color: theme.primary)),
            ),
        ],
      ),
    );
  }

  Widget _review(FlutterFlowTheme theme, Map<String, dynamic> r) {
    final u = r['users'] is Map
        ? Map<String, dynamic>.from(r['users'] as Map)
        : <String, dynamic>{};
    final name = [u['first_name'], u['last_name']]
        .where((e) => e != null && (e as String).isNotEmpty)
        .join(' ');
    final rating = (r['overall_rating'] as num?)?.toInt() ?? 0;
    final avatar = u['avatar_url'] as String? ?? '';
    final reviewerTier = (u['oja_tier'] as num?)?.toInt() ?? 0;
    final reviewerTierTitle = u['oja_tier_title'] as String?;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: theme.alternate,
                backgroundImage:
                    avatar.isNotEmpty ? NetworkImage(avatar) : null,
                child: avatar.isEmpty
                    ? Icon(Icons.person, size: 14, color: theme.secondaryText)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name.isEmpty ? 'Buyer' : name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    if (reviewerTier >= 2 &&
                        (reviewerTierTitle ?? '').isNotEmpty)
                      Text(reviewerTierTitle!,
                          style: TextStyle(
                              color: theme.secondary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              for (var i = 1; i <= 5; i++)
                Icon(
                    i <= rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 15,
                    color: const Color(0xFFFFC94D)),
            ],
          ),
          if ((r['comment'] as String? ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(r['comment'] as String,
                style: TextStyle(
                    color: theme.primaryText, fontSize: 13, height: 1.4)),
          ],
          if ((r['vendor_reply'] as String? ?? '').isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller replied',
                      style: TextStyle(
                          color: theme.secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(r['vendor_reply'] as String,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12.5,
                          height: 1.4)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _protection(FlutterFlowTheme theme) => Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_outlined, color: theme.success, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pay safely on Orija',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                      _isService
                          ? 'Your payment is held until the job is done and you confirm it. Keep all payments and chat inside Orija.'
                          : 'Your payment is held until you confirm you\'ve received your order. Keep all payments and chat inside Orija.',
                      style: TextStyle(
                          color: theme.secondaryText,
                          fontSize: 12,
                          height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _row(
      FlutterFlowTheme theme, String title, List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title,
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final it = items[i];
                final photos = List<String>.from(it['photos'] as List? ?? []);
                final img = withListingWatermark(
                        (it['primary_image_url'] as String?)?.isNotEmpty == true
                            ? it['primary_image_url'] as String
                            : (photos.isNotEmpty ? photos.first : '')) ??
                    '';
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openListing(it),
                  child: SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 130,
                            height: 130,
                            color: theme.alternate,
                            child: img.isEmpty
                                ? Icon(Icons.image_outlined,
                                    color: theme.secondaryText)
                                : Image.network(img, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(it['title'] as String? ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText, fontSize: 12)),
                        Text(_naira(it['price'] as num?),
                            style: TextStyle(
                                color: theme.primary,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ bottom bar

  Widget _bottomBar(FlutterFlowTheme theme) {
    Widget bar(List<Widget> children) => Container(
          width: double.infinity,
          color: theme.secondaryBackground,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(children: children),
            ),
          ),
        );

    if (_isOwner) {
      return bar([
        Expanded(
          child: OutlinedButton(
            onPressed: () =>
                context.pushNamed('createlistingPage', queryParameters: {
              'storeforntId': _storeId,
              'listingId': widget.listingId!,
            }),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.secondary,
              side: BorderSide(color: theme.secondary, width: 2),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Edit Listing',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: _togglePause,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.primaryText,
            side: BorderSide(color: theme.alternate, width: 2),
            minimumSize: const Size(0, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(_available ? 'Pause' : 'Resume'),
        ),
      ]);
    }

    final chat = SizedBox(
      width: 48,
      height: 48,
      child: OutlinedButton(
        onPressed: _message,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: theme.primaryText,
          side: BorderSide(color: theme.alternate, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Icon(Icons.chat_bubble_outline_rounded, size: 22),
      ),
    );

    ButtonStyle primary(Color c) => ElevatedButton.styleFrom(
          backgroundColor: c,
          foregroundColor: Colors.white,
          disabledBackgroundColor: theme.alternate,
          disabledForegroundColor: theme.secondaryText,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );

    if (!_canBuy) {
      return bar([
        chat,
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: null,
            style: primary(theme.primary),
            child: Text(_soldOut ? 'Sold out' : 'Currently unavailable'),
          ),
        ),
      ]);
    }

    if (_isService) {
      return bar([
        chat,
        const SizedBox(width: 10),
        Expanded(
          child: _inBag
              ? ElevatedButton.icon(
                  onPressed: _openBag,
                  icon: const Icon(Icons.event_note_outlined, size: 18),
                  label: Text(
                      _bagEditable ? 'View booking' : 'View booking (sent)',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  style: primary(theme.primary),
                )
              : ElevatedButton.icon(
                  onPressed: _busy ? null : _bookService,
                  icon: _busy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.event_available_outlined, size: 18),
                  label: const Text('Book this service',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: primary(theme.primary),
                ),
        ),
        if (_inBag && _bagEditable) ...[
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Cancel booking request',
            onPressed: _busy ? null : _removeFromBag,
            icon: Icon(Icons.delete_outline_rounded, color: theme.error),
          ),
        ],
      ]);
    }

    if (_inBag) {
      return bar([
        _stepper(theme, _bagQty, editable: _bagEditable, onChanged: _setBagQty),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _openBag,
            icon: const Icon(Icons.shopping_bag_outlined, size: 18),
            label: Text(_bagEditable ? 'View bag' : 'View bag (sent)',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            style: primary(theme.primary),
          ),
        ),
        if (_bagEditable) ...[
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Remove from bag',
            onPressed: _busy ? null : _removeFromBag,
            icon: Icon(Icons.delete_outline_rounded, color: theme.error),
          ),
        ],
      ]);
    }

    final max = _stock ?? 99;
    return bar([
      chat,
      const SizedBox(width: 10),
      _stepper(theme, _qty, editable: true, onChanged: (q) {
        if (q > max) return _toast('Only $max left in stock.');
        setState(() => _qty = q);
      }),
      const SizedBox(width: 10),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: _busy ? null : () => _addToBag(),
          icon: _busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.shopping_bag_outlined, size: 18),
          label: const Text('Add to bag',
              style: TextStyle(fontWeight: FontWeight.w600)),
          style: primary(theme.primary),
        ),
      ),
    ]);
  }

  Widget _stepper(FlutterFlowTheme theme, int value,
      {required bool editable, required ValueChanged<int> onChanged}) {
    return Container(
      width: 118,
      height: 48,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.secondary, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: editable && value > 1 ? () => onChanged(value - 1) : null,
            child: Icon(Icons.remove_rounded,
                size: 22,
                color: editable && value > 1
                    ? theme.secondaryText
                    : theme.alternate),
          ),
          Text('$value',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          InkWell(
            onTap: editable ? () => onChanged(value + 1) : null,
            child: Icon(Icons.add_rounded,
                size: 22, color: editable ? theme.primary : theme.alternate),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════ share-listing preview
//
// Shows exactly what will go out -- photo, title/description and the link --
// before handing off to the OS share sheet, instead of silently sharing
// plain text with no image and no link.
class _ShareListingSheet extends StatefulWidget {
  const _ShareListingSheet({
    required this.listing,
    this.storeName,
    required this.priceLabel,
    this.specRows = const [],
  });

  final Map<String, dynamic> listing;
  final String? storeName;
  final String priceLabel;
  final List<List<String>> specRows;

  @override
  State<_ShareListingSheet> createState() => _ShareListingSheetState();
}

class _ShareListingSheetState extends State<_ShareListingSheet> {
  bool _sharing = false;

  String get _imageUrl {
    final primary = widget.listing['primary_image_url'] as String?;
    final photos = List<String>.from(widget.listing['photos'] as List? ?? []);
    final raw = (primary != null && primary.isNotEmpty)
        ? primary
        : (photos.isNotEmpty ? photos.first : '');
    return withListingWatermark(raw) ?? '';
  }

  String get _link {
    final id = Uri.encodeQueryComponent('${widget.listing['id']}');
    // Short link: opens in the right app with a proper preview (campus.orija.app/go).
    return 'https://campus.orija.app/go/l/$id';
  }

  String get _shareText {
    final title = '${widget.listing['title'] ?? ''}';
    final desc = '${widget.listing['description'] ?? ''}'.trim();
    final trimmedDesc =
        desc.length > 220 ? '${desc.substring(0, 220).trim()}...' : desc;
    final priceLine = widget.storeName == null
        ? widget.priceLabel
        : '${widget.priceLabel} from ${widget.storeName}';
    final specs = widget.specRows
        .where((r) => r[0] != 'Price' && r[0] != 'Listing type')
        .take(12)
        .map((r) => '${r[0]}: ${r[1]}')
        .join('\n');
    return [
      '$title -- $priceLine on Orija',
      if (trimmedDesc.isNotEmpty) trimmedDesc,
      if (specs.isNotEmpty) 'Specifications:\n$specs',
      _link,
    ].join('\n\n');
  }

  Future<void> _confirmShare() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      XFile? imageFile;
      final imageUrl = _imageUrl;
      if (imageUrl.isNotEmpty) {
        try {
          final res = await http
              .get(Uri.parse(imageUrl))
              .timeout(const Duration(seconds: 10));
          if (res.statusCode == 200) {
            // XFile.fromData keeps the bytes in memory instead of writing to
            // a temp file -- path_provider's getTemporaryDirectory() throws
            // UnsupportedError on web, which was silently swallowed here and
            // fell back to a text-only share every time this ran in the
            // browser build.
            imageFile = XFile.fromData(res.bodyBytes,
                mimeType: 'image/jpeg',
                name: 'orija_listing_${widget.listing['id']}.jpg');
          }
        } catch (_) {}
      }
      if (imageFile != null) {
        await Share.shareXFiles([imageFile],
            text: _shareText, subject: '${widget.listing['title'] ?? ''}');
      } else {
        // No photo, or the download failed -- still share the text + link
        // rather than blocking the whole action on an image fetch.
        await Share.share(_shareText);
      }
    } catch (_) {
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final title = '${widget.listing['title'] ?? ''}';
    final desc = '${widget.listing['description'] ?? ''}'.trim();
    final imageUrl = _imageUrl;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryBackground,
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
                        color: theme.alternate,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text('Share this listing',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                    widget.specRows.isEmpty
                        ? "Here's what goes out -- photo, description and a link back to it."
                        : "Here's what goes out -- photo, description, specifications and a link back to it.",
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 12.5)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.alternate),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 64,
                          height: 64,
                          color: theme.alternate,
                          child: imageUrl.isEmpty
                              ? Icon(Icons.image_outlined,
                                  color: theme.secondaryText)
                              : Image.network(imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                      Icons.image_outlined,
                                      color: theme.secondaryText)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: theme.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            if (desc.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(desc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: theme.secondaryText,
                                      fontSize: 12)),
                            ],
                            const SizedBox(height: 5),
                            Text(_link,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: theme.secondary, fontSize: 11.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _sharing ? null : _confirmShare,
                    icon: _sharing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(FFIcons.kforward,
                            size: 18, color: Colors.white),
                    label: Text(_sharing ? 'Preparing...' : 'Share',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
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

/// Full-screen, pinch-to-zoom photo viewer usable from any custom widget
/// (listing photos, post photos, ...). Pushed directly with the photo list
/// already in hand -- deliberately NOT routed through the native `imageViewer`
/// page, whose `params.getParam<String>('imageUrl', ..., isList: true)`
/// round-trip through a query string crashed on a null/empty imageUrl list.
void openOrijaImageViewer(
    BuildContext context, List<String> photos, int initialIndex) {
  if (photos.isEmpty) return;
  Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    barrierColor: Colors.black,
    pageBuilder: (_, __, ___) =>
        _OrijaFullscreenImageViewer(photos: photos, initialIndex: initialIndex),
  ));
}

class _OrijaFullscreenImageViewer extends StatefulWidget {
  const _OrijaFullscreenImageViewer(
      {super.key, required this.photos, required this.initialIndex});

  final List<String> photos;
  final int initialIndex;

  @override
  State<_OrijaFullscreenImageViewer> createState() =>
      __OrijaFullscreenImageViewerState();
}

class __OrijaFullscreenImageViewerState
    extends State<_OrijaFullscreenImageViewer> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.photos.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.photos.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    widget.photos[i],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white54,
                        size: 48),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 26),
              ),
            ),
            if (widget.photos.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('${_index + 1}/${widget.photos.length}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
