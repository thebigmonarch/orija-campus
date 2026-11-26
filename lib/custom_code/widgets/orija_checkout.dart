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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';

/// Phase 3 of the delivery rework: checkout, with fulfilment chosen BEFORE
/// payment.
///
/// This replaces `orderProcess`, which was structurally wrong for paying
/// last: it had no pickup branch at all, showed no price until its third
/// screen, wrote the address into global app state (which
/// select_location_widget clears on init), and drove Terminal's
/// orchestrateDelivery — creating addresses, a parcel per item and a
/// shipment for every buyer who merely opened checkout, converted or not.
///
/// The order of operations here is the whole point. Previously the buyer
/// paid `subtotal + buyer_fee`, THEN chose delivery, and terminal_select_rate
/// rewrote `total` to include a shipping fee that had never been charged —
/// so Orija paid every courier bill. Now shipping_fee and total are settled
/// while the order is still `pending_payment`, which means Paystack charges
/// the amount the buyer actually saw and `transaction_charge`
/// (vendor_fee_amt + shipping_fee) routes the shipping portion to Orija
/// instead of the vendor's subaccount.
///
/// Four steps:
///   0. How do you want to get this? — pickup (free) or delivery
///   1. Delivery address — saved addresses, or add one
///   2. Carrier options — live quotes, each with an expiry
///   3. Summary — one total, one pay button
///
/// Pickup never touches Terminal, so it works even while the courier
/// integration is unavailable.
///
/// A made-to-order order is the one exception to "fulfilment before
/// payment": it can't be priced or decided that far ahead (production time
/// varies, and a courier rate doesn't stay valid for hours or days), so
/// checkout skips straight to paying for the item (steps 0-2 never run; see
/// _isMadeToOrder). Once the seller marks it ready, this same widget reopens
/// in a second mode (see _isPostReadyDelivery) to choose + pay for delivery
/// alone -- pickup is offered from a chat card instead, not here.
class OrijaCheckout extends StatefulWidget {
  const OrijaCheckout({
    super.key,
    this.width,
    this.height,
    required this.orderId,
  });

  final double? width;
  final double? height;
  final String? orderId;

  @override
  State<OrijaCheckout> createState() => _OrijaCheckoutState();
}

class _OrijaCheckoutState extends State<OrijaCheckout> {
  final _supabase = Supabase.instance.client;

  /// FlutterFlow's generated page wrapper always passes page params as
  /// nullable, so `orderId` has to be declared `String?` or the web build
  /// fails with "'String?' can't be assigned to the parameter type 'String'".
  /// Everything below wants a plain String, so it is resolved once here and
  /// the empty case is handled in _load().
  String get _orderId => widget.orderId ?? '';

  bool _loading = true;
  String? _loadError;

  Map<String, dynamic>? _order;
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _addresses = [];
  List<Map<String, dynamic>> _quotes = [];

  /// Fulfilment options come from delivery_providers rather than being
  /// hardcoded, so adding Konga / GIG / others later is a row insert and not
  /// a UI change. `kind` decides the behaviour: 'pickup' settles immediately,
  /// 'courier' goes through address → quotes.
  List<Map<String, dynamic>> _providers = [];

  /// False when this order has an item Terminal Africa (or any generalist
  /// courier) cannot carry -- perishable food, a live animal, etc. The
  /// courier provider tiles are then hidden and a notice explains why; the
  /// server also refuses to finalise a courier quote on such an order
  /// regardless of what the client shows (see select_delivery_quote).
  bool _courierEligible = true;

  /// Nigeria for now. Threading this through the state/city fetches (rather
  /// than hardcoding 'NG' at each call site) is what makes an eventual
  /// country picker a small addition instead of a rewrite — the geo source
  /// (Terminal's own country/state/city data) already covers other
  /// countries, only the UI to choose one doesn't exist yet.
  final String _countryCode = 'NG';

  /// {'name': 'Lagos', 'isoCode': 'LA'} pairs, live from Terminal — not a
  /// locally-maintained table. That guarantees an exact match with what
  /// Terminal itself expects when quoting; our own `states` table's "Lagos
  /// State" / "FCT - Abuja State" never matched Terminal's "Lagos" /
  /// "Abuja" cleanly, which is exactly the class of bug this replaces.
  List<Map<String, String>> _stateOptions = [];

  /// False only if the Terminal geo call itself failed (not merely empty) —
  /// distinguishes "no states for this country" from "couldn't reach the
  /// geo service", since the address step needs different messaging for each.
  bool _geoAvailable = true;

  /// The buyer's own profile — used only to prefill the address sheet
  /// (name, phone, state) the first time it opens. Never written back.
  Map<String, dynamic>? _userProfile;

  // Set to true to offer pickup only (no courier). False shows every active
  // delivery provider from delivery_providers, Terminal Africa included.
  static const bool _pickupOnly = false;

  int _step = 0;
  String? _selectedAddressId;
  String? _selectedQuoteId;

  bool _busy = false;
  String? _stepError;

  // Countdown against the selected quote's expiry. Carrier prices go stale,
  // and paying last means the buyer can sit on a price — so the summary
  // shows the remaining time rather than letting the pay button fail later.
  Timer? _ticker;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  // ── Data ──────────────────────────────────────────────────────────────

