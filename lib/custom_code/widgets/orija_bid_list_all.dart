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

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Full list of every open timed bid -- the Explore row's "See more" circle
/// and nothing else. Same query shape as the row, just uncapped.
class OrijaBidListAll extends StatefulWidget {
  const OrijaBidListAll({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaBidListAll> createState() => _OrijaBidListAllState();
}

class _OrijaBidListAllState extends State<OrijaBidListAll> {
  bool _loading = true;
  List<Map<String, dynamic>> _bids = [];
  // 0 = Upcoming (scheduled), 1 = Live, 2 = Closed (ended/cancelled).
  int _tab = 1;

  // Desktop Shell rollout, Phase 3 (Pattern C). Selected bid shown in the
  // right-hand detail pane on desktop; unused and always null on mobile.
  String? _selectedBidId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await Supabase.instance.client
          .from('live_sessions')
          .select(
              'id, status, started_at, scheduled_at, max_duration_minutes, live_bid_config!inner(item_title, item_photos, listing_id, starting_price, current_bid, outcome, listings(primary_image_url, photos))')
          .eq('type', 'live_bid')
          .inFilter('status', ['scheduled', 'live', 'ended', 'cancelled'])
          .eq('is_video', false)
          .order('scheduled_at', ascending: false)
          .limit(150);
      if (!mounted) return;
      setState(() {
        _bids = List<Map<String, dynamic>>.from(rows as List);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final wanted = switch (_tab) {
      0 => const {'scheduled'},
      1 => const {'live'},
      _ => const {'ended', 'cancelled'},
    };
    final rows = _bids.where((b) => wanted.contains(b['status'])).toList();
    rows.sort((a, b) {
      final da = DateTime.tryParse('${a['scheduled_at'] ?? a['started_at']}');
      final db = DateTime.tryParse('${b['scheduled_at'] ?? b['started_at']}');
      if (da == null || db == null) return 0;
      return _tab == 0 ? da.compareTo(db) : db.compareTo(da);
    });
    return rows;
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

  static const _months = [
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
    'Dec',
  ];

  String _shortDate(DateTime d) => '${_months[d.month - 1]} ${d.day}';

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 3 (Pattern C browse/detail split).
    // Mobile body below is untouched; this gate is unreachable on a real
    // phone. Tapping a row sets _selectedBidId instead of pushing a route
    // on desktop -- see the onTap branch further down in _mobileBody.
    if (OrijaDesktopShell.isDesktop(context)) {
      final theme = FlutterFlowTheme.of(context);
      return OrijaDesktopShell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 380, child: _mobileBody(context)),
            VerticalDivider(width: 1, color: theme.alternate),
            Expanded(
              child: _selectedBidId == null
                  ? Center(
                      child: Text(
                        'Select a bid to see details',
                        style: theme.bodyMedium.override(
                          color: theme.secondaryText,
                        ),
                      ),
                    )
                  : OrijaBidDetail(sessionId: _selectedBidId),
            ),
          ],
        ),
      );
    }
    return _mobileBody(context);
  }

  Widget _mobileBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.primaryText),
        title: Text('Live Bidding',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        actions: [
          TextButton.icon(
            onPressed: () => context.pushNamed('myBids'),
            icon: Icon(Icons.gavel_rounded, size: 16, color: theme.primary),
            label: Text('My Bids',
                style: TextStyle(
                    color: theme.primary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  for (final entry in const {
                    0: 'Upcoming',
                    1: 'Live',
                    2: 'Closed',
                  }.entries)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(entry.value),
                        selected: _tab == entry.key,
                        onSelected: (_) => setState(() => _tab = entry.key),
                        selectedColor: theme.primary,
                        labelStyle: TextStyle(
                            color: _tab == entry.key
                                ? Colors.white
                                : theme.primaryText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600),
                        backgroundColor: theme.secondaryBackground,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? Center(
                          child: Text(
                              _tab == 0
                                  ? 'No upcoming bids right now.'
                                  : _tab == 1
                                      ? 'No bids are open right now.'
                                      : 'No closed bids yet.',
                              style: TextStyle(color: theme.secondaryText)))
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: _filtered.length,
                            itemBuilder: (context, i) {
                              final b = _filtered[i];
                              final status = b['status'] as String?;
                              final config =
                                  (b['live_bid_config'] as Map?) ?? const {};
                              final listing = config['listings'] as Map?;
                              final itemPhotos = config['item_photos'];
                              final img = (listing?['primary_image_url']
                                      as String?) ??
                                  (itemPhotos is List && itemPhotos.isNotEmpty
                                      ? '${itemPhotos.first}'
                                      : null);
                              final price = (config['current_bid'] as num?) ??
                                  (config['starting_price'] as num?) ??
                                  0;
                              String? badge;
                              Color badgeColor = theme.primary;
                              if (status == 'scheduled') {
                                final at =
                                    DateTime.tryParse('${b['scheduled_at']}');
                                badge = at == null
                                    ? 'UPCOMING'
                                    : 'Opens ${_shortDate(at)}';
                                badgeColor = theme.secondaryText;
                              } else if (status == 'live') {
                                badge = 'LIVE';
                                badgeColor = Colors.red;
                              } else {
                                final outcome = config['outcome'] as String?;
                                badge = outcome == 'sold'
                                    ? 'SOLD'
                                    : outcome == 'unsold'
                                        ? 'UNSOLD'
                                        : status == 'cancelled'
                                            ? 'CANCELLED'
                                            : 'CLOSED';
                                badgeColor = theme.secondaryText;
                              }
                              return InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  // Desktop Shell rollout, Phase 3: desktop
                                  // selects into the right-hand pane instead
                                  // of pushing a route; mobile is unchanged.
                                  if (OrijaDesktopShell.isDesktop(context)) {
                                    setState(
                                        () => _selectedBidId = '${b['id']}');
                                  } else {
                                    context.pushNamed('bidDetailPage',
                                        queryParameters: {
                                          'sessionId': '${b['id']}'
                                        });
                                  }
                                },
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: theme.secondaryBackground,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: theme.alternate),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            (img ?? '').isEmpty
                                                ? Container(
                                                    color: theme.alternate,
                                                    child: Icon(
                                                        Icons.gavel_rounded,
                                                        color: theme
                                                            .secondaryText))
                                                : Image.network(img!,
                                                    fit: BoxFit.cover),
                                            Positioned(
                                              top: 6,
                                              left: 6,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: badgeColor
                                                      .withOpacity(0.92),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(badge,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 8, 10, 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                config['item_title']
                                                        as String? ??
                                                    '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: theme.primaryText,
                                                    fontSize: 12.5)),
                                            Text(_naira(price),
                                                style: TextStyle(
                                                    color: theme.primary,
                                                    fontSize: 13.5,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
