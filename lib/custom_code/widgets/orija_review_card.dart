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

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replacement for the native `reviewcontainer` component's content
/// (embedded one level below its synthetic root, same as every other
/// component conversion this project uses). Adds the one thing the native
/// version couldn't: a storefront owner replying to a review, and that
/// reply (or a "Reply" affordance, if the viewer owns the store and none
/// exists yet) rendering right under the review.
///
/// `isOwner` is supplied by the caller rather than resolved internally --
/// every call site already knows whether the viewer owns the storefront
/// this review belongs to (my_storefront's "my own reviews" list always
/// passes true; anywhere else defaults to false, which just hides the
/// reply affordance and still renders an existing reply read-only).
class OrijaReviewCard extends StatefulWidget {
  const OrijaReviewCard({
    super.key,
    this.width,
    this.height,
    required this.avatarUrl,
    required this.reviewerName,
    required this.createdAt,
    required this.overallRating,
    required this.comment,
    required this.reviewId,
    this.vendorReply,
    this.isOwner,
  });

  final double? width;
  final double? height;
  final String? avatarUrl;
  final String? reviewerName;
  final String? createdAt;
  final int? overallRating;
  final String? comment;
  final String? reviewId;
  final String? vendorReply;
  final bool? isOwner;

  @override
  State<OrijaReviewCard> createState() => _OrijaReviewCardState();
}

class _OrijaReviewCardState extends State<OrijaReviewCard> {
  late String? _reply = widget.vendorReply;
  bool _replying = false;
  bool _posting = false;
  String? _error;
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  String _relativeTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Future<void> _postReply() async {
    final text = _replyController.text.trim();
    final id = widget.reviewId;
    if (text.isEmpty || id == null || id.isEmpty) return;
    setState(() {
      _posting = true;
      _error = null;
    });
    try {
      final res =
          await Supabase.instance.client.rpc('reply_to_review', params: {
        'p_review_id': id,
        'p_reply': text,
      });
      if (res is Map && res['success'] == true) {
        if (!mounted) return;
        setState(() {
          _reply = text;
          _replying = false;
          _posting = false;
        });
        return;
      }
      final message = res is Map && res['message'] is String
          ? res['message'] as String
          : 'Could not post reply.';
      if (!mounted) return;
      setState(() {
        _error = message;
        _posting = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No connection. Try again.';
        _posting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final rating = (widget.overallRating ?? 0).clamp(0, 5);
    final owner = widget.isOwner ?? false;
    final avatar = widget.avatarUrl ?? '';

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.alternate),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: avatar.isEmpty
                    ? Container(
                        color: theme.alternate,
                        alignment: Alignment.center,
                        child: Icon(Icons.person, color: theme.secondaryText),
                      )
                    : Image.network(avatar, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.reviewerName ?? 'Anonymous',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          _relativeTime(widget.createdAt),
                          style: TextStyle(
                              color: theme.secondaryText, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 16,
                          color: theme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.comment ?? '',
            style: TextStyle(
                color: theme.primaryText, fontSize: 12.5, height: 1.35),
          ),
          if (_reply != null && _reply!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border(left: BorderSide(color: theme.primary, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Seller response',
                      style: TextStyle(
                          color: theme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(_reply!,
                      style: TextStyle(
                          color: theme.primaryText,
                          fontSize: 12.5,
                          height: 1.35)),
                ],
              ),
            ),
          ] else if (owner) ...[
            const SizedBox(height: 8),
            if (!_replying)
              TextButton.icon(
                onPressed: () => setState(() => _replying = true),
                icon: Icon(Icons.reply, size: 16, color: theme.secondary),
                label: Text('Reply',
                    style: TextStyle(
                        color: theme.secondary, fontWeight: FontWeight.w700)),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              )
            else ...[
              TextField(
                controller: _replyController,
                minLines: 2,
                maxLines: 4,
                style: TextStyle(color: theme.primaryText, fontSize: 12.5),
                decoration: InputDecoration(
                  hintText: 'Write a public reply to this review…',
                  hintStyle:
                      TextStyle(color: theme.secondaryText, fontSize: 12.5),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.alternate)),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 4),
                Text(_error!,
                    style: TextStyle(color: theme.error, fontSize: 11)),
              ],
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _posting
                        ? null
                        : () => setState(() {
                              _replying = false;
                              _error = null;
                              _replyController.clear();
                            }),
                    child: Text('Cancel',
                        style: TextStyle(color: theme.secondaryText)),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: _posting ? null : _postReply,
                    child: _posting
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 1.5, color: theme.secondary),
                          )
                        : Text('Post',
                            style: TextStyle(
                                color: theme.secondary,
                                fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