  Future<void> _load() async {
    // Reached by deep link or a navigation that forgot the param. Say so
    // rather than querying for an empty id and reporting "order not found".
    if (_orderId.isEmpty) {
      setState(() {
        _loading = false;
        _loadError = 'No order was supplied for checkout.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      final order = await _supabase
          .from('v_order_full')
          .select()
          .eq('order_id', _orderId)
          .maybeSingle();

      if (order == null) {
        setState(() {
          _loading = false;
          _loadError = 'This order could not be found.';
        });
        return;
      }

      final items = await _supabase
          .from('order_items')
          .select('id, title, photo_url, quantity, unit_price, currency')
          .eq('order_id', _orderId);

      final addresses = await _supabase
          .from('buyer_addresses')
          .select()
          .eq('user_id', currentUserUid)
          .order('is_default', ascending: false)
          .order('created_at', ascending: false);

      final quotes = await _supabase
          .from('order_delivery_quotes')
          .select()
          .eq('order_id', _orderId)
          .order('amount', ascending: true);

      // Fulfilment tiles read from this table, not a hardcoded pickup/
      // delivery pair, so a new provider (Konga, GIG, ...) is a row insert
      // rather than a UI change.
      final providers = await _supabase
          .from('delivery_providers')
          .select('code, name, kind, tagline, sort_order')
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      bool courierEligible = true;
      try {
        final r = await _supabase
            .rpc('order_courier_eligible', params: {'p_order_id': _orderId});
        courierEligible = r != false;
      } catch (_) {
        // Fetch failed: stay permissive here, the finalize step
        // (select_delivery_quote) still enforces it server-side either way.
      }

      // State/city are sourced live from Terminal's own geo data (now that
      // its account is active), not a locally-maintained table. Two reasons:
      // it's guaranteed to match exactly what Terminal expects when quoting
      // (our own `states` table's "Lagos State" / "FCT - Abuja State" never
      // matched Terminal's own "Lagos" / "Abuja" cleanly), and it already
      // covers every country Terminal operates in — Orija defaults to
      // Nigeria today, but going international later is a country picker
      // bound to this same country_code, not a new geo source.
      final statesRes =
          await GetStateterminalafricaCall.call(countryCode: _countryCode);
      final stateNames =
          GetStateterminalafricaCall.isoCode(statesRes.jsonBody) != null
              ? GetStateterminalafricaCall.name(statesRes.jsonBody) ??
                  const <String>[]
              : const <String>[];
      final stateCodes =
          GetStateterminalafricaCall.isoCode(statesRes.jsonBody) ??
              const <String>[];
      final geoOk = statesRes.succeeded && stateNames.isNotEmpty;

      final profile = await _supabase
          .from('users')
          .select('first_name, last_name, phone, state, city')
          .eq('id', currentUserUid)
          .maybeSingle();

      if (!mounted) return;

      _order = Map<String, dynamic>.from(order);
      _items = List<Map<String, dynamic>>.from(items);
      _addresses = List<Map<String, dynamic>>.from(addresses);
      _quotes = List<Map<String, dynamic>>.from(quotes);
      _providers = List<Map<String, dynamic>>.from(providers);
      _courierEligible = courierEligible;
      if (!courierEligible || _pickupOnly) {
        _providers = _providers.where((p) => p['kind'] == 'pickup').toList();
      }
      _geoAvailable = geoOk;
      _stateOptions = [
        for (var i = 0; i < stateNames.length && i < stateCodes.length; i++)
          {'name': stateNames[i], 'isoCode': stateCodes[i]},
      ]..sort((a, b) => a['name']!.compareTo(b['name']!));
      _userProfile =
          profile == null ? null : Map<String, dynamic>.from(profile);

      _selectedAddressId =
          _addresses.isNotEmpty ? _addresses.first['id'] as String? : null;

      final selected = _quotes.where((q) => q['selected_at'] != null).toList();
      _selectedQuoteId =
          selected.isNotEmpty ? selected.first['id'] as String? : null;

      // Resume where the buyer left off rather than restarting the wizard:
      // a fulfilment already chosen means the only thing left is to pay.
      final method = _order?['delivery_method'] as String?;
      if (_isMadeToOrder && !_paidNow) {
        // Nothing about delivery is decided or shown at checkout for a
        // made-to-order item -- straight to paying for the item. Delivery
        // is chosen separately once the seller marks it ready.
        _step = 3;
      } else if (method == 'pickup' ||
          method == 'service' ||
          method == 'digital' ||
          (method != null && _selectedQuoteId != null)) {
        _step = 3;
      } else if (_isPostReadyDelivery) {
        // Post-ready: pickup is already handled via the chat card, so this
        // screen only ever means delivery -- skip straight to address.
        _step = 1;
      } else {
        _step = 0;
      }

      _startTicker();
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Could not load this order. $e';
      });
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    final q = _selectedQuote;
    if (q == null) return;
    final expires = DateTime.tryParse('${q['expires_at']}')?.toLocal();
    if (expires == null) return;

    void tick() {
      final left = expires.difference(DateTime.now());
      if (!mounted) return;
      setState(() => _remaining = left.isNegative ? Duration.zero : left);
    }

    tick();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  /// "Lagos State" -> "Lagos". `users.state` still carries the old suffixed
  /// form; Terminal's own state names never do.
  String _shortStateName(String raw) {
    final t = raw.trim();
    return t.endsWith(' State') ? t.substring(0, t.length - 6).trim() : t;
  }

  /// Resolves the buyer's profile state against Terminal's real state list
  /// and returns its isoCode (what the dropdown is keyed by, and what a
  /// city lookup needs) — never a display name. Exact match first; a
  /// contains-fallback covers cases like profile "Abuja" vs Terminal's own
  /// "Abuja" already matching exactly, but guards odd historical data.
  /// Returns null rather than guessing — an unmatched state leaves the
  /// dropdown unselected, not pointed at something the buyer didn't pick.
  String? _matchStateCode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final target = _shortStateName(raw).toLowerCase();
    for (final option in _stateOptions) {
      if (option['name']!.toLowerCase() == target) return option['isoCode'];
    }
    for (final option in _stateOptions) {
      final o = option['name']!.toLowerCase();
      if (o.contains(target) || target.contains(o)) return option['isoCode'];
    }
    return null;
  }

  Map<String, dynamic>? get _selectedQuote {
    if (_selectedQuoteId == null) return null;
    final match = _quotes.where((q) => q['id'] == _selectedQuoteId).toList();
    return match.isEmpty ? null : match.first;
  }

  bool get _isPickup => (_order?['delivery_method'] as String?) == 'pickup';

  /// Made to order: the item is produced after payment, so a courier
  /// shouldn't (and won't -- see confirm_order_paid / _service_release)
  /// be booked until the seller actually signals it's ready.
  bool get _isMadeToOrder => _order?['is_made_to_order'] == true;

  bool get _paidNow => (_order?['payment_status'] as String?) == 'completed';

  /// True for the window between the item being paid for and delivery
  /// being paid for on a made-to-order order -- this widget runs in
  /// "choose + pay for delivery only" mode instead of its normal "choose
  /// fulfilment, then pay for everything" mode. Pickup isn't offered here;
  /// it's chosen from the "choose fulfilment" chat card instead (see
  /// choose_pickup_after_ready), so reaching this screen always means
  /// delivery.
  bool get _isPostReadyDelivery =>
      _isMadeToOrder &&
      _paidNow &&
      (_order?['order_status'] as String?) == 'confirmed' &&
      (_order?['delivery_payment_status'] as String?) != 'completed';

  /// A booked service: no address, no carrier, nothing to deliver.
  bool get _isService => (_order?['delivery_method'] as String?) == 'service';

  /// A digital good: no address, no carrier, nothing to ship or pick up --
  /// access is unlocked in chat right after payment.
  bool get _isDigital => (_order?['delivery_method'] as String?) == 'digital';

  bool get _quoteExpired {
    if (_isPickup || _isService) return false;
    final q = _selectedQuote;
    if (q == null) return false;
    final expires = DateTime.tryParse('${q['expires_at']}')?.toLocal();
    return expires != null && expires.isBefore(DateTime.now());
  }

  num get _subtotal => (_order?['subtotal'] as num?) ?? 0;
  num get _buyerFee => (_order?['buyer_fee_amt'] as num?) ?? 0;
  num get _shipping => (_order?['shipping_fee'] as num?) ?? 0;
  num get _total => (_order?['total'] as num?) ?? 0;

  // ── Actions ───────────────────────────────────────────────────────────

  Future<void> _choosePickup() async {
    setState(() {
      _busy = true;
      _stepError = null;
    });
    try {
      final res = await _supabase.rpc('select_pickup_fulfilment', params: {
        'p_buyer_id': currentUserUid,
        'p_order_id': _orderId,
      });
      final ok = res is Map && res['success'] == true;
      if (!mounted) return;
      if (!ok) {
        setState(() {
          _busy = false;
          _stepError = (res is Map ? res['message'] : null)?.toString() ??
              'Could not choose pickup.';
        });
        return;
      }
      await _load();
      if (mounted) setState(() => _busy = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _stepError = 'Could not choose pickup. $e';
      });
    }
  }

