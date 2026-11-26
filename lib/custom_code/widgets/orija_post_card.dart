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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/custom_icons.dart';
import 'package:video_player/video_player.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/report_bottom_sheet_widget.dart';
import '/custom_code/widgets/orija_post_comments.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Lets pages tell each other that posts changed (created, deleted) so lists
/// refresh without threading callbacks through the router.
class OrijaPostEvents {
  static final ValueNotifier<int> changed = ValueNotifier<int>(0);
  static void notifyChanged() => changed.value++;
}

/// The one post card used across the app (Explore, My Posts, View Post).
/// It renders a feed_view row and owns every interaction on it: like, comment
/// (opens the OrijaPostComments sheet, or calls [onCommentsTap] on the
/// detail page where comments are inline), repost/recommend, share, save,
/// follow the store, and a more-menu (hide / hide this user / report for
/// other people's posts, edit / delete for your own). Ask posts render as
/// questions with a single "Reply via DM" action.
///
/// Give it either the row ([post], with optional preloaded like/save/repost
/// flags so a list can batch them) or just a [postId] and it loads the row
/// and the viewer's state itself.
class OrijaPostCard extends StatefulWidget {
  const OrijaPostCard({
    super.key,
    this.width,
    this.height,
    this.postId,
    this.post,
    this.initialLiked,
    this.initialSaved,
    this.initialRecommended,
    this.detail = false,
    this.onHidden,
    this.onDeleted,
    this.onCommentsTap,
  });

  final double? width;
  final double? height;
  final String? postId;
  final Map<String, dynamic>? post;
  final bool? initialLiked;
  final bool? initialSaved;
  final bool? initialRecommended;
  final bool detail;
  final void Function(Map<String, dynamic> post)? onHidden;
  final void Function(Map<String, dynamic> post)? onDeleted;
  final VoidCallback? onCommentsTap;

  @override
  State<OrijaPostCard> createState() => _OrijaPostCardState();
}

class _OrijaPostCardState extends State<OrijaPostCard> {
  Map<String, dynamic>? _post;
  bool _loading = true;
  bool _gone = false;
  bool _liked = false;
  bool _saved = false;
  bool _recommended = false;
  bool _following = false;

