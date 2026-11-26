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

import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// The Reviews tab of a storefront: the rating breakdown (overall score, how
/// many gave each star, and the four scored areas), then the reviews
/// themselves. Anyone can like a review and reply to it; replies can be
/// replied to (they sit in one thread under the review); the seller can also
/// leave their official response. It doesn't scroll on its own: it sits
/// inside the storefront page's scroll view.
class OrijaStoreReviews extends StatefulWidget {
  const OrijaStoreReviews({
    super.key,
    this.width,
    this.height,
    required this.storefrontId,
    this.ownerId,
  });

  final double? width;
  final double? height;
  final String? storefrontId;
  final String? ownerId;

  @override
  State<OrijaStoreReviews> createState() => _OrijaStoreReviewsState();
}

class _OrijaStoreReviewsState extends State<OrijaStoreReviews> {
  bool get _agentStore => _summary?['storefront_type'] == 'agent';
  final _db = Supabase.instance.client;

  static const _pageSize = 15;

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = false;
  Map<String, dynamic>? _summary;
  List<int> _ratings = [];
  List<Map<String, dynamic>> _reviews = [];
  final Set<String> _liked = {};
  int? _filter; // null = all, else a star count

  final Set<String> _open = {}; // review ids whose thread is expanded
  final Map<String, List<Map<String, dynamic>>> _replies = {};
  final Set<String> _repliesLoading = {};
  final Set<String> _likedReplies = {};
  final Map<String, TextEditingController> _composers = {};
  final Map<String, Map<String, dynamic>?> _replyingTo = {};
  final Set<String> _posting = {};

  bool get _isOwner =>
      (widget.ownerId ?? '').isNotEmpty && widget.ownerId == currentUserUid;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in _composers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ------------------------------------------------------------- loading

