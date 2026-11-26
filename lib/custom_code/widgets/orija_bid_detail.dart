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

import 'dart:async';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

/// Full detail + bidding surface for one timed (no-video) bid session.
/// Three audiences, one widget: a bidder (place a bid / see their rank), the
/// seller (manage: extend window, cancel), and a resolved winner (confirm
/// pickup -- two-tap, release happens only on the second tap).
class OrijaBidDetail extends StatefulWidget {
  const OrijaBidDetail({super.key, this.width, this.height, this.sessionId});

  final double? width;
  final double? height;
  // Nullable: the generated page wrapper always passes its own (nullable)
  // query param straight through as widget!.sessionId.
  final String? sessionId;

  @override
  State<OrijaBidDetail> createState() => _OrijaBidDetailState();
}

class _OrijaBidDetailState extends State<OrijaBidDetail> {
  bool _loading = true;
  bool _notFound = false;
  Map<String, dynamic>? _session;
  Map<String, dynamic>? _config;
  Map<String, dynamic>? _seller;
  Map<String, dynamic>? _storefront;
  bool _isFollowing = false;
  bool _followBusy = false;
  // Ranked, anonymized ladder: one row per distinct bidder, highest amount
  // first. Numbering matches place_bid's own scheme (rank by first-bid
  // time), computed here read-only for display -- never authoritative.
  List<Map<String, dynamic>> _ladder = [];
  Timer? _clock;
  DateTime _now = DateTime.now();
  RealtimeChannel? _bidsChannel;
  RealtimeChannel? _sessionChannel;

  // Local-only opt-in, offered to whoever is currently leading: once on, a
  // warning banner appears once the window enters its final 5 minutes,
  // flagging that staying in the lead when bidding closes means winning --
  // and being on the hook to complete pickup.
  bool _alertMeEnabled = false;