  SupabaseClient get _db => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    var post =
        widget.post == null ? null : Map<String, dynamic>.from(widget.post!);
    try {
      if (post == null && widget.postId != null) {
        final row = await _db
            .from('feed_view')
            .select()
            .eq('post_id', widget.postId!)
            .maybeSingle();
        post = row == null ? null : Map<String, dynamic>.from(row);
      }
      if (post != null) {
        final id = post['post_id'] as String;
        Future<bool> has(String table) async {
          final r = await _db
              .from(table)
              .select('post_id')
              .eq('post_id', id)
              .eq('user_id', currentUserUid)
              .limit(1);
          return (r as List).isNotEmpty;
        }

        _liked = widget.initialLiked ?? await has('post_likes');
        _saved = widget.initialSaved ?? await has('post_saves');
        _recommended =
            widget.initialRecommended ?? await has('post_recommends');
        final storeId = post['storefront_id'] as String?;
        if (widget.detail && storeId != null) {
          final f = await _db
              .from('follows')
              .select('storefront_id')
              .eq('follower_id', currentUserUid)
              .eq('storefront_id', storeId)
              .limit(1);
          _following = (f as List).isNotEmpty;
        }
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _post = post;
      _loading = false;
    });
  }

  // ------------------------------------------------------------- helpers

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

  String _titleCase(String s) => s
      .replaceAll(RegExp(r'[-_]+'), ' ')
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  Widget _thumb(String? url, FlutterFlowTheme theme, {double size = 100}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: theme.alternate,
        child: (url ?? '').isEmpty
            ? Icon(Icons.image_outlined, color: theme.secondaryText)
            : Image.network(url!, fit: BoxFit.cover),
      ),
    );
  }

  bool get _isMine => _post?['author_id'] == currentUserUid;

  // ---------------------------------------------------------- interactions

  /// The post's own page (ViewPost) -- what a shared link points to, and
  /// where a signed-out visitor should land after they finish signing up.
  String get _postRoutePath {
    final p = _post!;
    final id = Uri.encodeQueryComponent('${p['post_id']}');
    final type = Uri.encodeQueryComponent('${p['post_type'] ?? ''}');
    final store = Uri.encodeQueryComponent('${p['storefront_id'] ?? ''}');
    return '/viewPost?postID=$id&postType=$type&storeID=$store';
  }

  // Short link: opens in the right app with a proper preview (campus.orija.app/go).
  String get _postLink =>
      'https://campus.orija.app/go/p/${Uri.encodeComponent('${_post?['post_id'] ?? ''}')}';

  /// Gates an action that needs an account. If the viewer is signed out,
  /// remembers this post's own page so the auth flow can send them back
  /// there instead of Home once they're signed in, then routes them into
  /// sign up. Returns true only when the caller may proceed now.
  Future<bool> _requireAuth() async {
    if (currentUserUid.isNotEmpty) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('orija_pending_redirect', _postRoutePath);
    } catch (_) {}
    if (!mounted) return false;
    context.pushNamed('signuppage',
        queryParameters: {
          'isSignUp': serializeParam(true, ParamType.bool),
        }.withoutNulls);
    return false;
  }

  Future<void> _toggleLike() async {
    if (!await _requireAuth()) return;
    final p = _post!;
    final id = p['post_id'] as String;
    final was = _liked;
    setState(() {
      _liked = !was;
      p['like_count'] =
          ((p['like_count'] as int?) ?? (was ? 1 : 0)) + (was ? -1 : 1);
    });
    try {
      if (was) {
        await _db
            .from('post_likes')
            .delete()
            .match({'post_id': id, 'user_id': currentUserUid});
      } else {
        await _db
            .from('post_likes')
            .insert({'post_id': id, 'user_id': currentUserUid});
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _liked = was;
        p['like_count'] = ((p['like_count'] as int?) ?? 0) + (was ? 1 : -1);
      });
    }
  }

  Future<void> _toggleSave() async {
    if (!await _requireAuth()) return;
    final p = _post!;
    final id = p['post_id'] as String;
    final was = _saved;
    setState(() {
      _saved = !was;
      p['save_count'] =
          ((p['save_count'] as int?) ?? (was ? 1 : 0)) + (was ? -1 : 1);
    });
    try {
      if (was) {
        await _db
            .from('post_saves')
            .delete()
            .match({'post_id': id, 'user_id': currentUserUid});
      } else {
        await _db
            .from('post_saves')
            .insert({'post_id': id, 'user_id': currentUserUid});
      }
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      const shownFor = Duration(seconds: 5);
      final controller = messenger.showSnackBar(SnackBar(
        content: Text(was ? 'Removed from Saved' : 'Saved'),
        duration: shownFor,
        action: was
            ? null
            : SnackBarAction(
                label: 'View',
                onPressed: () => context.pushNamed('SavedItems')),
      ));
      Timer(shownFor, () => controller.close());
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saved = was;
        p['save_count'] = ((p['save_count'] as int?) ?? 0) + (was ? 1 : -1);
      });
    }
  }

  /// post_recommends is the app's repost/recommend mechanism (its trigger
  /// keeps recommend_count in sync and awards the author Oja points).
  Future<void> _toggleRecommend() async {
    if (!await _requireAuth()) return;
    final p = _post!;
    final id = p['post_id'] as String;
    final was = _recommended;
    setState(() {
      _recommended = !was;
      p['recommend_count'] =
          ((p['recommend_count'] as int?) ?? (was ? 1 : 0)) + (was ? -1 : 1);
    });
    try {
      if (was) {
        await _db
            .from('post_recommends')
            .delete()
            .match({'post_id': id, 'user_id': currentUserUid});
      } else {
        await _db
            .from('post_recommends')
            .insert({'post_id': id, 'user_id': currentUserUid});
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _recommended = was;
        p['recommend_count'] =
            ((p['recommend_count'] as int?) ?? 0) + (was ? 1 : -1);
      });
    }
  }

  Future<void> _toggleFollow() async {
    final storeId = _post?['storefront_id'] as String?;
    if (storeId == null) return;
    if (!await _requireAuth()) return;
    final was = _following;
    setState(() => _following = !was);
    try {
      if (was) {
        await _db
            .from('follows')
            .delete()
            .match({'follower_id': currentUserUid, 'storefront_id': storeId});
      } else {
        await _db.from('follows').insert({
          'follower_id': currentUserUid,
          'storefront_id': storeId,
          'source': 'post'
        });
      }
    } catch (_) {
      if (mounted) setState(() => _following = was);
    }
  }

  Future<void> _share() async {
    final p = _post!;
    final storeName = p['storefront_name'] as String?;
    final who = (storeName != null && storeName.isNotEmpty)
        ? storeName
        : [p['author_first_name'], p['author_last_name']]
            .where((e) => e != null && (e as String).isNotEmpty)
            .join(' ');
    final content = (p['content'] as String? ?? '').trim();
    final snippet =
        content.length > 200 ? '${content.substring(0, 200)}...' : content;
    final text = snippet.isEmpty
        ? 'Check out this post${who.isEmpty ? '' : ' from $who'} on Orija'
        : '"$snippet"${who.isEmpty ? '' : ' - $who'} on Orija';
    try {
      await Share.share('$text\n\n$_postLink');
      setState(() => p['share_count'] = ((p['share_count'] as int?) ?? 0) + 1);
      await _db.rpc('record_post_share', params: {'p_post_id': p['post_id']});
    } catch (_) {}
  }

  Future<void> _openComments() async {
    if (!await _requireAuth()) return;
    if (widget.onCommentsTap != null) {
      widget.onCommentsTap!();
      return;
    }
    final p = _post!;
    final id = p['post_id'] as String;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.85,
          child: OrijaPostComments(
              postId: id, postAuthorId: p['author_id'] as String?),
        ),
      ),
    );
    try {
      final row = await _db
          .from('posts')
          .select('comment_count')
          .eq('id', id)
          .maybeSingle();
      if (mounted && row != null) {
        setState(() => p['comment_count'] = row['comment_count']);
      }
    } catch (_) {}
  }

  void _openPost() {
    if (widget.detail) return;
    final p = _post!;
    context.pushNamed('viewPost', queryParameters: {
      'postID': '${p['post_id']}',
      'postType': '${p['post_type'] ?? ''}',
      'storeID': '${p['storefront_id'] ?? ''}',
    });
  }

  Future<void> _hide() async {
    final p = _post!;
    final id = p['post_id'] as String;
    setState(() => _gone = true);
    try {
      await _db
          .from('post_hides')
          .upsert({'user_id': currentUserUid, 'post_id': id});
    } catch (_) {
      if (mounted) setState(() => _gone = false);
      return;
    }
    widget.onHidden?.call(p);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: const Text('Post hidden'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            try {
              await _db
                  .from('post_hides')
                  .delete()
                  .match({'user_id': currentUserUid, 'post_id': id});
              if (mounted) setState(() => _gone = false);
            } catch (_) {}
          },
        ),
      ));
  }

  /// Hides every post and listing from this author going forward (feeds and
  /// browse all check user_hides) -- softer than a full block: messaging,
  /// following and visiting their storefront directly still work.
  Future<void> _hideAuthor() async {
    final p = _post!;
    final authorId = p['author_id'] as String?;
    if (authorId == null || authorId.isEmpty) return;
    setState(() => _gone = true);
    try {
      await _db
          .from('user_hides')
          .upsert({'user_id': currentUserUid, 'hidden_user_id': authorId});
    } catch (_) {
      if (mounted) setState(() => _gone = false);
      return;
    }
    widget.onHidden?.call(p);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: const Text('Hidden all posts and listings from this user'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            try {
              await _db.from('user_hides').delete().match(
                  {'user_id': currentUserUid, 'hidden_user_id': authorId});
              if (mounted) setState(() => _gone = false);
            } catch (_) {}
          },
        ),
      ));
  }

  Future<void> _report() async {
    final id = _post?['post_id'] as String?;
    if (id == null) return;
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: ReportBottomSheetWidget(
            title: 'Post', reportType: 'post', targetId: id),
      ),
    );
  }

  Future<void> _edit() async {
    final p = _post!;
    final controller =
        TextEditingController(text: p['content'] as String? ?? '');
    final saved = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit post'),
        content: TextField(
          controller: controller,
          maxLines: 6,
          minLines: 3,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'What\'s happening?'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controller.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
    if (saved == null || saved == (p['content'] as String? ?? '')) return;
    try {
      await _db.from('posts').update({
        'content': saved,
        'updated_at': DateTime.now().toUtc().toIso8601String()
      }).eq('id', p['post_id']);
      if (mounted) setState(() => p['content'] = saved);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save changes')));
    }
  }

  Future<void> _delete() async {
    final p = _post!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this post?'),
        content: const Text(
            'It will be removed for everyone. This can\'t be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('Delete',
                  style: TextStyle(
                      color: FlutterFlowTheme.of(dialogContext).error))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _db
          .from('posts')
          .update({'status': 'deleted'}).eq('id', p['post_id']);
      if (!mounted) return;
      setState(() => _gone = true);
      widget.onDeleted?.call(p);
      OrijaPostEvents.notifyChanged();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not delete the post')));
    }
  }

  Future<void> _replyToAsk() async {
    final p = _post!;
    final stores = await _db
        .from('storefronts')
        .select('id')
        .eq('owner_id', currentUserUid)
        .eq('is_active', true)
        .limit(1);
    if (!mounted) return;
    if ((stores as List).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            const Text('Not a vendor!', style: TextStyle(color: Colors.white)),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ));
      return;
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (sheetContext) => Padding(
        padding: MediaQuery.viewInsetsOf(sheetContext),
        child: OrijaSelectStorefront(
            postID: p['post_id'] as String, userID: '${p['author_id'] ?? ''}'),
      ),
    );
  }

  Future<void> _showMenu() async {
    final theme = FlutterFlowTheme.of(context);
    final isAsk = _post!['post_type'] == 'ask';
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
            if (!isAsk) ...[
              tile(
                  Icons.repeat_rounded,
                  _recommended ? 'Remove repost' : 'Repost / recommend',
                  _toggleRecommend),
              tile(_saved ? Icons.bookmark : Icons.bookmark_border,
                  _saved ? 'Unsave post' : 'Save post', _toggleSave),
              tile(FFIcons.kforward, 'Share', _share),
              if ((_post!['content'] as String? ?? '').isNotEmpty)
                tile(Icons.copy_rounded, 'Copy text', () async {
                  await Clipboard.setData(
                      ClipboardData(text: _post!['content'] as String));
                  if (!mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Copied')));
                }),
            ],
            if (_isMine) ...[
              if (!isAsk) tile(Icons.edit_outlined, 'Edit post', _edit),
              tile(Icons.delete_outline_rounded, 'Delete post', _delete,
                  color: theme.error),
            ] else ...[
              tile(Icons.visibility_off_outlined, 'Hide this post', _hide),
              tile(Icons.person_off_outlined, 'Hide all from this user',
                  _hideAuthor),
              tile(Icons.flag_outlined, 'Report post', _report,
                  color: theme.error),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------- UI

  List<Map<String, dynamic>> _products() {
    final out = <Map<String, dynamic>>[];
    final seen = <String>{};
    final linked = _post!['linked_listing'];
    if (linked is Map && linked['id'] != null) {
      out.add(Map<String, dynamic>.from(linked));
      seen.add('${linked['id']}');
    }
    final more = _post!['storefront_listings'];
    if (more is List) {
      for (final l in more) {
        if (l is Map && l['id'] != null && l['is_available'] != false) {
          if (seen.add('${l['id']}')) out.add(Map<String, dynamic>.from(l));
        }
      }
    }
    return out.take(10).toList();
  }

  Widget _productRow(FlutterFlowTheme theme) {
    final products = _products();
    if (products.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 152,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, i) {
            final p = products[i];
            final photos = List<String>.from(p['photos'] as List? ?? []);
            final img = (p['primary_image_url'] as String?)?.isNotEmpty == true
                ? p['primary_image_url'] as String
                : (photos.isNotEmpty ? photos.first : null);
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => context.pushNamed('listingdetailPage',
                  queryParameters: {'listingId': '${p['id']}'}),
              child: SizedBox(
                width: 104,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _thumb(img, theme, size: 104),
                    const SizedBox(height: 5),
                    Text(p['title'] as String? ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryText, fontSize: 11.5)),
                    Text(_naira(p['price'] as num?),
                        style: TextStyle(
                            color: theme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _stat(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback? onTap}) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(color: theme.secondaryText, fontSize: 11.5)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _header(FlutterFlowTheme theme, {bool isAsk = false}) {
    final p = _post!;
    final storeName = p['storefront_name'] as String?;
    final hasStore = !isAsk && storeName != null && storeName.isNotEmpty;
    final person = [p['author_first_name'], p['author_last_name']]
        .where((e) => e != null && (e as String).isNotEmpty)
        .join(' ');
    final title = hasStore ? storeName : (person.isEmpty ? 'Someone' : person);
    final avatar =
        hasStore && (p['storefront_logo'] as String? ?? '').isNotEmpty
            ? p['storefront_logo'] as String
            : (p['author_avatar_url'] as String? ?? '');
    final location = [p['author_city'], p['author_state']]
        .where((e) => e != null && (e as String).isNotEmpty)
        .join(', ');
    final authorTier = (p['author_oja_tier'] as num?)?.toInt() ?? 0;
    final authorTierTitle = p['author_oja_tier_title'] as String?;
    final sub = [
      if (!hasStore && authorTier >= 2 && (authorTierTitle ?? '').isNotEmpty)
        authorTierTitle!,
      if (hasStore && person.isNotEmpty) person,
      if (isAsk && location.isNotEmpty) location,
      _timeAgo(p['created_at'] as String?),
    ].where((e) => e.isNotEmpty).join(' · ');
    final showFollow = widget.detail && hasStore && !_isMine;
    return Row(
      children: [
        InkWell(
          onTap: hasStore && (p['storefront_slug'] as String?) != null
              ? () => context.pushNamed('storefrontPage',
                  queryParameters: {'storefontslug': '${p['storefront_slug']}'})
              : null,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: theme.alternate,
            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
            child: avatar.isEmpty
                ? Icon(Icons.person, size: 15, color: theme.secondaryText)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primaryText,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700)),
                  ),
                  if (!isAsk && p['storefront_verified'] == true) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.verified_rounded,
                        size: 14, color: theme.secondary),
                  ],
                ],
              ),
              if (sub.isNotEmpty)
                Text(sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: theme.secondaryText, fontSize: 10.5)),
            ],
          ),
        ),
        if (showFollow)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: OutlinedButton(
              onPressed: _toggleFollow,
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    _following ? theme.secondaryText : theme.primary,
                side: BorderSide(
                    color: _following ? theme.alternate : theme.primary),
                minimumSize: const Size(0, 30),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(_following ? 'Following' : 'Follow',
                  style: const TextStyle(fontSize: 12)),
            ),
          ),
        if (isAsk)
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: theme.secondary,
                borderRadius: BorderRadius.circular(20)),
            child: const Text('Ask',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _showMenu,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.more_horiz, size: 20, color: theme.secondaryText),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }
    if (_post == null || _gone) return const SizedBox.shrink();
    return _post!['post_type'] == 'ask' ? _askCard(theme) : _postCard(theme);
  }

  Widget _container(FlutterFlowTheme theme, Widget child, {Color? border}) {
    if (widget.detail) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4), child: child);
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border ?? theme.alternate),
      ),
      child: child,
    );
  }

  Widget _postCard(FlutterFlowTheme theme) {
    final p = _post!;
    final media = List<String>.from(p['media_urls'] as List? ?? []);
    final content = p['content'] as String? ?? '';
    return _container(
      theme,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(theme),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: widget.detail ? null : _openPost,
              child: Text(content,
                  maxLines: widget.detail ? null : 3,
                  overflow: widget.detail ? null : TextOverflow.ellipsis,
                  style: TextStyle(
                      color: theme.primaryText,
                      fontSize: widget.detail ? 14.5 : 13,
                      height: 1.35)),
            ),
          ],
          if (media.isNotEmpty) ...[
            const SizedBox(height: 8),
            _MediaCarousel(urls: media, height: widget.detail ? 320 : 200),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              _stat(
                icon: _liked ? Icons.favorite : Icons.favorite_border,
                label: '${p['like_count'] ?? 0}',
                color: _liked ? theme.error : theme.secondaryText,
                onTap: _toggleLike,
              ),
              const SizedBox(width: 12),
              _stat(
                icon: FFIcons.kchat,
                label: '${p['comment_count'] ?? 0}',
                color: theme.secondaryText,
                onTap: _openComments,
              ),
              const SizedBox(width: 12),
              _stat(
                icon: Icons.repeat_rounded,
                label: '${p['recommend_count'] ?? 0}',
                color: _recommended ? theme.secondary : theme.secondaryText,
                onTap: _toggleRecommend,
              ),
              const SizedBox(width: 12),
              _stat(
                icon: FFIcons.kforward,
                label: '${p['share_count'] ?? 0}',
                color: theme.secondaryText,
                onTap: _share,
              ),
              const Spacer(),
              _stat(
                icon: _saved ? Icons.bookmark : Icons.bookmark_border,
                label: '',
                color: _saved ? theme.primary : theme.secondaryText,
                onTap: _toggleSave,
              ),
            ],
          ),
          _productRow(theme),
        ],
      ),
    );
  }

  Widget _askCard(FlutterFlowTheme theme) {
    final p = _post!;
    final budgetMin = (p['ask_budget_min'] as num?)?.toDouble();
    final budgetMax = (p['ask_budget_max'] as num?)?.toDouble();
    final category = p['post_category'] as String?;
    return _container(
      theme,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(theme, isAsk: true),
          if ((p['content'] as String? ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(p['content'] as String,
                maxLines: widget.detail ? null : 4,
                overflow: widget.detail ? null : TextOverflow.ellipsis,
                style: TextStyle(
                    color: theme.primaryText, fontSize: 13, height: 1.3)),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              if (category != null && category.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: theme.alternate,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(_titleCase(category),
                      style:
                          TextStyle(color: theme.primaryText, fontSize: 10.5)),
                ),
              if (budgetMin != null)
                Expanded(
                  child: Text(
                    'Budget: ${_naira(budgetMin)}${budgetMax != null ? ' - ${_naira(budgetMax)}' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: theme.secondaryText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          // Students answer in the comments; sellers can also reply in chat
          // (not on an ask posted without a name, which would reveal it).
          const SizedBox(height: 10),
          Row(
            children: [
              InkWell(
                onTap: _openComments,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          color: theme.primaryText, size: 17),
                      const SizedBox(width: 6),
                      Text(
                          _isMine
                              ? '${p['comment_count'] ?? 0} answer${(p['comment_count'] ?? 0) == 1 ? '' : 's'}'
                              : ((p['comment_count'] ?? 0) == 0
                                  ? 'Answer'
                                  : 'Answer · ${p['comment_count']}'),
                          style: TextStyle(
                              color: theme.primaryText,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (!_isMine && p['is_anonymous'] != true)
                InkWell(
                  onTap: _replyToAsk,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Reply via DM',
                          style: TextStyle(
                              color: theme.secondary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_right_alt,
                          color: theme.secondary, size: 20),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      border: theme.secondary.withValues(alpha: 0.35),
    );
  }
}

bool _isVideoUrl(String u) {
  final l = u.toLowerCase();
  return l.contains('/video/upload/') ||
      RegExp(r'\.(mp4|mov|m4v|webm|avi|mkv)(\?|$)').hasMatch(l);
}

/// Still frame of a Cloudinary video (falls back to the URL itself).
String _videoThumb(String u) {
  if (!u.contains('/video/upload/')) return u;
  final withT = u.replaceFirst(
      '/video/upload/', '/video/upload/so_0,w_900,c_limit,f_jpg,q_auto/');
  return withT.replaceFirst(
      RegExp(r'\.(mp4|mov|m4v|webm|avi|mkv)(\?.*)?$', caseSensitive: false),
      '.jpg');
}

/// Swipeable media for a post. Images show directly; videos show a still
/// frame with a play button and open in a full-screen player.
class _MediaCarousel extends StatefulWidget {
  const _MediaCarousel({required this.urls, this.height = 200});

  final List<String> urls;
  final double height;

  @override
  State<_MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<_MediaCarousel> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final urls = widget.urls;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: urls.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final url = urls[i];
                if (_isVideoUrl(url)) {
                  return GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      barrierColor: Colors.black,
                      builder: (_) => _VideoDialog(url: url),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(_videoThumb(url),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: Colors.black87)),
                        Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 36),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () => openOrijaImageViewer(
                      context,
                      urls.where((u) => !_isVideoUrl(u)).toList(),
                      urls.where((u) => !_isVideoUrl(u)).toList().indexOf(url)),
                  child: Image.network(url,
                      width: double.infinity, fit: BoxFit.cover),
                );
              },
            ),
            if (urls.length > 1) ...[
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('${_page + 1}/${urls.length}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10.5)),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < urls.length; i++)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _page
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VideoDialog extends StatefulWidget {
  const _VideoDialog({required this.url});

  final String url;

  @override
  State<_VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<_VideoDialog> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _ready = true);
      _controller
        ..setLooping(true)
        ..play();
    }).catchError((_) {
      if (mounted) setState(() => _failed = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          Center(
            child: _failed
                ? const Text('Couldn\'t play this video.',
                    style: TextStyle(color: Colors.white70))
                : !_ready
                    ? const CircularProgressIndicator(color: Colors.white)
                    : GestureDetector(
                        onTap: () => setState(() => _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play()),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(_controller),
                              VideoProgressIndicator(_controller,
                                  allowScrubbing: true),
                              if (!_controller.value.isPlaying)
                                const Center(
                                    child: Icon(Icons.play_arrow_rounded,
                                        color: Colors.white70, size: 72)),
                            ],
                          ),
                        ),
                      ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-screen, pinch-to-zoom photo viewer for post images. Deliberately NOT
/// routed through the native `imageViewer` page, whose
/// `params.getParam<String>('imageUrl', ..., isList: true)` round-trip
/// through a query string crashed on a null/empty imageUrl list -- pushed
/// directly with the photo list already in hand instead. Kept as a private
/// copy of the same widget in orija_listing_detail.dart because the custom
/// widgets barrel only re-exports each file's main widget class.
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
      {required this.photos, required this.initialIndex});

  final List<String> photos;
  final int initialIndex;

  @override
  State<_OrijaFullscreenImageViewer> createState() =>
      _OrijaFullscreenImageViewerState();
}

class _OrijaFullscreenImageViewerState
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
