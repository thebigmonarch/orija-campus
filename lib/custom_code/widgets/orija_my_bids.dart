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

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Every timed bid this user is involved in, from either side: "Bidding" --
/// auctions they've placed a bid on, as buyer -- and "Selling" -- auctions
/// they've opened themselves. Each row opens the same OrijaBidDetail that
/// Explore/OjaFeed/the live-bidding list all use, so it's just a different
/// entry point onto the same surface.
class OrijaMyBids extends StatefulWidget {
  const OrijaMyBids({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaMyBids> createState() => _OrijaMyBidsState();
}

class _OrijaMyBidsState extends State<OrijaMyBids> {
  bool _loading = true;
  List<Map<String, dynamic>> _bidding = [];
  List<Map<String, dynamic>> _selling = [];
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final supabase = Supabase.instance.client;
    try {
      final bidRows = await supabase
          .from('bids')
          .select('session_id, placed_at')
          .eq('bidder_id', currentUserUid)
          .order('placed_at', ascending: false);
      final sessionIds = List<Map<String, dynamic>>.from(bidRows as List)
          .map((r) => r['session_id'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

      List<Map<String, dynamic>> bidding = [];
      if (sessionIds.isNotEmpty) {
        final rows = await supabase
            .from('live_sessions')
            .select(
                'id, status, vendor_id, started_at, max_duration_minutes, live_bid_config(item_title, item_photos, current_bid, starting_price, winner_id, outcome, listings(primary_image_url))')
            .inFilter('id', sessionIds)
            .order('started_at', ascending: false);
        bidding = List<Map<String, dynamic>>.from(rows as List);
      }

      final sellingRows = await supabase
          .from('live_sessions')
          .select(
              'id, status, started_at, max_duration_minutes, live_bid_config(item_title, item_photos, current_bid, starting_price, winner_id, outcome, listings(primary_image_url))')
          .eq('vendor_id', currentUserUid)
          .eq('type', 'live_bid')
          .order('started_at', ascending: false);
      final selling = List<Map<String, dynamic>>.from(sellingRows as List);

      if (!mounted) return;
      setState(() {
        _bidding = bidding;
        _selling = selling;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
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

  String _statusLabel(Map<String, dynamic> row, {required bool asBidder}) {
    final status = row['status'] as String?;
    final config = (row['live_bid_config'] as Map?) ?? const {};
    final outcome = config['outcome'] as String?;
    if (status == 'live') return 'Open';
    if (status == 'cancelled' || outcome == 'cancelled') return 'Cancelled';
    if (outcome == 'sold') {
      final winnerId = config['winner_id'] as String?;
      if (asBidder) return winnerId == currentUserUid ? 'You won' : 'Ended';
      return 'Sold';
    }
    if (outcome == 'unsold_forfeited') return 'Forfeited';
    if (outcome == null) return 'Awaiting pickup';
    return 'Ended';
  }

  Color _statusColor(FlutterFlowTheme theme, String label) {
    switch (label) {
      case 'Open':
        return theme.primary;
      case 'You won':
        return theme.secondary;
      case 'Cancelled':
      case 'Forfeited':
        return Colors.red;
      default:
        return theme.secondaryText;
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
        title: Text('My Bids',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                      child: Row(
                        children: [
                          _tabButton(theme, 'Bidding (${_bidding.length})', 0),
                          const SizedBox(width: 22),
                          _tabButton(theme, 'Selling (${_selling.length})', 1),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _tab == 0
                          ? _list(theme, _bidding, asBidder: true)
                          : _list(theme, _selling, asBidder: false),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _tabButton(FlutterFlowTheme theme, String label, int index) {
    final active = _tab == index;
    return InkWell(
      onTap: () => setState(() => _tab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: active ? theme.primary : theme.secondaryText,
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          const SizedBox(height: 6),
          Container(
            width: 28,
            height: 2.5,
            color: active ? theme.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _list(FlutterFlowTheme theme, List<Map<String, dynamic>> rows,
      {required bool asBidder}) {
    if (rows.isEmpty) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Text(
                  asBidder
                      ? "You haven't placed any bids yet."
                      : "You haven't opened any bids yet.",
                  style: TextStyle(color: theme.secondaryText)),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final row = rows[i];
        final config = (row['live_bid_config'] as Map?) ?? const {};
        final listing = config['listings'] as Map?;
        final itemPhotos = config['item_photos'];
        final img = (listing?['primary_image_url'] as String?) ??
            (itemPhotos is List && itemPhotos.isNotEmpty
                ? '${itemPhotos.first}'
                : null);
        final price = (config['current_bid'] as num?) ??
            (config['starting_price'] as num?) ??
            0;
        final label = _statusLabel(row, asBidder: asBidder);

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.pushNamed('bidDetailPage',
              queryParameters: {'sessionId': '${row['id']}'}),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.alternate),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: (img ?? '').isEmpty
                        ? Container(
                            color: theme.alternate,
                            child: Icon(Icons.gavel_rounded,
                                size: 20, color: theme.secondaryText))
                        : Image.network(img!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(config['item_title'] as String? ?? 'Bid item',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(_naira(price),
                          style: TextStyle(
                              color: theme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(theme, label).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(label,
                      style: TextStyle(
                          color: _statusColor(theme, label),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