  /// Fetches binding quotes for the chosen address. `commit` means
  /// persist_data:true on Terminal's side, so the returned rate can actually
  /// be booked after payment — an estimate's rate id cannot.
  Future<void> _fetchQuotes() async {
    if (_selectedAddressId == null) {
      setState(() => _stepError = 'Choose a delivery address first.');
      return;
    }
    setState(() {
      _busy = true;
      _stepError = null;
    });

    try {
      final res = await _supabase.functions.invoke(
        'delivery-quotes',
        body: {
          'action': 'quote',
          'stage': 'commit',
          'order_id': _orderId,
          'buyer_id': currentUserUid,
          'address_id': _selectedAddressId,
        },
      );

      final data = res.data;
      final ok = data is Map && data['success'] == true;

      if (!mounted) return;

      if (!ok) {
        final code = data is Map ? '${data['code']}' : '';
        setState(() {
          _busy = false;
          _stepError = _quoteErrorMessage(
            code,
            data is Map ? data['message']?.toString() : null,
          );
        });
        return;
      }

      final list = (data['quotes'] as List?) ?? const [];
      setState(() {
        _quotes = list.map((q) => Map<String, dynamic>.from(q as Map)).toList();
        _selectedQuoteId = null;
        _busy = false;
        _step = 2;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _stepError = 'Could not get delivery prices. $e';
      });
    }
  }

  /// Turns the server's code into something a buyer can act on. The size
  /// cases matter most: they mean the seller has not set a parcel size, and
  /// the honest answer is to offer pickup rather than quote a guess.
  String _quoteErrorMessage(String code, String? serverMessage) {
    switch (code) {
      case 'MISSING_ITEM_SIZE':
      case 'NO_SHIPPABLE_ITEMS':
        return 'The seller has not set a parcel size for one or more items, '
            'so delivery cannot be priced yet. You can pick up instead, or '
            'message them to add it.';
      case 'VENDOR_NO_PICKUP_ADDRESS':
        return 'This seller has not set a pickup location, so delivery '
            'cannot be arranged. Message them to sort it out.';
      case 'NO_RATES':
        return 'No carrier can deliver to that address right now. Try '
            'another address, or pick up from the seller.';
      case 'TERMINAL_QUOTE_FAILED':
        return 'Our delivery partner is not responding right now. Try again '
            'shortly, or pick up from the seller.';
      default:
        return serverMessage ?? 'Could not get delivery prices.';
    }
  }

