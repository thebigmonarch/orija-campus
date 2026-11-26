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

import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

const String _kOrijaSupportLogo =
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/orija-h-q-hv0u3u/assets/8tyk68bf7yh9/Orija_Logo3.png';

/// Suggestion/feedback categories shown as chips in the Suggestions sheet.
/// "Suggestion" is intentionally first. Values map to the `feedback_type`
/// Postgres enum (via the `submit_feedback` RPC, same backend path the
/// standalone Help & Feedback form already uses).
const Map<String, String> _kSuggestionTypes = <String, String>{
  'Suggestion': 'suggestion',
  'Bug': 'bug_report',
  'Feature': 'feature_request',
  'General': 'general',
  'Compliment': 'compliment',
  'Complaint': 'complaint',
};

/// The bundled logo first (instant, works offline); the web copy only if the
/// bundled file is missing.
Widget _orijaSupportLogoImage({required Widget fallback}) => Image.asset(
      'assets/images/Orija_Logo3.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.network(_kOrijaSupportLogo,
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback),
    );

/// Orija Support: an official, one-way channel. Announcements and the welcome
/// messages arrive here as message bubbles and cards. Users can tap common
/// questions (answers are shown in the thread), or send a support request.
/// There is deliberately no free-text input bar.
///
/// Everything is read through SECURITY DEFINER RPCs that use the signed-in
/// user (support_feed, support_faq_list, support_mark_read, support_contact),
/// so audience targeting (buyers, vendors, states) is decided on the server.
class OrijaSupport extends StatefulWidget {
  const OrijaSupport({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaSupport> createState() => _OrijaSupportState();
}

class _SupportItem {
  _SupportItem({
    this.id,
    required this.incoming,
    required this.body,
    this.title,
    this.imageUrl,
    this.ctaLabel,
    this.ctaKey,
    this.ctaUrl,
    this.at,
  });

  final String? id;
  final bool incoming;
  final String body;
  final String? title;
  final String? imageUrl;
  final String? ctaLabel;
  final String? ctaKey;
  final String? ctaUrl;
  final DateTime? at;
}

class _OrijaSupportState extends State<OrijaSupport> {
  final ScrollController _scroll = ScrollController();
  Timer? _poll;

  bool _loading = true;
  bool _failed = false;
  List<_SupportItem> _posts = [];
  final List<_SupportItem> _local = [];
  List<Map<String, dynamic>> _faqs = [];
  List<Map<String, dynamic>> _changelog = [];
  Map<String, dynamic> _tracks = {};
  final Map<String, String> _myReactions = {};

  @override
  void initState() {
    super.initState();
    _load();
    _poll = Timer.periodic(const Duration(seconds: 30), (_) => _refresh());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final sb = Supabase.instance.client;
      final feed = await sb.rpc('support_feed', params: {'p_limit': 80});
      final faqs = await sb.rpc('support_faq_list');
      Map<String, dynamic> tracks = {};
      try {
        tracks = Map<String, dynamic>.from(
            (await sb.rpc('support_track_status') as Map?) ?? {});
      } catch (_) {}
      List<Map<String, dynamic>> changelog = [];
      try {
        final cl =
            await sb.rpc('support_changelog_list', params: {'p_limit': 20});
        changelog = List<Map<String, dynamic>>.from((cl as List?) ?? []);
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _posts = _parse(feed);
        _faqs = List<Map<String, dynamic>>.from((faqs as List?) ?? []);
        _changelog = changelog;
        _tracks = tracks;
        _loading = false;
        _failed = false;
      });
      _scrollToEnd();
      sb.rpc('support_mark_read').then((_) {}, onError: (_) {});
      // Engagement tracking: which posts this user has seen (once each).
      final ids = _posts.map((p) => p.id).whereType<String>().toList();
      if (ids.isNotEmpty) {
        sb.rpc('support_log_events', params: {
          'p_post_ids': ids,
          'p_event': 'open'
        }).then((_) {}, onError: (_) {});
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = _posts.isEmpty;
      });
    }
  }

  Future<void> _refresh() async {
    try {
      final feed = await Supabase.instance.client
          .rpc('support_feed', params: {'p_limit': 80});
      final next = _parse(feed);
      if (!mounted) return;
      if (next.length != _posts.length) {
        setState(() => _posts = next);
        _scrollToEnd();
        Supabase.instance.client
            .rpc('support_mark_read')
            .then((_) {}, onError: (_) {});
      }
    } catch (_) {}
  }

  List<_SupportItem> _parse(dynamic feed) {
    return List<Map<String, dynamic>>.from((feed as List?) ?? [])
        .map((p) => _SupportItem(
              id: p['id'] as String?,
              incoming: true,
              title: p['title'] as String?,
              body: (p['body'] as String?) ?? '',
              imageUrl: p['image_url'] as String?,
              ctaLabel: p['cta_label'] as String?,
              ctaKey: p['cta_key'] as String?,
              ctaUrl: p['cta_url'] as String?,
              at: DateTime.tryParse('${p['created_at']}')?.toLocal(),
            ))
        .toList();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(_scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  Future<void> _open(_SupportItem it) async {
    if (it.id != null) {
      Supabase.instance.client.rpc('support_log_events', params: {
        'p_post_ids': [it.id],
        'p_event': 'tap'
      }).then((_) {}, onError: (_) {});
    }
    final key = it.ctaKey ?? '';
    final url = it.ctaUrl ?? '';
    if (key.isEmpty && url.isNotEmpty) {
      await launchURL(url);
      return;
    }
    if (key == 'explore') {
      // The market lives on Home.
      context.goNamed(HomePageWidget.routeName);
      return;
    }
    final routes = <String, String>{
      'practice_buyer': 'OrijaPracticePage',
      'practice_vendor': 'OrijaPracticePage',
      'profile': 'profilePage',
      'open_store': 'SellPage',
      'my_store': 'myStorefront',
      'orders': 'OrijaMyOrdersPage',
      'communities': 'communitiesByInterest',
      'help': 'HelpFeedback',
      'notifications': 'notificationsPage',
    };
    final route = routes[key];
    if (route != null) {
      final isPractice = key.startsWith('practice_');
      await context.pushNamed(route,
          queryParameters: isPractice
              ? {'track': key.substring(9)}
              : const <String, String>{});
      if (isPractice && mounted) _load();
    } else if (url.isNotEmpty) {
      await launchURL(url);
    }
  }

  /// Quick, write-only reaction on a broadcast post (no visible aggregate
  /// counts -- that needs a read RPC, treated as a later nice-to-have).
  /// Logged through the same support_log_events RPC used for open/tap, now
  /// extended to accept event='react' + a reaction value, upserted so a
  /// user's reaction can change rather than duplicate.
  Future<void> _react(String postId, String emoji) async {
    setState(() => _myReactions[postId] = emoji);
    Supabase.instance.client.rpc('support_log_events', params: {
      'p_post_ids': [postId],
      'p_event': 'react',
      'p_reaction': emoji,
    }).then((_) {}, onError: (_) {});
  }

  /// Lets the user optionally attach one of their recent orders to a
  /// suggestion/feedback submission, so replies are faster to act on. Same
  /// query pattern `orija_my_orders.dart` already uses for "my orders".
  /// Returns (orderId, label) or null if the user backs out.
  Future<(String, String)?> _pickOrder() async {
    final t = FlutterFlowTheme.of(context);
    List<VOrderFullRow> orders = [];
    try {
      orders = await VOrderFullTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('buyer_id', currentUserUid)
            .order('created_at', ascending: false)
            .limit(5),
      );
    } catch (_) {}
    if (!mounted) return null;
    return showModalBottomSheet<(String, String)?>(
      context: context,
      backgroundColor: t.primaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attach an order',
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              if (orders.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('No orders yet.',
                      style: TextStyle(color: t.secondaryText, fontSize: 13.5)),
                )
              else
                ...orders.map((o) {
                  final label =
                      '${o.orderRef ?? 'Order'} • ${o.orderStatus ?? ''}';
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.pop(ctx, (o.orderId ?? '', label)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(label,
                          style: TextStyle(color: t.primaryText, fontSize: 14)),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  /// Opens the "Suggestions" sheet: a type-chip bar (Suggestion first) above
  /// a single text field, with an optional order attachment. Posts through
  /// `submit_feedback` (the same RPC the standalone Help & Feedback form
  /// uses) so all feedback lands in one `feedback` table with one
  /// consistent set of categories.
  Future<void> _contact() async {
    final theme = FlutterFlowTheme.of(context);
    final message = TextEditingController();
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.primaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        var selectedType = _kSuggestionTypes.keys.first; // 'Suggestion'
        bool busy = false;
        String? error;
        String? selectedOrderId;
        String? selectedOrderLabel;
        return StatefulBuilder(builder: (ctx, setSheet) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Share feedback',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Ideas, bugs, or anything else on your mind.',
                    style: TextStyle(color: theme.secondaryText, fontSize: 13)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _kSuggestionTypes.keys.map((label) {
                    final selected = selectedType == label;
                    return InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => setSheet(() => selectedType = label),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? theme.primary
                              : theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color:
                                  selected ? theme.primary : theme.alternate),
                        ),
                        child: Text(label,
                            style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : theme.secondaryText,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: message,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 4000,
                  decoration: const InputDecoration(
                      hintText: "Tell us what's on your mind...",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    if (selectedOrderId != null) {
                      setSheet(() {
                        selectedOrderId = null;
                        selectedOrderLabel = null;
                      });
                      return;
                    }
                    final picked = await _pickOrder();
                    if (picked != null) {
                      setSheet(() {
                        selectedOrderId = picked.$1;
                        selectedOrderLabel = picked.$2;
                      });
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.alternate),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            selectedOrderId != null
                                ? Icons.close_rounded
                                : Icons.receipt_long_outlined,
                            size: 15,
                            color: theme.secondaryText),
                        const SizedBox(width: 6),
                        Text(selectedOrderLabel ?? 'Attach an order (optional)',
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 12.5)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(error!,
                        style: TextStyle(color: theme.error, fontSize: 12.5)),
                  )
                else
                  const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: busy
                        ? null
                        : () async {
                            if (message.text.trim().isEmpty) {
                              setSheet(() =>
                                  error = 'Please tell us something first.');
                              return;
                            }
                            setSheet(() {
                              busy = true;
                              error = null;
                            });
                            try {
                              // Direct RPC call (not the generated
                              // SubmitFeedbackCall wrapper) so we can pass
                              // the optional p_related_order_id param added
                              // for the order-attach feature.
                              final res = await Supabase.instance.client.rpc(
                                'submit_feedback',
                                params: {
                                  'p_user_id': currentUserUid,
                                  'p_type': _kSuggestionTypes[selectedType] ??
                                      'general',
                                  'p_body': message.text.trim(),
                                  'p_screen_name': 'orija_support',
                                  'p_related_order_id': selectedOrderId,
                                },
                              );
                              final body = res is Map
                                  ? Map<String, dynamic>.from(res)
                                  : <String, dynamic>{};
                              final ok = body['success'] == true;
                              if (!ok) {
                                setSheet(() {
                                  busy = false;
                                  error = (body['error'] as String?) ??
                                      'Could not send. Please try again.';
                                });
                                return;
                              }
                              if (ctx.mounted) Navigator.pop(ctx, true);
                            } catch (e) {
                              setSheet(() {
                                busy = false;
                                error =
                                    'Could not send. Check your connection and try again.';
                              });
                            }
                          },
                    child: Text(busy ? 'Sending...' : 'Send'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
    message.dispose();
    if (sent == true && mounted) {
      setState(() {
        _local.add(_SupportItem(
            incoming: true,
            body:
                'Thanks, we have received your message. Our team will get back to you by email or in the app.',
            at: DateTime.now()));
      });
      _scrollToEnd();
    }
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
    final items = [..._posts, ..._local];
    return Container(
      color: t.primaryBackground,
      child: Column(
        children: [
          _header(t),
          Expanded(child: _content(t, items)),
          _footer(t),
        ],
      ),
    );
  }

  Widget _header(FlutterFlowTheme t) {
    return Container(
      decoration: BoxDecoration(
        color: t.primaryBackground,
        border: Border(bottom: BorderSide(color: t.alternate)),
      ),
      padding:
          EdgeInsets.fromLTRB(4, MediaQuery.of(context).padding.top + 6, 12, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: t.primaryText),
            onPressed: () => context.safePop(),
          ),
          ClipOval(
            child: Container(
              width: 40,
              height: 40,
              color: Colors.white,
              child: _orijaSupportLogoImage(
                fallback: Container(
                  color: t.primary,
                  child: const Icon(Icons.support_agent_rounded,
                      color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Orija Support',
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(width: 4),
                    Icon(Icons.verified_rounded, color: t.secondary, size: 16),
                  ],
                ),
                Text('Official updates and help',
                    style: TextStyle(color: t.secondaryText, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(FlutterFlowTheme t, List<_SupportItem> items) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: t.primary));
    }
    if (_failed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 44, color: t.secondaryText),
            const SizedBox(height: 10),
            Text('Could not load Orija Support',
                style: TextStyle(
                    color: t.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            TextButton(
                onPressed: () {
                  setState(() => _loading = true);
                  _load();
                },
                child: Text('Try again', style: TextStyle(color: t.primary))),
          ],
        ),
      );
    }
    if (items.isEmpty) {
      return Center(
        child: Text('Nothing here yet.',
            style: TextStyle(color: t.secondaryText, fontSize: 14)),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        final prev = i > 0 ? items[i - 1] : null;
        final newDay = it.at != null &&
            (prev?.at == null ||
                prev!.at!.year != it.at!.year ||
                prev.at!.month != it.at!.month ||
                prev.at!.day != it.at!.day);
        return Column(
          children: [
            if (newDay) _dayLabel(t, it.at!),
            _bubble(t, it),
          ],
        );
      },
    );
  }

  Widget _dayLabel(FlutterFlowTheme t, DateTime d) {
    final now = DateTime.now();
    final same = d.year == now.year && d.month == now.month && d.day == now.day;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        same ? 'Today' : dateTimeFormat('MMMd', d),
        style: TextStyle(
            color: t.secondaryText,
            fontSize: 11.5,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _bubble(FlutterFlowTheme t, _SupportItem it) {
    final maxW = MediaQuery.of(context).size.width * 0.82;
    final mine = !it.incoming;
    final hasCta = (it.ctaLabel ?? '').isNotEmpty &&
        ((it.ctaKey ?? '').isNotEmpty || (it.ctaUrl ?? '').isNotEmpty);
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: maxW),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mine ? t.primary : t.secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine ? null : Border.all(color: t.alternate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((it.imageUrl ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(it.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                ),
              ),
            if ((it.title ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(it.title!,
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
              ),
            Text(it.body,
                style: TextStyle(
                    color: mine ? Colors.white : t.primaryText,
                    fontSize: 14,
                    height: 1.35)),
            if (hasCta)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: t.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () => _open(it),
                    child: Text(it.ctaLabel!,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            if (it.at != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(dateTimeFormat('jm', it.at!),
                      style: TextStyle(
                          color: mine ? Colors.white70 : t.secondaryText,
                          fontSize: 10.5)),
                ),
              ),
            if (!mine && it.id != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ['👍', '❤️'].map((emoji) {
                    final selected = _myReactions[it.id] == emoji;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _react(it.id!, emoji),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected
                                ? t.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected ? t.primary : t.alternate),
                          ),
                          child:
                              Text(emoji, style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------ help footer
  Widget _footer(FlutterFlowTheme t) {
    Widget tile(IconData icon, String label, VoidCallback onTap,
        {String? badge}) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: t.secondaryBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: t.alternate),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(icon, color: t.primary, size: 24),
                    if (badge != null)
                      Positioned(
                        right: -16,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                              color: t.secondary,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(badge,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(label,
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
    }

    final doneBuyer = (_tracks['buyer'] as Map?)?['completed'] == true;
    final doneVendor = (_tracks['vendor'] as Map?)?['completed'] == true;
    final practiceLeft = (doneBuyer ? 0 : 1) + (doneVendor ? 0 : 1);
    return Container(
      decoration: BoxDecoration(
        color: t.primaryBackground,
        border: Border(top: BorderSide(color: t.alternate)),
      ),
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).padding.bottom + 10),
      child: Row(
        children: [
          tile(Icons.help_outline_rounded, 'Common questions', _openFaqs),
          const SizedBox(width: 8),
          tile(Icons.school_outlined, 'Practice', _openPractice,
              badge: practiceLeft > 0 ? '$practiceLeft new' : null),
          const SizedBox(width: 8),
          tile(Icons.lightbulb_outline_rounded, 'Suggestions', _contact),
          const SizedBox(width: 8),
          tile(Icons.auto_awesome_rounded, "What's new", _openChangelog,
              badge: _changelog.isNotEmpty ? '${_changelog.length}' : null),
        ],
      ),
    );
  }

  /// "What's new": recent fixes/features, authored the same way
  /// announcements already are (a direct insert into `support_posts` with
  /// `kind = 'changelog'`). Closes the loop with people whose suggestions
  /// get shipped.
  Future<void> _openChangelog() async {
    final t = FlutterFlowTheme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.primaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (ctx, scroll) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                          color: t.alternate,
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("What's new",
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: _changelog.isEmpty
                  ? Center(
                      child: Text('Nothing new yet.',
                          style:
                              TextStyle(color: t.secondaryText, fontSize: 14)),
                    )
                  : ListView.builder(
                      controller: scroll,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _changelog.length,
                      itemBuilder: (_, i) {
                        final e = _changelog[i];
                        final at =
                            DateTime.tryParse('${e['created_at']}')?.toLocal();
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: t.secondaryBackground,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: t.alternate),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((e['title'] ?? '').toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text('${e['title']}',
                                      style: TextStyle(
                                          color: t.primaryText,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800)),
                                ),
                              Text('${e['body'] ?? ''}',
                                  style: TextStyle(
                                      color: t.secondaryText,
                                      fontSize: 13.5,
                                      height: 1.4)),
                              if (at != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(dateTimeFormat('MMMd', at),
                                      style: TextStyle(
                                          color: t.secondaryText,
                                          fontSize: 11)),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPractice() async {
    final t = FlutterFlowTheme.of(context);
    Widget card(
        String track, String title, String subtitle, IconData icon, int total) {
      final m = Map<String, dynamic>.from((_tracks[track] as Map?) ?? {});
      final done = (m['steps_done'] as num?)?.toInt() ?? 0;
      final completed = m['completed'] == true;
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          Navigator.pop(context);
          await context.pushNamed('OrijaPracticePage',
              queryParameters: {'track': track});
          if (mounted) _load();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: completed ? t.success : t.alternate),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                    color: t.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle),
                child: Icon(icon, color: t.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: t.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style:
                            TextStyle(color: t.secondaryText, fontSize: 12.5)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: completed ? 1 : done / total,
                        minHeight: 5,
                        color: completed ? t.success : t.primary,
                        backgroundColor: t.alternate,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(completed ? 'Done' : (done > 0 ? '$done/$total' : 'Start'),
                  style: TextStyle(
                      color: completed ? t.success : t.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13)),
            ],
          ),
        ),
      );
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.primaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                        color: t.alternate,
                        borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 14),
              Text('Practice with pretend orders',
                  style: TextStyle(
                      color: t.primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Nothing is real. No money moves and no orders are made.',
                  style: TextStyle(color: t.secondaryText, fontSize: 13)),
              const SizedBox(height: 14),
              card(
                  'buyer',
                  'Practice buying',
                  'Find an item, pay, confirm delivery and review.',
                  Icons.shopping_bag_outlined,
                  6),
              card(
                  'vendor',
                  'Practice selling',
                  'List, confirm a bag, ship and get paid.',
                  Icons.storefront_outlined,
                  5),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openFaqs() async {
    final t = FlutterFlowTheme.of(context);
    final search = TextEditingController();
    final opened = <String>{};
    final groups = <String, List<Map<String, dynamic>>>{
      'Buying': [],
      'Selling': [],
      'General': [],
    };
    for (final f in _faqs) {
      final role = '${f['audience_role'] ?? ''}';
      groups[role == 'buyer'
              ? 'Buying'
              : (role == 'vendor' ? 'Selling' : 'General')]!
          .add(f);
    }
    final contact = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: t.primaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.86,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scroll) => StatefulBuilder(builder: (ctx, setSheet) {
          final q = search.text.trim().toLowerCase();
          bool match(Map<String, dynamic> f) =>
              q.isEmpty ||
              '${f['question']} ${f['answer']}'.toLowerCase().contains(q);
          final sections = <Widget>[];
          groups.forEach((name, items) {
            final shown = items.where(match).toList();
            if (shown.isEmpty) return;
            sections.add(Padding(
              padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
              child: Row(
                children: [
                  Icon(
                      name == 'Buying'
                          ? Icons.shopping_bag_outlined
                          : (name == 'Selling'
                              ? Icons.storefront_outlined
                              : Icons.info_outline_rounded),
                      size: 16,
                      color: t.primary),
                  const SizedBox(width: 6),
                  Text(name.toUpperCase(),
                      style: TextStyle(
                          color: t.secondaryText,
                          fontSize: 11.5,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ));
            for (final f in shown) {
              final id = '${f['id']}';
              final open =
                  opened.contains(id) || (q.isNotEmpty && shown.length < 4);
              sections.add(Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: t.secondaryBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: open ? t.primary : t.alternate),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setSheet(() {
                    if (!opened.remove(id)) opened.add(id);
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('${f['question']}',
                                  style: TextStyle(
                                      color: t.primaryText,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700)),
                            ),
                            AnimatedRotation(
                              turns: open ? 0.5 : 0,
                              duration: const Duration(milliseconds: 180),
                              child: Icon(Icons.keyboard_arrow_down_rounded,
                                  color: t.secondaryText),
                            ),
                          ],
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 180),
                          alignment: Alignment.topLeft,
                          child: open
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('${f['answer']}',
                                      style: TextStyle(
                                          color: t.secondaryText,
                                          fontSize: 13.5,
                                          height: 1.45)),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
            }
          });
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Column(
                  children: [
                    Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                            color: t.alternate,
                            borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Common questions',
                          style: TextStyle(
                              color: t.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: search,
                      onChanged: (_) => setSheet(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search help',
                        isDense: true,
                        filled: true,
                        fillColor: t.secondaryBackground,
                        prefixIcon: const Icon(Icons.search_rounded),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    if (sections.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 40, color: t.secondaryText),
                            const SizedBox(height: 8),
                            Text('No answers found',
                                style: TextStyle(
                                    color: t.primaryText,
                                    fontWeight: FontWeight.w700)),
                            Text('Try different words, or contact us.',
                                style: TextStyle(
                                    color: t.secondaryText, fontSize: 13)),
                          ],
                        ),
                      ),
                    ...sections,
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: t.alternate))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Still need help?',
                            style: TextStyle(
                                color: t.primaryText,
                                fontWeight: FontWeight.w700)),
                      ),
                      FilledButton.icon(
                        style:
                            FilledButton.styleFrom(backgroundColor: t.primary),
                        onPressed: () => Navigator.pop(ctx, true),
                        icon: const Icon(Icons.mail_outline_rounded, size: 18),
                        label: const Text('Contact us'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
    search.dispose();
    if (contact == true && mounted) _contact();
  }
}
