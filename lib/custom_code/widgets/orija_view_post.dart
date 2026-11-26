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
import 'package:go_router/go_router.dart';

import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_post_card.dart';
import '/custom_code/widgets/orija_post_comments.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Body of View Post. The native page had a real bug in its comment box:
/// replying inserted the comment straight into post_comments AND then called
/// the send-comment API, so every reply was posted twice, and top-level
/// comments skipped the RPC entirely, so the post's author was never
/// notified. All comment writing now goes through send_comment (one row,
/// counts and notifications handled server-side).
///
/// The post is the shared OrijaPostCard in detail mode (full text, larger
/// media, follow button, every action); the comments are the inline thread
/// from OrijaPostComments -- like, reply, reply to a reply, attach a
/// listing -- in one scrolling list with the composer pinned at the bottom.
/// Asks take no comments (the RPC refuses them), so they show the question
/// with its Reply-via-DM action alone.
class OrijaViewPost extends StatefulWidget {
  const OrijaViewPost({super.key, this.width, this.height, this.postId});

  final double? width;
  final double? height;
  final String? postId;

  @override
  State<OrijaViewPost> createState() => _OrijaViewPostState();
}

class _OrijaViewPostState extends State<OrijaViewPost> {
  final ValueNotifier<int> _focusComposer = ValueNotifier<int>(0);
  Map<String, dynamic>? _post;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _focusComposer.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = widget.postId;
    if (id == null || id.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    try {
      final row = await Supabase.instance.client
          .from('feed_view')
          .select()
          .eq('post_id', id)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        _post = row == null ? null : Map<String, dynamic>.from(row);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 4 (Pattern C group, simple centered
    // treatment -- standalone destination here). Mobile body below is
    // untouched; this gate is unreachable on a real phone.
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
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }
    final post = _post;
    if (post == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_off_outlined,
                  size: 48, color: theme.secondaryText),
              const SizedBox(height: 12),
              Text('This post is no longer available.',
                  style: TextStyle(color: theme.secondaryText, fontSize: 14)),
              TextButton(
                  onPressed: () => context.pop(), child: const Text('Go back')),
            ],
          ),
        ),
      );
    }
    final isAsk = post['post_type'] == 'ask';
    final card = OrijaPostCard(
      key: ValueKey(post['post_id']),
      post: post,
      detail: true,
      onCommentsTap: isAsk ? null : () => _focusComposer.value++,
      onDeleted: (_) {
        if (mounted) context.pop();
      },
    );
    if (isAsk) return SingleChildScrollView(child: card);
    return OrijaPostComments(
      postId: post['post_id'] as String,
      postAuthorId: post['author_id'] as String?,
      embedded: true,
      header: card,
      focusSignal: _focusComposer,
    );
  }
}