  final _bidAmount = TextEditingController();
  final _bidFocus = FocusNode();
  bool _placingBid = false;
  bool _acting = false;
  String? _actionError;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    _load();
    _subscribeRealtime();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    if (_bidsChannel != null)
      Supabase.instance.client.removeChannel(_bidsChannel!);
    if (_sessionChannel != null) {
      Supabase.instance.client.removeChannel(_sessionChannel!);
    }
    _bidAmount.dispose();
    _bidFocus.dispose();
    super.dispose();
  }

  // Live updates: a new bid from anyone, or the auction itself resolving,
  // refreshes the whole view (ladder, current price, countdown, action
  // buttons) without the viewer needing to pull-to-refresh.
  void _subscribeRealtime() {
    final sessionId = widget.sessionId;
    if (sessionId == null || sessionId.isEmpty) return;
    final supabase = Supabase.instance.client;

    _bidsChannel = supabase.channel('bid_detail_bids:$sessionId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'bids',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'session_id',
          value: sessionId,
        ),
        callback: (_) => _load(),
      )
      ..subscribe();

    _sessionChannel = supabase.channel('bid_detail_session:$sessionId')
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'live_sessions',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: sessionId,
        ),
        callback: (_) => _load(),
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'live_bid_config',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'session_id',
          value: sessionId,
        ),
        callback: (_) => _load(),
      )
      ..subscribe();
  }

  Future<void> _load() async {
    final sessionId = widget.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      if (mounted)
        setState(() {
          _notFound = true;
          _loading = false;
        });
      return;
    }
    final supabase = Supabase.instance.client;
    try {
      final session = await supabase
          .from('live_sessions')
          .select(
              'id, vendor_id, status, is_video, started_at, max_duration_minutes, storefront_id')
          .eq('id', sessionId)
          .maybeSingle();
      if (session == null) {
        if (mounted)
          setState(() {
            _notFound = true;
            _loading = false;
          });
        return;
      }
      final config = await supabase
          .from('live_bid_config')
          .select(
              'item_title, item_photos, item_description, item_condition, starting_price, reserve_price, bid_increment, current_bid, reserve_met, winner_id, winner_bid, payment_deadline, second_bidder_id, outcome, extension_count, extension_fee_paid, free_extension_used, listing_id, listings(primary_image_url, photos)')
          .eq('session_id', sessionId)
          .maybeSingle();

      final vendorId = session['vendor_id'] as String?;
      final seller = vendorId == null
          ? null
          : await supabase
              .from('users')
              .select(
                  'first_name, last_name, avatar_url, created_at, city, state')
              .eq('id', vendorId)
              .maybeSingle();

      final storefrontId = session['storefront_id'] as String?;
      Map<String, dynamic>? storefront;
      var isFollowing = false;
      if (storefrontId != null) {
        storefront = await supabase
            .from('storefronts')
            .select('name, avg_rating, total_reviews')
            .eq('id', storefrontId)
            .maybeSingle();
        final f = await supabase
            .from('follows')
            .select('id')
            .eq('follower_id', currentUserUid)
            .eq('storefront_id', storefrontId)
            .maybeSingle();
        isFollowing = f != null;
      }

      final bidRows = await supabase
          .from('bids')
          .select('bidder_id, amount, placed_at')
          .eq('session_id', sessionId)
          .order('placed_at', ascending: true);
      final allBids = List<Map<String, dynamic>>.from(bidRows as List);
      final firstSeen = <String, DateTime>{};
      final topAmount = <String, num>{};
      for (final b in allBids) {
        final id = '${b['bidder_id']}';
        final t = DateTime.tryParse('${b['placed_at']}');
        final amt = (b['amount'] as num?) ?? 0;
        if (t != null && !firstSeen.containsKey(id)) firstSeen[id] = t;
        if (!topAmount.containsKey(id) || amt > topAmount[id]!) {
          topAmount[id] = amt;
        }
      }
      final order = firstSeen.keys.toList()
        ..sort((a, b) => firstSeen[a]!.compareTo(firstSeen[b]!));
      final rank = <String, int>{};
      for (var i = 0; i < order.length; i++) rank[order[i]] = i + 1;
      final ladder = topAmount.entries
          .map((e) => {
                'bidderId': e.key,
                'rank': rank[e.key] ?? 0,
                'amount': e.value,
                'isMe': e.key == currentUserUid,
              })
          .toList()
        ..sort((a, b) => (b['amount'] as num).compareTo(a['amount'] as num));

      if (!mounted) return;
      setState(() {
        _session = session;
        _config = config;
        _seller = seller;
        _storefront = storefront;
        _isFollowing = isFollowing;
        _ladder = ladder;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleFollow() async {
    final storefrontId = _session?['storefront_id'] as String?;
    if (storefrontId == null || _followBusy) return;
    setState(() => _followBusy = true);
    final supabase = Supabase.instance.client;
    try {
      if (_isFollowing) {
        await supabase
            .from('follows')
            .delete()
            .eq('follower_id', currentUserUid)
            .eq('storefront_id', storefrontId);
      } else {
        await supabase.from('follows').insert({
          'follower_id': currentUserUid,
          'storefront_id': storefrontId,
          'source': 'bid_detail',
        });
      }
      if (mounted) setState(() => _isFollowing = !_isFollowing);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _followBusy = false);
    }
  }

  DateTime? get _closesAt {
    final s = _session;
    if (s == null) return null;
    final started = DateTime.tryParse('${s['started_at']}');
    final minutes = (s['max_duration_minutes'] as num?)?.toInt();
    if (started == null || minutes == null) return null;
    return started.add(Duration(minutes: minutes));
  }

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

  String _countdown(DateTime target) {
    final diff = target.difference(_now);
    if (diff.isNegative) return 'Ended';
    final d = diff.inDays;
    final h = diff.inHours % 24;
    final m = diff.inMinutes % 60;
    final s = diff.inSeconds % 60;
    if (d > 0) return '${d}d ${h}h left';
    if (h > 0) return '${h}h ${m}m left';
    return '${m}m ${s}s left';
  }

  Future<void> _placeBid() async {
    if (_placingBid) return;
    final amount = double.tryParse(_bidAmount.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _actionError = 'Enter a valid bid amount.');
      return;
    }
    setState(() {
      _placingBid = true;
      _actionError = null;
    });
    try {
      final res = await Supabase.instance.client.rpc('place_bid', params: {
        'p_session_id': widget.sessionId,
        'p_bidder_id': currentUserUid,
        'p_amount': amount,
      });
      if (res is Map && res['ok'] == true) {
        _bidAmount.clear();
        await _load();
      } else {
        setState(() => _actionError =
            (res is Map ? res['error'] as String? : null) ??
                'Could not place that bid.');
      }
    } catch (_) {
      setState(() => _actionError = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _placingBid = false);
    }
  }

  Future<void> _extend(int days) async {
    if (_acting) return;
    setState(() {
      _acting = true;
      _actionError = null;
    });
    try {
      final res =
          await Supabase.instance.client.rpc('extend_bid_window', params: {
        'p_session_id': widget.sessionId,
        'p_target_days': days,
      });
      if (res is Map && res['success'] == true) {
        await _load();
      } else {
        setState(() => _actionError =
            (res is Map ? res['error'] as String? : null) ??
                'Could not extend.');
      }
    } catch (_) {
      setState(() => _actionError = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _claimFreeExtension() async {
    if (_acting) return;
    setState(() {
      _acting = true;
      _actionError = null;
    });
    try {
      final res = await Supabase.instance.client.rpc('claim_free_extension',
          params: {'p_session_id': widget.sessionId});
      if (res is Map && res['success'] == true) {
        await _load();
      } else {
        setState(() => _actionError =
            (res is Map ? res['error'] as String? : null) ??
                'Could not claim the free extension.');
      }
    } catch (_) {
      setState(() => _actionError = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _restoreCancelled(int days) async {
    if (_acting) return;
    setState(() {
      _acting = true;
      _actionError = null;
    });
    try {
      final res = await Supabase.instance.client.rpc('restore_cancelled_bid',
          params: {'p_session_id': widget.sessionId, 'p_days': days});
      if (res is Map && res['success'] == true) {
        await _load();
      } else {
        setState(() => _actionError =
            (res is Map ? res['error'] as String? : null) ??
                'Could not restore this auction.');
      }
    } catch (_) {
      setState(() => _actionError = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  // Seller's "select the highest bidder" action: stop accepting new bids
  // right now and award it to whoever is currently leading -- the only
  // winner-selection that's fair in an anonymous auction, same outcome as
  // if the window had naturally closed this instant.
  Future<void> _endNow() async {
    final theme = FlutterFlowTheme.of(context);
    final leader = _ladder.isNotEmpty ? _ladder.first : null;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('End bidding now?',
            style: TextStyle(color: theme.primaryText)),
        content: Text(
            leader == null
                ? 'There are no bids yet, so ending now closes this auction unsold.'
                : 'Bidding stops immediately and #User${leader['rank']} wins at ${_naira(leader['amount'] as num)}. This cannot be undone.',
            style: TextStyle(color: theme.secondaryText)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Keep it open')),
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                  leader == null
                      ? 'End now'
                      : 'End now -- sell to #User${leader['rank']}',
                  style: TextStyle(color: theme.primary))),
        ],
      ),
    );
    if (confirmed != true || _acting) return;
    setState(() {
      _acting = true;
      _actionError = null;
    });
    try {
      final res = await Supabase.instance.client
          .rpc('end_bid_now', params: {'p_session_id': widget.sessionId});
      if (res is Map && res['success'] == true) {
        await _load();
      } else {
        setState(() => _actionError =
            (res is Map ? res['error'] as String? : null) ??
                'Could not end this auction.');
      }
    } catch (_) {
      setState(() => _actionError = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _cancel() async {
    final theme = FlutterFlowTheme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('Cancel this auction?',
            style: TextStyle(color: theme.primaryText)),
        content: Text(
            'This ends bidding and releases every bidder\'s hold -- nobody wins, even if there are current bids. To sell to your current highest bidder instead, use "End now" above.',
            style: TextStyle(color: theme.secondaryText)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Keep it open')),
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Cancel auction',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true || _acting) return;
    setState(() {
      _acting = true;
      _actionError = null;
    });
    try {
      final res = await Supabase.instance.client
          .rpc('cancel_bid', params: {'p_session_id': widget.sessionId});
      if (res is Map && res['success'] == true) {
        await _load();
      } else {
        setState(() => _actionError =
            (res is Map ? res['error'] as String? : null) ??
                'Could not cancel.');
      }
    } catch (_) {
      setState(() => _actionError = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _confirmPickup() async {
    final theme = FlutterFlowTheme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text('Confirm you have the item',
            style: TextStyle(color: theme.primaryText)),
        content: Text(
            'Do not confirm until you have seen and checked the item in person. Confirming releases payment to the seller immediately and cannot be undone.',
            style: TextStyle(color: theme.secondaryText)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Not yet')),
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('I have the item -- release payment',
                  style: TextStyle(color: theme.primary))),
        ],
      ),
    );
    if (confirmed != true || _acting) return;
    setState(() {
      _acting = true;
      _actionError = null;
    });
    try {
      final res = await Supabase.instance.client
          .rpc('confirm_pickup', params: {'p_session_id': widget.sessionId});
      if (res is Map && res['success'] == true) {
        await _load();
      } else {
        setState(() => _actionError =
            (res is Map ? res['error'] as String? : null) ??
                'Could not confirm.');
      }
    } catch (_) {
      setState(() => _actionError = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  String get _link {
    final id = Uri.encodeQueryComponent('${widget.sessionId}');
    // Short link: opens in the right app with a proper preview (campus.orija.app/go).
    return 'https://campus.orija.app/go/b/$id';
  }

  String get _shareText {
    final config = _config;
    final title = '${config?['item_title'] ?? 'this item'}';
    final currentBid = (config?['current_bid'] as num?) ??
        (config?['starting_price'] as num?) ??
        0;
    return [
      '$title -- current bid ${_naira(currentBid)} on Orija',
      'Place your bid before it closes:',
      _link,
    ].join('\n\n');
  }

  Future<void> _confirmShare() async {
    if (_sharing || widget.sessionId == null) return;
    setState(() => _sharing = true);
    try {
      final config = _config;
      final photos =
          (config?['item_photos'] as List?)?.cast<String>() ?? const [];
      final imageUrl = photos.isNotEmpty ? photos.first : '';
      XFile? imageFile;
      if (imageUrl.isNotEmpty) {
        try {
          final res = await http
              .get(Uri.parse(imageUrl))
              .timeout(const Duration(seconds: 10));
          if (res.statusCode == 200) {
            imageFile = XFile.fromData(res.bodyBytes,
                mimeType: 'image/jpeg',
                name: 'orija_bid_${widget.sessionId}.jpg');
          }
        } catch (_) {}
      }
      if (imageFile != null) {
        await Share.shareXFiles([imageFile],
            text: _shareText, subject: '${config?['item_title'] ?? ''}');
      } else {
        await Share.share(_shareText);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.primaryText),
        actions: [
          IconButton(
            onPressed: (_loading || _config == null) ? null : _confirmShare,
            icon: _sharing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: theme.primary))
                : Icon(Icons.ios_share_rounded, color: theme.primaryText),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _notFound || _session == null || _config == null
                ? Center(
                    child: Text('This bid could not be found.',
                        style: TextStyle(color: theme.secondaryText)))
                : RefreshIndicator(onRefresh: _load, child: _body(theme)),
      ),
    );
  }

  Widget _body(FlutterFlowTheme theme) {
    final session = _session!;
    final config = _config!;
    final isSeller = session['vendor_id'] == currentUserUid;
    final isEnded =
        session['status'] == 'ended' || session['status'] == 'cancelled';
    final outcome = config['outcome'] as String?;
    final winnerId = config['winner_id'] as String?;
    final isWinner = winnerId != null && winnerId == currentUserUid;
    final currentBid = (config['current_bid'] as num?) ??
        (config['starting_price'] as num?) ??
        0;
    final listing = config['listings'] as Map?;
    final photos = (config['item_photos'] as List?)?.cast<String>() ?? const [];
    final img = (listing?['primary_image_url'] as String?) ??
        (photos.isNotEmpty ? photos.first : null);
    final closesAt = _closesAt;

    final sellerName = _seller == null
        ? 'A seller'
        : '${_seller!['first_name'] ?? ''} ${_seller!['last_name'] ?? ''}'
            .trim();
    final sellerJoinYear = _seller != null && _seller!['created_at'] != null
        ? DateTime.tryParse('${_seller!['created_at']}')?.year
        : null;
    final sellerAvatar = _seller?['avatar_url'] as String?;
    final rating = _storefront?['avg_rating'] as num?;
    final reviewCount = _storefront?['total_reviews'] as num?;
    final pickupPlace = [_seller?['city'], _seller?['state']]
        .where((e) => e != null && '$e'.trim().isNotEmpty)
        .join(', ');

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 4),
        // ── Seller information ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seller information',
                  style: TextStyle(
                      color: theme.secondaryText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.alternate,
                backgroundImage: (sellerAvatar ?? '').isEmpty
                    ? null
                    : NetworkImage(sellerAvatar!),
                child: (sellerAvatar ?? '').isEmpty
                    ? Icon(Icons.person_outline, color: theme.secondaryText)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_storefront?['name'] as String? ?? sellerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    if (rating != null && reviewCount != null)
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: const Color(0xFFFFC94D), size: 14),
                          const SizedBox(width: 2),
                          Text(
                              '${rating.toStringAsFixed(1)} ($reviewCount reviews)',
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 11.5)),
                        ],
                      )
                    else if (sellerJoinYear != null)
                      Text('Joined Orija in $sellerJoinYear',
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 11.5)),
                  ],
                ),
              ),
              if (_session!['storefront_id'] != null && !isSeller)
                OutlinedButton(
                  onPressed: _followBusy ? null : _toggleFollow,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        _isFollowing ? theme.secondaryText : theme.primary,
                    side: BorderSide(
                        color: _isFollowing ? theme.alternate : theme.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(_isFollowing ? 'Following' : 'Follow',
                      style: const TextStyle(fontSize: 12.5)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Hero image ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 1.15,
              child: (img ?? '').isEmpty
                  ? Container(
                      color: theme.alternate,
                      child: Icon(Icons.gavel_rounded,
                          color: theme.secondaryText, size: 40))
                  : Image.network(img!, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(config['item_title'] as String? ?? '',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 19,
                        fontWeight: FontWeight.w700)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.alternate),
                ),
                child: Text(_naira(currentBid),
                    style: TextStyle(
                        color: theme.primary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        if (pickupPlace.isNotEmpty) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: theme.secondaryText, size: 14),
                const SizedBox(width: 3),
                Text('Pickup: $pickupPlace',
                    style: TextStyle(color: theme.secondaryText, fontSize: 12)),
              ],
            ),
          ),
        ],
        if ((config['item_description'] as String? ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(config['item_description'] as String,
                style: TextStyle(color: theme.secondaryText, fontSize: 13)),
          ),
        ],
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  isEnded
                      ? 'Ended'
                      : (closesAt != null ? _countdown(closesAt) : ''),
                  style: TextStyle(
                      color: theme.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              Text('${_ladder.length} bidder${_ladder.length == 1 ? '' : 's'}',
                  style: TextStyle(color: theme.secondaryText, fontSize: 12)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Divider(height: 1),
        ),

        // ── Bidders ladder ───────────────────────────────────────────
        Text('Bidders',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (_ladder.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text('No bids yet -- be the first.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 13)),
            ),
          )
        else
          for (var i = 0; i < _ladder.length; i++)
            _ladderRow(theme, _ladder[i], leading: i == 0),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Bidder identities are anonymous for security reasons.',
              style: TextStyle(color: theme.secondaryText, fontSize: 10.5)),
        ),

        // ── Leading-bidder closing alert ────────────────────────────
        if (!isEnded &&
            _ladder.isNotEmpty &&
            _ladder.first['isMe'] == true) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text('Alert me before bidding closes',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600)),
                ),
                Switch.adaptive(
                  value: _alertMeEnabled,
                  activeColor: theme.primary,
                  onChanged: (v) => setState(() => _alertMeEnabled = v),
                ),
              ],
            ),
          ),
          if (_alertMeEnabled &&
              closesAt != null &&
              closesAt.difference(_now).inSeconds > 0 &&
              closesAt.difference(_now).inMinutes < 5)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          'Bidding closes in ${_countdown(closesAt)} -- you are the highest bidder. If you stay in the lead, you will win and be required to complete pickup.',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
        ],
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_actionError != null) ...[
                Text(_actionError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12.5)),
                const SizedBox(height: 12),
              ],
              if (isEnded && outcome == null && isWinner) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: theme.secondary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You won this bid!',
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                          'Do not confirm until you have seen and checked the item in person. Confirming releases payment to the seller immediately.',
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 12)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _acting ? null : _confirmPickup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23)),
                          ),
                          child: const Text('I have the item -- confirm pickup',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (isSeller) ...[
                if (!isEnded) ...[
                  Text('Manage your auction',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _acting ? null : () => _extend(3),
                          child: const Text('Extend to 3 days'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _acting ? null : () => _extend(7),
                          child: const Text('Extend to 7 days'),
                        ),
                      ),
                    ],
                  ),
                  if (session['storefront_id'] != null &&
                      config['free_extension_used'] != true) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _acting ? null : _claimFreeExtension,
                        icon: Icon(Icons.card_giftcard_rounded,
                            size: 16, color: theme.primary),
                        label: Text('Claim free extension (Trader/Market Boss)',
                            style: TextStyle(color: theme.primary)),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.primary)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (_ladder.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _acting ? null : _endNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23)),
                        ),
                        child: Text(
                            'End now -- sell to #User${_ladder.first['rank']} (${_naira(_ladder.first['amount'] as num)})',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _acting ? null : _cancel,
                      child: const Text('Cancel auction',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ] else if (session['status'] == 'cancelled') ...[
                  Text('You cancelled this auction.',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 13)),
                  const SizedBox(height: 10),
                  Text('Restore it -- costs a fee, same as extending.',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _acting ? null : () => _restoreCancelled(3),
                          child: const Text('Restore -- 3 days'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _acting ? null : () => _restoreCancelled(7),
                          child: const Text('Restore -- 7 days'),
                        ),
                      ),
                    ],
                  ),
                ] else
                  Text(
                      outcome == 'sold'
                          ? 'Sold -- payment released to your wallet.'
                          : outcome == 'unsold_reserve_not_met'
                              ? 'Ended -- your reserve price was not met.'
                              : outcome == 'unsold_forfeited'
                                  ? 'Ended -- the winning bidder did not complete pickup.'
                                  : 'Ended -- awaiting the buyer to confirm pickup.',
                      style:
                          TextStyle(color: theme.secondaryText, fontSize: 13)),
              ] else if (!isEnded) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bidAmount,
                        focusNode: _bidFocus,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: theme.primaryText),
                        decoration: InputDecoration(
                          hintText:
                              'Min ${_naira(currentBid + ((config['bid_increment'] as num?) ?? 0))}',
                          hintStyle: TextStyle(
                              color: theme.secondaryText, fontSize: 13),
                          filled: true,
                          fillColor: theme.secondaryBackground,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _placingBid ? null : _placeBid,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _placingBid
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Bid',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ] else
                Text(
                    outcome == 'sold'
                        ? 'This bid has ended -- someone else won.'
                        : 'This bid has ended.',
                    style: TextStyle(color: theme.secondaryText, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _ladderRow(FlutterFlowTheme theme, Map<String, dynamic> row,
      {required bool leading}) {
    final isMe = row['isMe'] == true;
    final amount = row['amount'] as num;
    final rank = row['rank'] as int;
    final label = isMe ? '#User$rank (You)' : '#User$rank';
    final amountColor = leading
        ? Colors.red
        : isMe
            ? theme.primary
            : theme.secondaryText;
    final labelColor =
        leading ? Colors.red : (isMe ? theme.primary : theme.primaryText);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: theme.alternate,
            child: Icon(Icons.person_outline,
                size: 16, color: theme.secondaryText),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: labelColor,
                    fontSize: 13.5,
                    fontWeight:
                        leading || isMe ? FontWeight.w700 : FontWeight.w500)),
          ),
          if (isMe && !leading)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: InkWell(
                onTap: () => FocusScope.of(context).requestFocus(_bidFocus),
                child:
                    Icon(Icons.edit_outlined, size: 15, color: theme.primary),
              ),
            ),
          Text(_naira(amount),
              style: TextStyle(
                color: amountColor,
                fontSize: 13.5,
                fontWeight: leading ? FontWeight.w700 : FontWeight.w600,
                decoration: leading ? null : TextDecoration.lineThrough,
                decorationColor: theme.secondaryText,
              )),
        ],
      ),
    );
  }
}