  Future<void> _selectQuote(String quoteId) async {
    setState(() {
      _busy = true;
      _stepError = null;
    });
    try {
      final res = await _supabase.rpc('select_delivery_quote', params: {
        'p_buyer_id': currentUserUid,
        'p_order_id': _orderId,
        'p_quote_id': quoteId,
        // Only actually used for a made-to-order order, where no binding
        // rate is committed here (see the widget-level note near
        // _isMadeToOrder) -- the RPC still needs to know where to ship once
        // the real quote happens later.
        'p_address_id': _selectedAddressId,
      });
      final ok = res is Map && res['success'] == true;
      if (!mounted) return;
      if (!ok) {
        final code = res is Map ? '${res['code']}' : '';
        setState(() {
          _busy = false;
          _stepError = code == 'QUOTE_EXPIRED'
              ? 'That price expired. Fetching fresh options…'
              : (res is Map ? res['message'] : null)?.toString() ??
                  'Could not select that option.';
        });
        if (code == 'QUOTE_EXPIRED') await _fetchQuotes();
        return;
      }
      _selectedQuoteId = quoteId;
      await _load();
      if (mounted) setState(() => _busy = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _stepError = 'Could not select that option. $e';
      });
    }
  }

  Future<void> _pay() async {
    if (_isPostReadyDelivery) return _payDelivery();

    if (_quoteExpired) {
      setState(() => _stepError =
          'Your delivery price expired. Choose a delivery option again.');
      return;
    }

    setState(() {
      _busy = true;
      _stepError = null;
    });

    try {
      final callback =
          'orija://orijahq.com${GoRouterState.of(context).uri.toString()}';
      final res = await InitializePaymentCall.call(
        orderID: _orderId,
        callBackUrl: callback,
      );

      final body = res.jsonBody ?? '';
      final ok =
          (res.succeeded) && (InitializePaymentCall.success(body) ?? false);

      if (!mounted) return;

      if (!ok) {
        // Pull the real server message out before deciding what to tell
        // this buyer -- a missing/invalid vendor subaccount isn't theirs to
        // fix, so flag it for the seller instead (notification + an
        // actionable chat bubble, see payout_setup_needed in
        // OrijaMessageThread) rather than just saying "try again".
        String? serverMsg;
        try {
          final decoded = jsonDecode(body);
          if (decoded is Map) {
            final details = decoded['details'];
            serverMsg =
                (details is Map ? details['message'] as String? : null) ??
                    decoded['error'] as String?;
          }
        } catch (_) {}

        final isPayoutIssue =
            (serverMsg ?? '').toLowerCase().contains('subaccount') ||
                (serverMsg ?? '').toLowerCase().contains('payout account');

        if (isPayoutIssue) {
          try {
            await _supabase.rpc('flag_payout_setup_needed',
                params: {'p_order_id': _orderId});
          } catch (_) {
            // Best-effort -- the buyer's own message below still explains
            // what happened even if this silently fails.
          }
        }

        if (!mounted) return;
        setState(() {
          _busy = false;
          _stepError = isPayoutIssue
              ? "This seller hasn't finished setting up to receive payments yet. We've let them know — try again shortly, or message them directly."
              : 'Could not start payment. Please try again.';
        });
        return;
      }

      final url = InitializePaymentCall.authorizationurl(body);
      if (url == null || url.isEmpty) {
        setState(() {
          _busy = false;
          _stepError = 'Payment link was not returned. Please try again.';
        });
        return;
      }

      // Carried through the existing single authorizationUrl param so the
      // destination page needs no schema change: PaystackCheckoutWidget
      // splits it back apart. The fragment is inert on the real URL (never
      // sent to a server), so mobile's WebView still opens the real hosted
      // checkout unmodified.
      final accessCode = InitializePaymentCall.accesscode(body);
      final checkoutUrl = (accessCode != null && accessCode.isNotEmpty)
          ? '$url#ff_access=$accessCode'
          : url;

      setState(() => _busy = false);

      // No launchURL on web: both platforms open the same in-app payment
      // page, which now renders a cross-platform checkout widget (hosted
      // WebView on mobile, Paystack InlineJS on web) instead of a browser
      // redirect.
      context.pushNamed(
        PaystackPaymenentWidget.routeName,
        queryParameters: {
          'authorizationUrl': serializeParam(checkoutUrl, ParamType.String),
          'orderID': serializeParam(_orderId, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _stepError = 'Could not start payment. $e';
      });
    }
  }

  /// Charges only the delivery fee (`payment_for: 'delivery'`) once the
  /// buyer has chosen a carrier post-ready. Bypasses InitializePaymentCall,
  /// which only knows how to charge an order's full `total` -- the same
  /// reason orija_order_details.dart's _payDeliveryFee calls paystack-orija
  /// directly instead.
  Future<void> _payDelivery() async {
    if (_quoteExpired) {
      setState(() => _stepError =
          'Your delivery price expired. Choose a delivery option again.');
      return;
    }

    setState(() {
      _busy = true;
      _stepError = null;
    });

    try {
      final callback =
          'orija://orijahq.com${GoRouterState.of(context).uri.toString()}';
      final res = await _supabase.functions.invoke(
        'paystack-orija',
        body: {
          'action': 'initializePayment',
          'order_id': _orderId,
          'callback_url': callback,
          'payment_for': 'delivery',
        },
      );

      final data = res.data;
      final ok = data is Map && data['success'] == true;

      if (!mounted) return;

      if (!ok) {
        final details = data is Map ? data['details'] : null;
        final serverMsg =
            (details is Map ? details['message'] as String? : null) ??
                (data is Map ? data['error'] as String? : null) ??
                (data is Map ? data['message'] as String? : null);

        final isPayoutIssue =
            (serverMsg ?? '').toLowerCase().contains('subaccount') ||
                (serverMsg ?? '').toLowerCase().contains('payout account');

        if (isPayoutIssue) {
          try {
            await _supabase.rpc('flag_payout_setup_needed',
                params: {'p_order_id': _orderId});
          } catch (_) {}
        }

        if (!mounted) return;
        setState(() {
          _busy = false;
          _stepError = isPayoutIssue
              ? "This seller hasn't finished setting up to receive payments yet. We've let them know — try again shortly, or message them directly."
              : '${serverMsg ?? 'Could not start payment. Please try again.'}';
        });
        return;
      }

      final url = data['authorization_url'] as String?;
      if (url == null || url.isEmpty) {
        setState(() {
          _busy = false;
          _stepError = 'Payment link was not returned. Please try again.';
        });
        return;
      }

      final accessCode = data['access_code'] as String?;
      final checkoutUrl = (accessCode != null && accessCode.isNotEmpty)
          ? '$url#ff_access=$accessCode'
          : url;

      setState(() => _busy = false);

      context.pushNamed(
        PaystackPaymenentWidget.routeName,
        queryParameters: {
          'authorizationUrl': serializeParam(checkoutUrl, ParamType.String),
          'orderID': serializeParam(_orderId, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _stepError = 'Could not start payment. $e';
      });
    }
  }

  // ── Formatting ────────────────────────────────────────────────────────

  String _money(num value) {
    final whole = value.round();
    final s = whole.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦${buf.toString()}';
  }

  String _countdown(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Build ─────────────────────────────────────────────────────────────

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
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: CircularProgressIndicator(color: theme.primary),
        ),
      );
    }

    if (_loadError != null) {
      return _message(theme, Icons.error_outline, _loadError!, theme.error);
    }

    final paid = _paidNow;
    if (paid && !_isPostReadyDelivery) {
      return _message(
        theme,
        Icons.check_circle_outline,
        'This order has already been paid for.',
        theme.secondary,
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: theme.primaryBackground,
      child: Column(
        children: [
          _stepBar(theme),
          if (_stepError != null) _errorBanner(theme),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: _stepBody(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _message(FlutterFlowTheme theme, IconData icon, String text, Color c) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: theme.primaryBackground,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: c, size: 40),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.primaryText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBanner(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: theme.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _stepError!,
              style: TextStyle(
                  color: theme.primaryText, fontSize: 12.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepBar(FlutterFlowTheme theme) {
    // Pickup skips the address and carrier steps entirely, so the bar shows
    // the two it actually has rather than greying out two dead ones. A
    // made-to-order order has no fulfilment step before payment (nothing is
    // decided yet) and no fulfilment step after it either (pickup is chosen
    // from chat, not here) -- post-ready, this screen is address+carrier
    // for delivery only.
    final mtoUnpaid = _isMadeToOrder && !_paidNow;
    final labels = (_isService || _isDigital || mtoUnpaid)
        ? const ['Pay']
        : _isPickup
            ? const ['Fulfilment', 'Pay']
            : _isPostReadyDelivery
                ? const ['Address', 'Delivery', 'Pay']
                : const ['Fulfilment', 'Address', 'Delivery', 'Pay'];
    final activeIndex = (_isService || _isDigital || mtoUnpaid)
        ? 0
        : _isPickup
            ? (_step >= 3 ? 1 : 0)
            : _isPostReadyDelivery
                ? (_step - 1).clamp(0, 2)
                : _step;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: theme.alternate,
              ),
            );
          }
          final index = i ~/ 2;
          final done = index < activeIndex;
          final active = index == activeIndex;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: done || active ? theme.secondary : theme.alternate,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: active ? Colors.white : theme.secondaryText,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[index],
                style: TextStyle(
                  fontSize: 10,
                  color: active ? theme.primaryText : theme.secondaryText,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _stepBody(FlutterFlowTheme theme) {
    switch (_step) {
      case 1:
        return _addressStep(theme);
      case 2:
        return _quotesStep(theme);
      case 3:
        return _summaryStep(theme);
      default:
        return _fulfilmentStep(theme);
    }
  }

  // ── Step 0 — fulfilment ───────────────────────────────────────────────

  Widget _fulfilmentStep(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _pickupOnly ? 'Pick up your order' : 'How do you want to get this?',
          style: TextStyle(
            color: theme.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _pickupOnly
              ? 'You collect this from the seller. The price you see is the price you pay.'
              : 'Choose before paying — the price you see is the price you pay.',
          style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
        ),
        const SizedBox(height: 16),
        // Rendered from delivery_providers rather than two hardcoded tiles,
        // so a new courier (Konga, GIG, ...) becomes a row, not a UI change.
        // The courier tile is named explicitly ("Terminal Africa") instead
        // of a generic "Have it delivered" now that more than one is coming.
        if (!_courierEligible && !_pickupOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.warning.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 18, color: theme.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'One or more items in this order can only be picked up -- couriers cannot carry them.',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12.5,
                          height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_providers.isEmpty)
          Text(
            'No delivery options are available for this order right now.',
            style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
          )
        else
          ..._providers.asMap().entries.expand((entry) {
            final p = entry.value;
            final isPickup = p['kind'] == 'pickup';
            return [
              if (entry.key > 0) const SizedBox(height: 12),
              _fulfilmentTile(
                theme,
                icon: isPickup
                    ? Icons.storefront_outlined
                    : Icons.local_shipping_outlined,
                title: '${p['name'] ?? (isPickup ? 'Pickup' : 'Delivery')}',
                subtitle: '${p['tagline'] ?? ''}',
                trailing: isPickup ? 'Free' : 'See prices',
                onTap: _busy
                    ? null
                    : (isPickup
                        ? _choosePickup
                        : () => setState(() => _step = 1)),
              ),
            ];
          }),
        const SizedBox(height: 20),
        _orderPreview(theme),
      ],
    );
  }

  Widget _fulfilmentTile(
    FlutterFlowTheme theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.secondary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 11.5,
                        height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              trailing,
              style: TextStyle(
                color: theme.secondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 1 — address ──────────────────────────────────────────────────

  Widget _addressStep(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(theme, 'Where should it go?',
            'Saved addresses are reused next time.'),
        const SizedBox(height: 12),
        if (_addresses.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.alternate),
            ),
            child: Text(
              'You have no saved addresses yet. Add one to see delivery prices.',
              style: TextStyle(
                  color: theme.secondaryText, fontSize: 12.5, height: 1.4),
            ),
          )
        else
          ..._addresses.map((a) => _addressTile(theme, a)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _openAddressSheet(theme),
          icon: const Icon(Icons.add, size: 18),
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.secondary,
            side: BorderSide(color: theme.secondary),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          label: const Text('Add a new address'),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            TextButton(
              // Post-ready, there's no fulfilment step to go back to --
              // pickup is a different entry point entirely (the chat card),
              // so "back" from address just leaves checkout.
              onPressed: _busy
                  ? null
                  : () => _isPostReadyDelivery
                      ? Navigator.of(context).maybePop()
                      : setState(() => _step = 0),
              child: Text('Back', style: TextStyle(color: theme.secondaryText)),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed:
                  (_busy || _selectedAddressId == null) ? null : _fetchQuotes,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
              ),
              child: Text(_busy ? 'Getting prices…' : 'See delivery prices'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _addressTile(FlutterFlowTheme theme, Map<String, dynamic> a) {
    final id = a['id'] as String?;
    final selected = id == _selectedAddressId;
    final parts = [
      a['line1'],
      a['city'],
      a['state'],
    ].where((p) => p != null && '$p'.trim().isNotEmpty).join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedAddressId = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? theme.secondary : theme.alternate,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? theme.secondary : theme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${a['label'] ?? 'Address'} · ${a['first_name']} ${a['last_name']}',
                      style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      parts,
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 11.5),
                    ),
                    Text(
                      '${a['phone']}',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddressSheet(FlutterFlowTheme theme) {
    final profile = _userProfile;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddressSheet(
        countryCode: _countryCode,
        stateOptions: _stateOptions,
        geoAvailable: _geoAvailable,
        defaultFirstName: profile?['first_name'] as String?,
        defaultLastName: profile?['last_name'] as String?,
        defaultPhone: profile?['phone'] as String?,
        defaultStateCode: _matchStateCode(profile?['state'] as String?),
        onSaved: (address) async {
          Navigator.of(ctx).pop();
          await _load();
          if (!mounted) return;
          setState(() {
            _selectedAddressId = address['id'] as String?;
            _step = 1;
          });
        },
      ),
    );
  }

  // ── Step 2 — carrier options ──────────────────────────────────────────

  Widget _quotesStep(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(theme, 'Choose a delivery option',
            'Prices are live and held briefly, so pick and pay in one go.'),
        const SizedBox(height: 12),
        if (_quotes.isEmpty)
          Text(
            _isPostReadyDelivery
                ? 'No delivery options came back. Go back and try another address.'
                : 'No delivery options came back. Go back and try another address, '
                    'or pick up from the seller.',
            style: TextStyle(
                color: theme.secondaryText, fontSize: 12.5, height: 1.4),
          )
        else
          ..._quotes.map((q) => _quoteTile(theme, q)),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _busy ? null : () => setState(() => _step = 1),
          child: Text('Back', style: TextStyle(color: theme.secondaryText)),
        ),
      ],
    );
  }

  Widget _quoteTile(FlutterFlowTheme theme, Map<String, dynamic> q) {
    final id = q['id'] as String?;
    final selected = id == _selectedQuoteId;
    final amount = (q['amount'] as num?) ?? 0;
    final eta = q['eta_text'] as String?;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: (_busy || id == null) ? null : () => _selectQuote(id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? theme.secondary : theme.alternate,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              if ((q['carrier_logo'] as String?)?.isNotEmpty ?? false)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${q['carrier_logo']}',
                    width: 34,
                    height: 34,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                        Icons.local_shipping_outlined,
                        color: theme.secondaryText,
                        size: 22),
                  ),
                )
              else
                Icon(Icons.local_shipping_outlined,
                    color: theme.secondaryText, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${q['carrier_name'] ?? 'Carrier'}',
                      style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (eta != null && eta.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        eta,
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11.5),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                _money(amount),
                style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Step 3 — summary ──────────────────────────────────────────────────

  Widget _summaryStep(FlutterFlowTheme theme) {
    if (_isPostReadyDelivery) return _deliveryOnlySummaryStep(theme);

    final q = _selectedQuote;
    final mtoUnpaid = _isMadeToOrder && !_paidNow;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
            theme,
            _isService
                ? 'Review and pay for your booking'
                : (_isDigital
                    ? 'Review and pay for your digital purchase'
                    : 'Review and pay'),
            'This is the exact amount that will be charged.'),
        const SizedBox(height: 12),
        _orderPreview(theme),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.alternate),
          ),
          child: Column(
            children: [
              _summaryRow(theme, 'Items total', _money(_subtotal)),
              if (_buyerFee > 0) ...[
                const SizedBox(height: 8),
                _summaryRow(theme, 'Buyer protection fee', _money(_buyerFee)),
              ],
              // Nothing about delivery is decided at checkout for a
              // made-to-order order (no row at all, not even an estimate --
              // it's genuinely unknown until the seller marks it ready).
              if (!_isService && !_isDigital && !mtoUnpaid) ...[
                const SizedBox(height: 8),
                _summaryRow(
                  theme,
                  _isPickup
                      ? 'Pickup'
                      : 'Delivery${q != null ? ' · ${q['carrier_name'] ?? ''}' : ''}',
                  _isPickup ? 'Free' : _money(_shipping),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: theme.alternate),
              ),
              _summaryRow(theme, 'Total', _money(_total), emphasise: true),
            ],
          ),
        ),
        if (!_isPickup &&
            !_isService &&
            !_isDigital &&
            !mtoUnpaid &&
            q != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                _quoteExpired ? Icons.timer_off_outlined : Icons.timer_outlined,
                size: 15,
                color: _quoteExpired ? theme.error : theme.secondaryText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _quoteExpired
                      ? 'This delivery price has expired — choose again.'
                      : 'Delivery price held for ${_countdown(_remaining)}',
                  style: TextStyle(
                    color: _quoteExpired ? theme.error : theme.secondaryText,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (mtoUnpaid) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.handyman_outlined, size: 16, color: theme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This item is made to order, so there\'s nothing to '
                    'decide about delivery yet. You\'re paying for the item '
                    'now; once the seller marks it ready, you\'ll choose '
                    'pickup or delivery in chat and pay any delivery fee then.',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_isPickup) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, size: 16, color: theme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'The seller’s full address and phone number are sent to '
                    'your chat as soon as payment is confirmed.',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_isDigital) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.cloud_download_outlined,
                    size: 16, color: theme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Delivered digitally -- your download or access link appears in this chat as soon as payment is confirmed.',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_isService) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.event_available_outlined,
                    size: 16, color: theme.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pay now to confirm your booking. You and the seller agree the '
                    'date and place in chat, and you confirm the job once it is done.',
                    style: TextStyle(
                      color: theme.primaryText,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_busy || _quoteExpired) ? null : _pay,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.secondary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: theme.alternate,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              _busy ? 'Starting payment…' : 'Pay ${_money(_total)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Made-to-order has no fulfilment step to change here -- pre-payment
        // nothing's chosen yet, post-ready it's a different screen entirely.
        if (!_isService && !_isDigital && !_isMadeToOrder)
          Center(
            child: TextButton(
              onPressed: _busy ? null : () => setState(() => _step = 0),
              child: Text(
                'Change how I get this',
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5),
              ),
            ),
          ),
      ],
    );
  }

  /// Step 3, post-ready-delivery mode: the item was already paid for in a
  /// separate transaction, so this shows and charges the delivery fee
  /// alone -- never `_order['total']`, which (once a quote is selected)
  /// holds the combined item+delivery amount for record-keeping, not what
  /// Paystack should charge here.
  Widget _deliveryOnlySummaryStep(FlutterFlowTheme theme) {
    final q = _selectedQuote;
    final fee = (q?['amount'] as num?) ?? _shipping;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(theme, 'Review and pay for delivery',
            'Your order is ready — this is the delivery fee.'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.alternate),
          ),
          child: Column(
            children: [
              _summaryRow(
                theme,
                'Delivery${q != null ? ' · ${q['carrier_name'] ?? ''}' : ''}',
                _money(fee),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: theme.alternate),
              ),
              _summaryRow(theme, 'Total', _money(fee), emphasise: true),
            ],
          ),
        ),
        if (q != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                _quoteExpired ? Icons.timer_off_outlined : Icons.timer_outlined,
                size: 15,
                color: _quoteExpired ? theme.error : theme.secondaryText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _quoteExpired
                      ? 'This delivery price has expired — choose again.'
                      : 'Delivery price held for ${_countdown(_remaining)}',
                  style: TextStyle(
                    color: _quoteExpired ? theme.error : theme.secondaryText,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_busy || _quoteExpired) ? null : _pay,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.secondary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: theme.alternate,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              _busy ? 'Starting payment…' : 'Pay ${_money(fee)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(FlutterFlowTheme theme, String label, String value,
      {bool emphasise = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: emphasise ? theme.primaryText : theme.secondaryText,
              fontSize: emphasise ? 14 : 12.5,
              fontWeight: emphasise ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: theme.primaryText,
            fontSize: emphasise ? 16 : 13,
            fontWeight: emphasise ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _stepHeader(FlutterFlowTheme theme, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(subtitle,
            style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
      ],
    );
  }

  Widget _orderPreview(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_order?['storefront_name'] ?? 'Order'} · ${_items.length} item${_items.length == 1 ? '' : 's'}',
            style: TextStyle(
              color: theme.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ..._items.map(
            (it) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${it['quantity']}× ${it['title'] ?? 'Item'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 12),
                    ),
                  ),
                  Text(
                    _money(((it['unit_price'] as num?) ?? 0) *
                        ((it['quantity'] as num?) ?? 1)),
                    style: TextStyle(color: theme.primaryText, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Collects a delivery address. Deliberately a real saved row rather than
/// global app state: the previous flow wrote city/state into FFAppState,
/// which select_location_widget clears on init, so an address could vanish
/// mid-checkout — and under pay-last the address is what sets the price.
///
/// Name, phone and state default from the buyer's own profile (`users`) so
/// returning buyers aren't retyping what the app already knows — still
/// editable, since a delivery contact can genuinely differ from the account
/// holder. State and city are dropdowns fed by Terminal's geo data (see the
/// state below); the street line is typed.
class _AddressSheet extends StatefulWidget {
  const _AddressSheet({
    required this.onSaved,
    required this.countryCode,
    required this.stateOptions,
    required this.geoAvailable,
    this.defaultFirstName,
    this.defaultLastName,
    this.defaultPhone,
    this.defaultStateCode,
  });

  final Future<void> Function(Map<String, dynamic> address) onSaved;
  final String countryCode;

  /// {'name': 'Lagos', 'isoCode': 'LA'} pairs from Terminal.
  final List<Map<String, String>> stateOptions;

  /// False only if the Terminal geo call failed outright.
  final bool geoAvailable;

  final String? defaultFirstName;
  final String? defaultLastName;
  final String? defaultPhone;
  final String? defaultStateCode;

  @override
  State<_AddressSheet> createState() => _AddressSheetState();
}

/// Collects a delivery address. Deliberately a real saved row rather than
/// global app state: the previous flow wrote city/state into FFAppState,
/// which select_location_widget clears on init, so an address could vanish
/// mid-checkout — and under pay-last the address is what sets the price.
///
/// Name, phone and state default from the buyer's own profile (`users`).
/// State and city are cascading dropdowns sourced LIVE from Terminal's own
/// geo data (country -> state -> city), not a locally-maintained table or a
/// guess from Google. Two reasons: it guarantees an exact match with what
/// Terminal itself expects when quoting and booking — our own `states`
/// table's "Lagos State" never matched Terminal's own "Lagos" cleanly, and
/// Google's returned city/state strings weren't guaranteed to match either
/// — and it already covers every country Terminal operates in, so an
/// eventual country picker is a small addition to this same cascade, not a
/// rearchitecture. The street line is typed by hand: Terminal's geo data has
/// no opinion on it.
class _AddressSheetState extends State<_AddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _label = TextEditingController(text: 'Home');
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneDigits = TextEditingController();
  final _line1 = TextEditingController();

  String? _zip;
  String? _selectedStateCode;
  String? _selectedCity;

  List<String> _cities = [];
  bool _loadingCities = false;
  String? _citiesError;

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _firstName.text = widget.defaultFirstName ?? '';
    _lastName.text = widget.defaultLastName ?? '';
    _phoneDigits.text = ngPhoneDigitsFromAny(widget.defaultPhone ?? '');
    _selectedStateCode = widget.defaultStateCode;
    if (_selectedStateCode != null) {
      _loadCities(_selectedStateCode!);
    }
  }

  @override
  void dispose() {
    _label.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phoneDigits.dispose();
    _line1.dispose();
    super.dispose();
  }

  String? get _selectedStateName {
    final match = widget.stateOptions
        .where((s) => s['isoCode'] == _selectedStateCode)
        .toList();
    return match.isEmpty ? null : match.first['name'];
  }

  /// Cities depend on the chosen state, fetched the moment one is picked.
  /// Cleared and refetched on every state change — a city belonging to the
  /// previous state is never valid for the new one.
  Future<void> _loadCities(String stateCode) async {
    setState(() {
      _loadingCities = true;
      _citiesError = null;
      _cities = [];
      _selectedCity = null;
    });

    final res = await GetCityterminalafricaCall.call(
      countryCode: widget.countryCode,
      stateCode: stateCode,
    );

    if (!mounted) return;

    setState(() {
      _loadingCities = false;
      if (!res.succeeded) {
        _citiesError = 'Could not load cities for this state.';
        return;
      }
      final names =
          GetCityterminalafricaCall.name(res.jsonBody) ?? const <String>[];
      _cities = List<String>.from(names)..sort();
      if (_cities.isEmpty) {
        _citiesError = 'No cities returned for this state.';
      }
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedStateCode == null) {
      setState(() => _error = 'Choose a state.');
      return;
    }
    if (_selectedCity == null || _selectedCity!.isEmpty) {
      setState(() => _error = 'Choose a city.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final inserted = await Supabase.instance.client
          .from('buyer_addresses')
          .insert({
            'user_id': currentUserUid,
            'label': _label.text.trim(),
            'first_name': _firstName.text.trim(),
            'last_name': _lastName.text.trim(),
            'phone': '+234\${_phoneDigits.text.trim()}',
            'line1': _line1.text.trim(),
            'city': _selectedCity,
            // Both sourced from Terminal's own geo data, so this is exactly
            // what /rates/shipment/quotes will be asked to match against.
            'state': _selectedStateName,
            'country': widget.countryCode,
            if (_zip != null && _zip!.isNotEmpty) 'zip': _zip,
            'is_default': true,
          })
          .select()
          .single();

      if (!mounted) return;
      await widget.onSaved(Map<String, dynamic>.from(inserted));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not save this address. $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.alternate,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Add a delivery address',
                  style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (!widget.geoAvailable) ...[
                  _banner(theme,
                      'Could not load the list of states right now. Close and reopen this sheet to retry.'),
                  const SizedBox(height: 8),
                ] else if (_error != null) ...[
                  Text(_error!,
                      style: TextStyle(color: theme.error, fontSize: 12)),
                  const SizedBox(height: 8),
                ],
                _field(theme, _label, 'Label (Home, Office)', required: false),
                Row(
                  children: [
                    Expanded(child: _field(theme, _firstName, 'First name')),
                    const SizedBox(width: 10),
                    Expanded(child: _field(theme, _lastName, 'Last name')),
                  ],
                ),
                ngPhoneField(theme, _phoneDigits, validateForm: true),
                const SizedBox(height: 10),
                _stateDropdown(theme),
                _cityField(theme),
                const SizedBox(height: 4),
                _streetSearchField(theme, _line1, onPicked: (_) {}),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(_saving ? 'Saving…' : 'Save address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner(FlutterFlowTheme theme, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.error.withValues(alpha: 0.35)),
      ),
      child: Text(text,
          style: TextStyle(
              color: theme.primaryText, fontSize: 11.5, height: 1.35)),
    );
  }

  Widget _stateDropdown(FlutterFlowTheme theme) {
    final codes = widget.stateOptions.map((s) => s['isoCode']).toSet();
    final value =
        codes.contains(_selectedStateCode) ? _selectedStateCode : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        dropdownColor: theme.secondaryBackground,
        style: TextStyle(color: theme.primaryText, fontSize: 13.5),
        decoration: _inputDecoration(theme, 'State'),
        items: widget.stateOptions
            .map((s) => DropdownMenuItem<String>(
                  value: s['isoCode'],
                  child: Text(s['name']!),
                ))
            .toList(),
        onChanged: (v) {
          setState(() => _selectedStateCode = v);
          if (v != null) _loadCities(v);
        },
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }

  /// A real dropdown once cities are loaded; a disabled-looking placeholder
  /// while waiting on the state pick or the Terminal call itself, and a
  /// tappable retry if that call fails.
  Widget _cityField(FlutterFlowTheme theme) {
    if (_selectedStateCode == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.alternate),
          ),
          child: Text('Choose a state first',
              style: TextStyle(color: theme.secondaryText, fontSize: 13)),
        ),
      );
    }

    if (_loadingCities) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.alternate),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: theme.secondary),
              ),
              const SizedBox(width: 10),
              Text('Loading cities…',
                  style: TextStyle(color: theme.secondaryText, fontSize: 13)),
            ],
          ),
        ),
      );
    }

    if (_citiesError != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () => _loadCities(_selectedStateCode!),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: theme.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.error.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.refresh, size: 16, color: theme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('$_citiesError Tap to retry.',
                      style: TextStyle(color: theme.error, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: DropdownButtonFormField<String>(
        initialValue: _cities.contains(_selectedCity) ? _selectedCity : null,
        isExpanded: true,
        dropdownColor: theme.secondaryBackground,
        style: TextStyle(color: theme.primaryText, fontSize: 13.5),
        decoration: _inputDecoration(theme, 'City'),
        items: _cities
            .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
            .toList(),
        onChanged: (v) => setState(() => _selectedCity = v),
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }

  /// Street address as a real search box, backed by Google's Places API
  /// (New) -- the one Places endpoint that answers direct browser calls with
  /// CORS headers, so this works on web as well as iOS/Android without a
  /// native platform picker. Falls back to plain typing with no error shown
  /// if the API call fails (wrong/disabled key, offline, etc.) -- the field
  /// is a normal TextField underneath, so nothing is lost by trying.
  Widget _streetSearchField(
    FlutterFlowTheme theme,
    TextEditingController controller, {
    required ValueChanged<String> onPicked,
  }) {
    return _StreetSearchField(
      theme: theme,
      controller: controller,
      onPicked: onPicked,
    );
  }

  InputDecoration _inputDecoration(FlutterFlowTheme theme, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.secondaryText, fontSize: 12.5),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    );
  }

  Widget _field(
    FlutterFlowTheme theme,
    TextEditingController controller,
    String label, {
    bool required = true,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: theme.primaryText, fontSize: 13.5),
        decoration: _inputDecoration(theme, label),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }
}

