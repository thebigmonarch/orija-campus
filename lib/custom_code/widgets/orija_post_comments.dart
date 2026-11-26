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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:go_router/go_router.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Comment thread for one post, shown in a bottom sheet from Explore.
/// Reads comment_view (author, vendor badge, parent snippet, attached
/// listing) and writes through the real send_comment RPC, so notifications
/// and counts stay server-side. Supports: like a comment, reply to a
/// comment, reply to someone's reply (shown flattened under the top-level
/// comment with "Replying to <name>"), and attaching a listing.
class OrijaPostComments extends StatefulWidget {
  const OrijaPostComments({
    super.key,
    this.width,
    this.height,
    required this.postId,
    this.postAuthorId,
    this.embedded = false,
    this.header,
    this.focusSignal,
  });

  final double? width;
  final double? height;
  final String? postId;
  final String? postAuthorId;

  /// Inline mode (View Post page): no sheet chrome; [header] is the first
  /// item of the scrolling list and [focusSignal] focuses the composer.
  final bool embedded;
  final Widget? header;
  final ValueNotifier<int>? focusSignal;

  @override
  State<OrijaPostComments> createState() => _OrijaPostCommentsState();
}

class _OrijaPostCommentsState extends State<OrijaPostComments> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _loading = true;
  bool _sending = false;
  List<Map<String, dynamic>> _comments = [];
  final Set<String> _likedIds = {};
  Map<String, dynamic>? _replyTo;
  Map<String, dynamic>? _attached;

  @override
  void initState() {
    super.initState();
    widget.focusSignal?.addListener(_focusComposer);
    _load();
  }

  void _focusComposer() {
    if (mounted) _focus.requestFocus();
  }

  @override
  void dispose() {
    widget.focusSignal?.removeListener(_focusComposer);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final postId = widget.postId;
    if (postId == null || postId.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    try {
      final supabase = Supabase.instance.client;
      final rows = await supabase
          .from('comment_view')
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: true);
      final list = List<Map<String, dynamic>>.from(rows as List);
      final ids = list.map((c) => c['comment_id'] as String).toList();
      final liked = <String>{};
      if (ids.isNotEmpty) {
        final likes = await supabase
            .from('comment_likes')
            .select('comment_id')
            .eq('user_id', currentUserUid)
            .inFilter('comment_id', ids);
        liked.addAll(List<Map<String, dynamic>>.from(likes as List)
            .map((r) => r['comment_id'] as String));
      }
      if (!mounted) return;
      setState(() {
        _comments = list;
        _likedIds
          ..clear()
          ..addAll(liked);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _name(Map<String, dynamic> c, {String prefix = 'author'}) {
    final n = [c['${prefix}_first_name'], c['${prefix}_last_name']]
        .where((e) => e != null && (e as String).isNotEmpty)
        .join(' ');
    return n.isEmpty ? 'Someone' : n;
  }

  String _timeAgo(String? iso) {
    final t = DateTime.tryParse(iso ?? '')?.toLocal();
    if (t == null) return '';
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${(d.inDays / 7).floor()}w';
  }

  String _naira(num? v) {
    final s = (v ?? 0).round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  /// Top-level comments (newest first), each followed by every descendant
  /// (oldest first). A reply to a reply is flattened under its top-level
  /// ancestor so threads never nest unboundedly; the "Replying to" line
  /// keeps the context.
  List<Map<String, dynamic>> _ordered() {
    final byId = {for (final c in _comments) c['comment_id'] as String: c};
    String rootOf(Map<String, dynamic> c) {
      var cur = c;
      var guard = 0;
      while (cur['parent_id'] != null &&
          byId.containsKey(cur['parent_id']) &&
          guard++ < 50) {
        cur = byId[cur['parent_id']]!;
      }
      return cur['comment_id'] as String;
    }

    final roots = _comments.where((c) => c['parent_id'] == null).toList()
      ..sort((a, b) =>
          (b['created_at'] as String).compareTo(a['created_at'] as String));
    final children = <String, List<Map<String, dynamic>>>{};
    for (final c in _comments) {
      if (c['parent_id'] == null) continue;
      children.putIfAbsent(rootOf(c), () => []).add(c);
    }
    final out = <Map<String, dynamic>>[];
    for (final r in roots) {
      out.add(r);
      out.addAll(children[r['comment_id']] ?? const []);
    }
    for (final c in _comments) {
      if (c['parent_id'] != null &&
          !byId.containsKey(c['parent_id']) &&
          !out.contains(c)) {
        out.add(c);
      }
    }
    return out;
  }

  Future<void> _toggleLike(Map<String, dynamic> c) async {
    final id = c['comment_id'] as String;
    final wasLiked = _likedIds.contains(id);
    setState(() {
      if (wasLiked) {
        _likedIds.remove(id);
        c['like_count'] = ((c['like_count'] as int?) ?? 1) - 1;
      } else {
        _likedIds.add(id);
        c['like_count'] = ((c['like_count'] as int?) ?? 0) + 1;
      }
    });
    try {
      final supabase = Supabase.instance.client;
      if (wasLiked) {
        await supabase
            .from('comment_likes')
            .delete()
            .match({'comment_id': id, 'user_id': currentUserUid});
      } else {
        await supabase
            .from('comment_likes')
            .insert({'comment_id': id, 'user_id': currentUserUid});
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (wasLiked) {
          _likedIds.add(id);
          c['like_count'] = ((c['like_count'] as int?) ?? 0) + 1;
        } else {
          _likedIds.remove(id);
          c['like_count'] = ((c['like_count'] as int?) ?? 1) - 1;
        }
      });
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if ((text.isEmpty && _attached == null) || _sending) return;
    setState(() => _sending = true);
    try {
      final res = await Supabase.instance.client.rpc('send_comment', params: {
        'p_author_id': currentUserUid,
        'p_post_id': widget.postId,
        'p_content': text,
        if (_replyTo != null) 'p_parent_id': _replyTo!['comment_id'],
        if (_attached != null) 'p_listing_id': _attached!['id'],
      });
      final ok = res is Map && res['success'] == true;
      if (!mounted) return;
      if (!ok) {
        final msg = (res is Map ? (res['message'] ?? res['error']) : null) ??
            'Could not post comment';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$msg')));
        setState(() => _sending = false);
        return;
      }
      _controller.clear();
      setState(() {
        _replyTo = null;
        _attached = null;
        _sending = false;
      });
      await _load();
    } catch (_) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not post comment')));
    }
  }

  void _copyComment(Map<String, dynamic> c) {
    final text = (c['content'] as String?) ?? '';
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(
          content: Text('Copied'), duration: Duration(seconds: 2)));
  }

  Future<void> _deleteComment(Map<String, dynamic> c) async {
    final id = c['comment_id'] as String;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this comment?'),
        content: const Text('This can\'t be undone.'),
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
      final res = await Supabase.instance.client
          .rpc('delete_comment', params: {'p_comment_id': id});
      final success = res is Map && res['success'] == true;
      if (!mounted) return;
      if (success) {
        setState(() => _comments.removeWhere((x) => x['comment_id'] == id));
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
            content: Text(success
                ? 'Comment deleted'
                : '${res is Map ? (res['message'] ?? 'Could not delete.') : 'Could not delete.'}'),
            duration: const Duration(seconds: 2)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(
            content: Text('Could not delete. Try again.'),
            duration: Duration(seconds: 2)));
    }
  }

  void _commentMenu(Map<String, dynamic> c) {
    final mine = c['author_id'] == currentUserUid;
    final theme = FlutterFlowTheme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.secondaryBackground,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (((c['content'] as String?) ?? '').isNotEmpty)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(ctx);
                  _copyComment(c);
                },
              ),
            if (mine)
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: theme.error),
                title: Text('Delete', style: TextStyle(color: theme.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _deleteComment(c);
                },
              ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Future<void> _pickListing() async {
    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ListingPicker(),
    );
    if (picked != null && mounted) setState(() => _attached = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final items = _ordered();
    if (widget.embedded) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              itemCount: (_loading || items.isEmpty) ? 3 : items.length + 2,
              itemBuilder: (context, i) {
                if (i == 0) return widget.header ?? const SizedBox.shrink();
                if (i == 1) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                    child: Text(
                        _loading
                            ? 'Comments'
                            : 'Comments (${_comments.length})',
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  );
                }
                if (_loading)
                  return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                          child:
                              CircularProgressIndicator(color: theme.primary)));
                if (items.isEmpty)
                  return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                          child: Text(
                              'No comments yet. Start the conversation.',
                              style: TextStyle(color: theme.secondaryText))));
                final tile = items[i - 2];
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _commentTile(tile, theme));
              },
            ),
          ),
          _composer(theme),
        ],
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
                color: theme.alternate, borderRadius: BorderRadius.circular(4)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text('Comments (${_comments.length})',
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: theme.secondaryText),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.alternate),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: theme.primary))
                : items.isEmpty
                    ? Center(
                        child: Text('No comments yet. Start the conversation.',
                            style: TextStyle(color: theme.secondaryText)))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: items.length,
                        itemBuilder: (context, i) =>
                            _commentTile(items[i], theme),
                      ),
          ),
          _composer(theme),
        ],
      ),
    );
  }

  Widget _commentTile(Map<String, dynamic> c, FlutterFlowTheme theme) {
    final id = c['comment_id'] as String;
    final isReply = c['parent_id'] != null;
    final liked = _likedIds.contains(id);
    final avatar = c['author_avatar'] as String? ?? '';
    final isVendor = c['author_is_vendor'] == true;
    final isPostAuthor = c['author_id'] == widget.postAuthorId;
    final content = c['content'] as String? ?? '';
    final byId = {for (final x in _comments) x['comment_id'] as String: x};
    final parent = byId[c['parent_id']];
    final replyingToRoot =
        parent != null && parent['parent_id'] == null && isReply;
    return GestureDetector(
      onLongPress: () => _commentMenu(c),
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.only(left: isReply ? 40 : 0, top: 10, bottom: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isReply ? 13 : 16,
              backgroundColor: theme.alternate,
              backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
              child: avatar.isEmpty
                  ? Icon(Icons.person, size: 14, color: theme.secondaryText)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(_name(c),
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700)),
                      if (isPostAuthor) _chip('Author', theme.primary, theme),
                      if (isVendor)
                        _chip(
                            (c['author_storefront_name'] as String?) ??
                                'Vendor',
                            theme.secondary,
                            theme),
                      if (((c['author_oja_tier'] as num?) ?? 0) >= 2 &&
                          '${c['author_oja_tier_title'] ?? ''}'.isNotEmpty)
                        _chip('${c['author_oja_tier_title']}', theme.secondary,
                            theme),
                      Text(_timeAgo(c['created_at'] as String?),
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 11)),
                    ],
                  ),
                  if (isReply && !replyingToRoot && parent != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                          'Replying to ${_name(c, prefix: 'parent_author')}',
                          style: TextStyle(
                              color: theme.secondaryText,
                              fontSize: 11,
                              fontStyle: FontStyle.italic)),
                    ),
                  if (content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(content,
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 13,
                              height: 1.3)),
                    ),
                  if (c['listing_id'] != null) _listingCard(c, theme),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _toggleLike(c),
                        child: Row(
                          children: [
                            Icon(liked ? Icons.favorite : Icons.favorite_border,
                                size: 15,
                                color:
                                    liked ? theme.error : theme.secondaryText),
                            const SizedBox(width: 4),
                            Text('${c['like_count'] ?? 0}',
                                style: TextStyle(
                                    color: theme.secondaryText,
                                    fontSize: 11.5)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      InkWell(
                        onTap: () {
                          setState(() => _replyTo = c);
                          _focus.requestFocus();
                        },
                        child: Text('Reply',
                            style: TextStyle(
                                color: theme.secondaryText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color, FlutterFlowTheme theme) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10)),
        child: Text(label,
            maxLines: 1,
            style: TextStyle(
                color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
      );

  Widget _listingCard(Map<String, dynamic> c, FlutterFlowTheme theme) {
    final img = c['listing_image'] as String? ?? '';
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.pushNamed('listingdetailPage',
          queryParameters: {'listingId': '${c['listing_id']}'}),
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.alternate),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48,
                height: 48,
                color: theme.alternate,
                child: img.isEmpty
                    ? Icon(Icons.image_outlined, color: theme.secondaryText)
                    : Image.network(img, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['listing_title'] as String? ?? 'Listing',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  Text(_naira(c['listing_price'] as num?),
                      style: TextStyle(
                          color: theme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }

  Widget _composer(FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(top: BorderSide(color: theme.alternate)),
      ),
      padding: EdgeInsets.fromLTRB(
          12, 8, 12, 8 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_replyTo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Replying to ${_name(_replyTo!)}',
                        style: TextStyle(
                            color: theme.secondaryText, fontSize: 11.5)),
                  ),
                  InkWell(
                    onTap: () => setState(() => _replyTo = null),
                    child:
                        Icon(Icons.close, size: 16, color: theme.secondaryText),
                  ),
                ],
              ),
            ),
          if (_attached != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 34,
                      height: 34,
                      color: theme.alternate,
                      child:
                          ((_attached!['primary_image_url'] as String?) ?? '')
                                  .isEmpty
                              ? Icon(Icons.image_outlined,
                                  size: 16, color: theme.secondaryText)
                              : Image.network(
                                  _attached!['primary_image_url'] as String,
                                  fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_attached!['title'] as String? ?? 'Listing',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: theme.primaryText, fontSize: 12)),
                  ),
                  InkWell(
                    onTap: () => setState(() => _attached = null),
                    child:
                        Icon(Icons.close, size: 16, color: theme.secondaryText),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                tooltip: 'Attach a listing',
                icon: Icon(Icons.add_shopping_cart_rounded,
                    color:
                        _attached != null ? theme.primary : theme.secondaryText,
                    size: 22),
                onPressed: _pickListing,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: theme.primaryText, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: _replyTo != null
                        ? 'Write a reply...'
                        : 'Add a comment...',
                    hintStyle:
                        TextStyle(color: theme.secondaryText, fontSize: 13),
                    filled: true,
                    fillColor: theme.primaryBackground,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _sending
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : IconButton(
                      icon: Icon(Icons.send_rounded, color: theme.primary),
                      onPressed: _send,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Picks a listing to attach to a comment: your own listings (if you have a
/// storefront) or any available listing, with title search.
class _ListingPicker extends StatefulWidget {
  const _ListingPicker();

  @override
  State<_ListingPicker> createState() => _ListingPickerState();
}

class _ListingPickerState extends State<_ListingPicker> {
  final TextEditingController _search = TextEditingController();
  bool _loading = true;
  bool _mine = false;
  List<String> _myStoreIds = [];
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      final stores = await Supabase.instance.client
          .from('storefronts')
          .select('id')
          .eq('owner_id', currentUserUid)
          .eq('is_active', true);
      _myStoreIds = List<Map<String, dynamic>>.from(stores as List)
          .map((s) => s['id'] as String)
          .toList();
      _mine = _myStoreIds.isNotEmpty;
    } catch (_) {}
    await _query();
  }

  Future<void> _query() async {
    setState(() => _loading = true);
    try {
      var q = Supabase.instance.client
          .from('listings')
          .select('id, title, price, primary_image_url')
          .eq('is_available', true);
      if (_mine && _myStoreIds.isNotEmpty) {
        q = q.inFilter('storefront_id', _myStoreIds);
      }
      final term = _search.text.trim();
      if (term.isNotEmpty) q = q.ilike('title', '%$term%');
      final rows = await q.order('created_at', ascending: false).limit(30);
      if (!mounted) return;
      setState(() {
        _items = List<Map<String, dynamic>>.from(rows as List);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _naira(num? v) {
    final s = (v ?? 0).round().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₦$buf';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text('Attach a listing',
                style: TextStyle(
                    color: theme.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: TextField(
                controller: _search,
                onSubmitted: (_) => _query(),
                textInputAction: TextInputAction.search,
                style: TextStyle(color: theme.primaryText, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search listings',
                  hintStyle: TextStyle(color: theme.secondaryText),
                  prefixIcon: Icon(Icons.search, color: theme.secondaryText),
                  filled: true,
                  fillColor: theme.secondaryBackground,
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            if (_myStoreIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('My listings'),
                      selected: _mine,
                      onSelected: (_) {
                        setState(() => _mine = true);
                        _query();
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('All listings'),
                      selected: !_mine,
                      onSelected: (_) {
                        setState(() => _mine = false);
                        _query();
                      },
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(color: theme.primary))
                  : _items.isEmpty
                      ? Center(
                          child: Text('No listings found.',
                              style: TextStyle(color: theme.secondaryText)))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: theme.alternate),
                          itemBuilder: (context, i) {
                            final l = _items[i];
                            final img = l['primary_image_url'] as String? ?? '';
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () => Navigator.of(context).pop(l),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  color: theme.alternate,
                                  child: img.isEmpty
                                      ? Icon(Icons.image_outlined,
                                          color: theme.secondaryText)
                                      : Image.network(img, fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(l['title'] as String? ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: theme.primaryText, fontSize: 13)),
                              subtitle: Text(_naira(l['price'] as num?),
                                  style: TextStyle(
                                      color: theme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