  Future<void> _load() async {
    final id = widget.storefrontId ?? '';
    if (id.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final summary = await _db
          .from('storefronts_with_review_summary')
          .select(
              'avg_rating, total_reviews, avg_product_accuracy, avg_communication, avg_packaging, avg_value_for_money, storefront_type')
          .eq('id', id)
          .maybeSingle();
      final all = await _db
          .from('reviews')
          .select('overall_rating')
          .eq('storefront_id', id)
          .eq('status', 'visible')
          .limit(2000);
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _ratings = [
          for (final r in (all as List))
            ((r['overall_rating'] as num?)?.toInt() ?? 0)
        ];
      });
      await _loadReviews(reset: true);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadReviews({bool reset = false}) async {
    final id = widget.storefrontId ?? '';
    final offset = reset ? 0 : _reviews.length;
    try {
      var q = _db
          .from('reviews')
          .select(
              '*, users!reviews_reviewer_id_fkey(first_name, last_name, avatar_url, oja_tier, oja_tier_title)')
          .eq('storefront_id', id)
          .eq('status', 'visible');
      if (_filter != null) q = q.eq('overall_rating', _filter!);
      final rows = await q
          .order('created_at', ascending: false)
          .range(offset, offset + _pageSize - 1);
      final list = List<Map<String, dynamic>>.from(rows as List);
      final ids = list.map((r) => '${r['id']}').toList();
      final mine = ids.isEmpty || currentUserUid.isEmpty
          ? <dynamic>[]
          : await _db
              .from('review_likes')
              .select('review_id')
              .eq('user_id', currentUserUid)
              .filter('review_id', 'in', '(${ids.join(',')})');
      if (!mounted) return;
      setState(() {
        _reviews = reset ? list : [..._reviews, ...list];
        _liked.addAll([for (final m in mine) '${m['review_id']}']);
        _hasMore = list.length == _pageSize;
        _loading = false;
        _loadingMore = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  Future<void> _loadReplies(String reviewId) async {
    if (_repliesLoading.contains(reviewId)) return;
    setState(() => _repliesLoading.add(reviewId));
    try {
      final rows = await _db
          .from('review_replies')
          .select('*, users(first_name, last_name, avatar_url)')
          .eq('review_id', reviewId)
          .order('created_at', ascending: true);
      final list = List<Map<String, dynamic>>.from(rows as List);
      final ids = list.map((r) => '${r['id']}').toList();
      final mine = ids.isEmpty || currentUserUid.isEmpty
          ? <dynamic>[]
          : await _db
              .from('review_reply_likes')
              .select('reply_id')
              .eq('user_id', currentUserUid)
              .filter('reply_id', 'in', '(${ids.join(',')})');
      if (!mounted) return;
      setState(() {
        _replies[reviewId] = list;
        _likedReplies.addAll([for (final m in mine) '${m['reply_id']}']);
        _repliesLoading.remove(reviewId);
      });
    } catch (_) {
      if (mounted) setState(() => _repliesLoading.remove(reviewId));
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

  Future<void> _toggleLike(Map<String, dynamic> review) async {
    final id = '${review['id']}';
    final was = _liked.contains(id);
    setState(() {
      was ? _liked.remove(id) : _liked.add(id);
      review['like_count'] =
          ((review['like_count'] as num?)?.toInt() ?? 0) + (was ? -1 : 1);
    });
    try {
      final res =
          await _db.rpc('toggle_review_like', params: {'p_review_id': id});
      if (res is Map && res['success'] == true) {
        if (mounted) {
          setState(() {
            res['liked'] == true ? _liked.add(id) : _liked.remove(id);
            review['like_count'] =
                (res['like_count'] as num?)?.toInt() ?? review['like_count'];
          });
        }
      } else {
        throw '${res is Map ? res['message'] : 'failed'}';
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        was ? _liked.add(id) : _liked.remove(id);
        review['like_count'] =
            ((review['like_count'] as num?)?.toInt() ?? 0) + (was ? 1 : -1);
      });
      _toast('Could not update your like.', error: true);
    }
  }

  Future<void> _toggleReplyLike(Map<String, dynamic> reply) async {
    final id = '${reply['id']}';
    final was = _likedReplies.contains(id);
    setState(() {
      was ? _likedReplies.remove(id) : _likedReplies.add(id);
      reply['like_count'] =
          ((reply['like_count'] as num?)?.toInt() ?? 0) + (was ? -1 : 1);
    });
    try {
      final res =
          await _db.rpc('toggle_review_reply_like', params: {'p_reply_id': id});
      if (res is Map && res['success'] == true) {
        if (mounted) {
          setState(() {
            res['liked'] == true
                ? _likedReplies.add(id)
                : _likedReplies.remove(id);
            reply['like_count'] =
                (res['like_count'] as num?)?.toInt() ?? reply['like_count'];
          });
        }
      } else {
        throw 'failed';
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        was ? _likedReplies.add(id) : _likedReplies.remove(id);
        reply['like_count'] =
            ((reply['like_count'] as num?)?.toInt() ?? 0) + (was ? 1 : -1);
      });
      _toast('Could not update your like.', error: true);
    }
  }

  void _toggleThread(Map<String, dynamic> review) {
    final id = '${review['id']}';
    setState(() {
      if (_open.contains(id)) {
        _open.remove(id);
      } else {
        _open.add(id);
      }
    });
    if (_open.contains(id) && !_replies.containsKey(id)) _loadReplies(id);
  }

  Future<void> _sendReply(Map<String, dynamic> review) async {
    final id = '${review['id']}';
    final ctrl = _composers[id];
    final text = (ctrl?.text ?? '').trim();
    if (text.isEmpty || _posting.contains(id)) return;
    final parent = _replyingTo[id];
    setState(() => _posting.add(id));
    try {
      final res = await _db.rpc('add_review_reply', params: {
        'p_review_id': id,
        'p_body': text,
        if (parent != null) 'p_parent_id': parent['id'],
      });
      if (res is Map && res['success'] == true) {
        ctrl?.clear();
        _replyingTo[id] = null;
        review['reply_count'] =
            ((review['reply_count'] as num?)?.toInt() ?? 0) + 1;
        await _loadReplies(id);
      } else {
        _toast(
            '${res is Map ? (res['message'] ?? 'Could not post your reply.') : 'Could not post your reply.'}',
            error: true);
      }
    } catch (_) {
      _toast('Could not post your reply. Check your connection.', error: true);
    } finally {
      if (mounted) setState(() => _posting.remove(id));
    }
  }

  Future<void> _deleteReply(
      Map<String, dynamic> review, Map<String, dynamic> reply) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this reply?'),
        content: const Text('Replies under it are deleted too.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final res = await _db
          .rpc('delete_review_reply', params: {'p_reply_id': reply['id']});
      if (res is Map && res['success'] == true) {
        final rid = '${review['id']}';
        await _loadReplies(rid);
        final n = _replies[rid]?.length ?? 0;
        if (mounted) setState(() => review['reply_count'] = n);
      } else {
        _toast(
            '${res is Map ? (res['message'] ?? 'Could not delete.') : 'Could not delete.'}',
            error: true);
      }
    } catch (_) {
      _toast('Could not delete. Try again.', error: true);
    }
  }

  Future<void> _sellerResponse(Map<String, dynamic> review) async {
    final ctrl = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Respond as the seller'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          decoration:
              const InputDecoration(hintText: 'Write a public response…'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Post')),
        ],
      ),
    );
    ctrl.dispose();
    if (text == null || text.isEmpty) return;
    try {
      final res = await _db.rpc('reply_to_review',
          params: {'p_review_id': review['id'], 'p_reply': text});
      if (res is Map && res['success'] == true) {
        if (mounted) setState(() => review['vendor_reply'] = text);
      } else {
        _toast(
            '${res is Map ? (res['message'] ?? 'Could not post your response.') : 'Could not post your response.'}',
            error: true);
      }
    } catch (_) {
      _toast('Could not post your response. Try again.', error: true);
    }
  }

  // ------------------------------------------------------------- helpers

  String _ago(String? raw) {
    final dt = DateTime.tryParse(raw ?? '');
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  String _nameOf(Map<String, dynamic>? user) {
    final first = (user?['first_name'] as String?)?.trim() ?? '';
    final last = (user?['last_name'] as String?)?.trim() ?? '';
    final n = [first, last].where((s) => s.isNotEmpty).join(' ');
    return n.isEmpty ? 'Anonymous' : n;
  }

  Widget _avatar(FlutterFlowTheme theme, String? url, double size) => Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: theme.alternate),
        child: (url ?? '').isEmpty
            ? Icon(Icons.person, size: size * 0.55, color: theme.secondaryText)
            : Image.network(url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.person,
                    size: size * 0.55, color: theme.secondaryText)),
      );

  Widget _stars(FlutterFlowTheme theme, num value, {double size = 16}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              value >= i - 0.25
                  ? Icons.star_rounded
                  : (value >= i - 0.75
                      ? Icons.star_half_rounded
                      : Icons.star_border_rounded),
              size: size,
              color: theme.secondary,
            ),
        ],
      );

  // ------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final total =
        (_summary?['total_reviews'] as num?)?.toInt() ?? _ratings.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (total > 0) _breakdown(theme, total),
        if (total > 0) const SizedBox(height: 14),
        if (total > 0) _filters(theme),
        if (total > 0) const SizedBox(height: 12),
        if (_reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(
              children: [
                Icon(Icons.rate_review_outlined,
                    size: 38, color: theme.secondaryText),
                const SizedBox(height: 8),
                Text(
                  total == 0
                      ? 'No reviews yet.'
                      : 'No reviews with that rating.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 13.5),
                ),
                if (total == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                        _agentStore
                            ? 'Students can review after an inspection.'
                            : 'Buyers can review once an order is completed.',
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 12)),
                  ),
              ],
            ),
          ),
        for (final r in _reviews) ...[
          _reviewCard(theme, r),
          const SizedBox(height: 10),
        ],
        if (_hasMore)
          Center(
            child: TextButton(
              onPressed: _loadingMore
                  ? null
                  : () {
                      setState(() => _loadingMore = true);
                      _loadReviews();
                    },
              child: _loadingMore
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Show more reviews',
                      style: TextStyle(
                          color: theme.secondary, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  Widget _breakdown(FlutterFlowTheme theme, int total) {
    final avg = (_summary?['avg_rating'] as num?)?.toDouble() ?? 0;
    final counts = List<int>.filled(6, 0);
    for (final r in _ratings) {
      if (r >= 1 && r <= 5) counts[r]++;
    }
    final base = _ratings.isEmpty ? total : _ratings.length;

    Widget dim(String label, num? v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                  width: 118,
                  child: Text(label,
                      style: TextStyle(
                          color: theme.secondaryText, fontSize: 12.5))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ((v ?? 0) / 5).clamp(0, 1).toDouble(),
                    minHeight: 6,
                    backgroundColor: theme.alternate,
                    valueColor: AlwaysStoppedAnimation(theme.secondary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 28,
                child: Text((v ?? 0).toStringAsFixed(1),
                    textAlign: TextAlign.right,
                    style: TextStyle(color: theme.primaryText, fontSize: 12.5)),
              ),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(avg.toStringAsFixed(1),
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          height: 1.05)),
                  const SizedBox(height: 4),
                  _stars(theme, avg, size: 15),
                  const SizedBox(height: 4),
                  Text('$total review${total == 1 ? '' : 's'}',
                      style: TextStyle(
                          color: theme.secondaryText, fontSize: 11.5)),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    for (var s = 5; s >= 1; s--)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 12,
                                child: Text('$s',
                                    style: TextStyle(
                                        color: theme.secondaryText,
                                        fontSize: 11.5))),
                            Icon(Icons.star_rounded,
                                size: 11, color: theme.secondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: base == 0 ? 0 : counts[s] / base,
                                  minHeight: 5,
                                  backgroundColor: theme.alternate,
                                  valueColor:
                                      AlwaysStoppedAnimation(theme.secondary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 22,
                              child: Text('${counts[s]}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: theme.secondaryText,
                                      fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 26, color: theme.alternate),
          Text(_agentStore ? 'What students rated' : 'What buyers rated',
              style: TextStyle(
                  color: theme.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          dim(_agentStore ? 'Room matched listing' : 'Product accuracy',
              _summary?['avg_product_accuracy'] as num?),
          dim('Communication', _summary?['avg_communication'] as num?),
          dim(_agentStore ? 'On time' : 'Packaging',
              _summary?['avg_packaging'] as num?),
          dim('Value for money', _summary?['avg_value_for_money'] as num?),
        ],
      ),
    );
  }

  Widget _filters(FlutterFlowTheme theme) {
    Widget chip(String label, int? value) {
      final active = _filter == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          showCheckmark: false,
          selectedColor: theme.secondary,
          backgroundColor: theme.secondaryBackground,
          side: BorderSide(color: active ? theme.secondary : theme.alternate),
          labelStyle: TextStyle(
              color: active ? Colors.white : theme.primaryText,
              fontSize: 12.5,
              fontWeight: FontWeight.w600),
          onSelected: (_) {
            if (_filter == value) return;
            setState(() {
              _filter = value;
              _loading = true;
            });
            _loadReviews(reset: true);
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip('All', null),
          for (var s = 5; s >= 1; s--) chip('$s ★', s),
        ],
      ),
    );
  }

  Widget _reviewCard(FlutterFlowTheme theme, Map<String, dynamic> r) {
    final id = '${r['id']}';
    final user = r['users'] as Map<String, dynamic>?;
    final liked = _liked.contains(id);
    final likes = (r['like_count'] as num?)?.toInt() ?? 0;
    final replyCount = (r['reply_count'] as num?)?.toInt() ?? 0;
    final open = _open.contains(id);
    final vendorReply = (r['vendor_reply'] as String?) ?? '';

    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _avatar(theme, user?['avatar_url'] as String?, 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(_nameOf(user),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: theme.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Text(_ago(r['created_at'] as String?),
                            style: TextStyle(
                                color: theme.secondaryText, fontSize: 11)),
                      ],
                    ),
                    if (((user?['oja_tier'] as num?) ?? 0) >= 2 &&
                        '${user?['oja_tier_title'] ?? ''}'.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text('${user?['oja_tier_title']}',
                            style: TextStyle(
                                color: theme.secondary,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _stars(theme, (r['overall_rating'] as num?) ?? 0),
                        if (r['order_id'] != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.verified_outlined,
                              size: 13, color: theme.secondaryText),
                          const SizedBox(width: 3),
                          Text('Verified order',
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 11)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (((r['comment'] as String?) ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('${r['comment']}',
                style: TextStyle(
                    color: theme.primaryText, fontSize: 13, height: 1.4)),
          ],
          if (vendorReply.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border(left: BorderSide(color: theme.secondary, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller response',
                      style: TextStyle(
                          color: theme.secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(vendorReply,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12.5,
                          height: 1.35)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _toggleLike(r),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(liked ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: liked ? theme.error : theme.secondaryText),
                      const SizedBox(width: 4),
                      Text(likes > 0 ? '$likes' : 'Like',
                          style: TextStyle(
                              color: liked ? theme.error : theme.secondaryText,
                              fontSize: 12.5)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _toggleThread(r),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          size: 17,
                          color: open ? theme.secondary : theme.secondaryText),
                      const SizedBox(width: 4),
                      Text(
                          replyCount > 0
                              ? '$replyCount ${replyCount == 1 ? 'reply' : 'replies'}'
                              : 'Reply',
                          style: TextStyle(
                              color:
                                  open ? theme.secondary : theme.secondaryText,
                              fontSize: 12.5)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (_isOwner && vendorReply.isEmpty)
                TextButton(
                  onPressed: () => _sellerResponse(r),
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('Respond as seller',
                      style: TextStyle(
                          color: theme.secondary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          if (open) _thread(theme, r),
        ],
      ),
    );
  }

  Widget _thread(FlutterFlowTheme theme, Map<String, dynamic> review) {
    final id = '${review['id']}';
    final replies = _replies[id];
    final ctrl = _composers.putIfAbsent(id, () => TextEditingController());
    final target = _replyingTo[id];

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.alternate))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replies == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                  child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else if (replies.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text('No replies yet. Be the first.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 12)),
            )
          else
            for (final rep in replies) _replyRow(theme, review, rep),
          const SizedBox(height: 8),
          if (target != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        'Replying to ${_nameOf(target['users'] as Map<String, dynamic>?)}',
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11.5)),
                  ),
                  InkWell(
                    onTap: () => setState(() => _replyingTo[id] = null),
                    child: Icon(Icons.close_rounded,
                        size: 16, color: theme.secondaryText),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: ctrl,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 1000,
                  buildCounter: (_,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  style: TextStyle(color: theme.primaryText, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Write a reply…',
                    hintStyle:
                        TextStyle(color: theme.secondaryText, fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: theme.primaryBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: theme.alternate)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: theme.alternate)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _posting.contains(id)
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)))
                  : IconButton(
                      onPressed: () => _sendReply(review),
                      icon: Icon(Icons.send_rounded, color: theme.secondary),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _replyRow(FlutterFlowTheme theme, Map<String, dynamic> review,
      Map<String, dynamic> rep) {
    final id = '${rep['id']}';
    final user = rep['users'] as Map<String, dynamic>?;
    final liked = _likedReplies.contains(id);
    final likes = (rep['like_count'] as num?)?.toInt() ?? 0;
    final mine = rep['user_id'] == currentUserUid;
    final byOwner =
        (widget.ownerId ?? '').isNotEmpty && rep['user_id'] == widget.ownerId;
    final reviewId = '${review['id']}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _avatar(theme, user?['avatar_url'] as String?, 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(_nameOf(user),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600)),
                    ),
                    if (byOwner) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                            color: theme.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('Seller',
                            style: TextStyle(
                                color: theme.secondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                    const SizedBox(width: 6),
                    Text(_ago(rep['created_at'] as String?),
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 10.5)),
                  ],
                ),
                const SizedBox(height: 2),
                Text('${rep['body']}',
                    style: TextStyle(
                        color: theme.primaryText,
                        fontSize: 12.5,
                        height: 1.35)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    InkWell(
                      onTap: () => _toggleReplyLike(rep),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(liked ? Icons.favorite : Icons.favorite_border,
                                size: 14,
                                color:
                                    liked ? theme.error : theme.secondaryText),
                            const SizedBox(width: 3),
                            Text(likes > 0 ? '$likes' : 'Like',
                                style: TextStyle(
                                    color: liked
                                        ? theme.error
                                        : theme.secondaryText,
                                    fontSize: 11.5)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        setState(() => _replyingTo[reviewId] = rep);
                        final c = _composers[reviewId];
                        final n = _nameOf(user);
                        if (c != null && c.text.isEmpty) {
                          c.text = '@$n ';
                          c.selection =
                              TextSelection.collapsed(offset: c.text.length);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 2),
                        child: Text('Reply',
                            style: TextStyle(
                                color: theme.secondaryText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    if (mine || _isOwner) ...[
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () => _deleteReply(review, rep),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 2),
                          child: Text('Delete',
                              style: TextStyle(
                                  color: theme.secondaryText, fontSize: 11.5)),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