class _StreetSuggestion {
  const _StreetSuggestion(this.placeId, this.text);
  final String placeId;
  final String text;
}

class _StreetSearchField extends StatefulWidget {
  const _StreetSearchField({
    required this.theme,
    required this.controller,
    required this.onPicked,
  });

  final FlutterFlowTheme theme;
  final TextEditingController controller;
  final ValueChanged<String> onPicked;

  @override
  State<_StreetSearchField> createState() => _StreetSearchFieldState();
}

class _StreetSearchFieldState extends State<_StreetSearchField> {
  static const _iosKey = 'AIzaSyAXzJ05IP_j7zho9RxvppCHk0GgSQ1mj4g';
  static const _androidKey = 'AIzaSyCC9i1gWMNw8bkhDiE2VGMHWQTwD0wGkDM';
  static const _webKey = 'AIzaSyB-GO6pS515nha7e9l-Q6xIF7bVF1qHkEA';

  Timer? _debounce;
  String? _sessionToken;
  List<_StreetSuggestion> _suggestions = [];
  bool _searching = false;
  final _layerLink = LayerLink();
  OverlayEntry? _overlay;

  String get _apiKey {
    if (kIsWeb) return _webKey;
    if (Platform.isIOS) return _iosKey;
    return _androidKey;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _hideOverlay();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onPicked
        .call(''); // typing manually clears any prior pick's side-effects
    _debounce?.cancel();
    if (value.trim().length < 4) {
      _suggestions = [];
      _hideOverlay();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String input) async {
    _sessionToken ??= '${DateTime.now().microsecondsSinceEpoch}';
    setState(() => _searching = true);
    try {
      final res = await http.post(
        Uri.parse('https://places.googleapis.com/v1/places:autocomplete'),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
        },
        body: jsonEncode({
          'input': input,
          'sessionToken': _sessionToken,
          'includedRegionCodes': ['ng'],
          'languageCode': 'en',
        }),
      );
      if (!mounted) return;
      if (res.statusCode != 200) {
        setState(() {
          _searching = false;
          _suggestions = [];
        });
        _hideOverlay();
        return;
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final preds = (data['suggestions'] as List?) ?? const [];
      setState(() {
        _searching = false;
        _suggestions = [
          for (final p in preds)
            if (p['placePrediction'] != null)
              _StreetSuggestion(
                '${p['placePrediction']['placeId']}',
                '${p['placePrediction']['text']?['text'] ?? ''}',
              ),
        ];
      });
      _showOverlay();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searching = false;
        _suggestions = [];
      });
      _hideOverlay();
    }
  }

  /// Terminal Africa (and most carrier APIs) cap an address line at 45
  /// characters. Google's prediction text and formattedAddress are full
  /// descriptions (street, area, city, state, country) that routinely run
  /// well past that, so anything from this picker gets clamped before it
  /// reaches the field.
  static const _maxLine1 = 45;
  String _clamp(String s) =>
      s.length > _maxLine1 ? s.substring(0, _maxLine1) : s;

  Future<void> _select(_StreetSuggestion s) async {
    _hideOverlay();
    widget.controller.text = _clamp(s.text);
    widget.controller.selection =
        TextSelection.collapsed(offset: widget.controller.text.length);
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
    try {
      final res = await http.get(
        Uri.parse('https://places.googleapis.com/v1/places/${s.placeId}'),
        headers: {
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'formattedAddress,addressComponents',
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final components = (data['addressComponents'] as List?) ?? const [];
        String? componentText(String type) {
          for (final c in components) {
            final types = (c['types'] as List?) ?? const [];
            if (types.contains(type)) {
              return (c['longText'] ?? c['shortText']) as String?;
            }
          }
          return null;
        }

        final streetLine = [
          componentText('street_number'),
          componentText('route')
        ].where((p) => p != null && p.trim().isNotEmpty).join(' ');
        final formatted = data['formattedAddress'] as String?;
        final best = streetLine.isNotEmpty
            ? streetLine
            : (formatted?.isNotEmpty == true ? formatted! : null);
        if (best != null) {
          widget.controller.text = _clamp(best);
        }
      }
    } catch (_) {
      // The prediction text alone is still a usable address.
    } finally {
      _sessionToken = null;
      widget.onPicked.call(widget.controller.text);
    }
  }

  void _showOverlay() {
    _hideOverlay();
    if (_suggestions.isEmpty) return;
    final theme = widget.theme;
    final box = context.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? 300;
    _overlay = OverlayEntry(
      builder: (ctx) => Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, (box?.size.height ?? 48) + 4),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: theme.secondaryBackground,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                itemBuilder: (_, i) {
                  final s = _suggestions[i];
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.place_outlined,
                        size: 18, color: theme.secondaryText),
                    title: Text(s.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: theme.primaryText, fontSize: 13)),
                    onTap: () => _select(s),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        onChanged: _onChanged,
        textCapitalization: TextCapitalization.words,
        maxLength: 45,
        style: TextStyle(color: theme.primaryText, fontSize: 14),
        decoration: InputDecoration(
          labelText: 'Street address',
          hintText: 'Search for the address, or type it in',
          counterText: '',
          labelStyle: TextStyle(color: theme.secondaryText, fontSize: 13),
          hintStyle: TextStyle(color: theme.secondaryText, fontSize: 12.5),
          filled: true,
          fillColor: theme.secondaryBackground,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          suffixIcon: _searching
              ? Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: theme.secondary),
                  ),
                )
              : Icon(Icons.search, color: theme.secondaryText, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.alternate),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.alternate),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.secondary),
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
