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

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/chat_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// One row in the chat list, for a single thread. Carried over from the
/// FlutterFlow-native `chatThread` component with two real bugs fixed:
///
///  - The preview text sometimes showed the literal string
///    "[If/Then/Else (2 Conditions)]" instead of the last message. That
///    string is FlutterFlow's own editor placeholder for an incompletely
///    configured Conditional Value binding on a Text widget -- a native
///    binding this file no longer uses at all, so the class of bug is gone
///    by construction, not patched around.
///  - "Checkout your bag" showed for a buyer whenever `has_active_bag` was
///    true, which includes a bag that's only been SENT and is still awaiting
///    the vendor's review -- proceed_to_checkout refuses at that stage
///    ("Bag is still being reviewed by the vendor"), so the strip was
///    sometimes pointing the buyer at an action they couldn't complete yet.
///    It now also checks the bag's own status and only shows once the
///    vendor has confirmed it.
class OrijaChatThread extends StatefulWidget {
  const OrijaChatThread({
    super.key,
    this.width,
    this.height,
    required this.threadId,
  });

  final double? width;
  final double? height;
  final String? threadId;

  @override
  State<OrijaChatThread> createState() => _OrijaChatThreadState();
}

class _OrijaChatThreadState extends State<OrijaChatThread>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrowController;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  Future<void> _open(BuildContext context, Map<String, dynamic> row) async {
    if (row['thread_type'] == 'dm') {
      // Marking read happens once inside the thread itself (see
      // OrijaMessageThread), not here -- clearing it on tap, before the
      // buyer/seller has actually seen anything, is what made "jump to the
      // first unread message" impossible to build: by the time the thread
      // opened, there was no unread left to jump to.
      await context.pushNamed(
        OrijaMessageThreadPageWidget.routeName,
        queryParameters: {
          'threadId': serializeParam('${row['thread_id']}', ParamType.String),
        }.withoutNulls,
      );
    } else {
      await context.pushNamed(
        GroupChatWidget.routeName,
        queryParameters: {
          'communityId':
              serializeParam('${row['community_id']}', ParamType.String),
        }.withoutNulls,
      );
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);

    // A one-time fetch, matching the original component: this row doesn't
    // hold its own realtime subscription (the list page it lives in already
    // owns that), and a view can't be streamed in any case -- Realtime's
    // logical replication only tracks base tables, not views.
    return FutureBuilder<Map<String, dynamic>?>(
      future: Supabase.instance.client
          .from('all_threads_view')
          .select()
          .eq('thread_id', widget.threadId ?? '')
          .maybeSingle(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const ChatShimmerWidget();
        final row = snapshot.data;
        if (row == null) return const SizedBox.shrink();

        final isDm = row['thread_type'] == 'dm';
        final isVendor = row['vendor_id'] == currentUserUid;
        final unread =
            (isVendor ? row['vendor_unread'] : row['buyer_unread']) as int? ??
                0;
        final avatarUrl = isDm
            ? (isVendor
                ? row['buyer_avatar'] as String?
                : row['storefront_logo_url'] as String?)
            : row['community_cover_url'] as String?;
        final title = isDm
            ? (isVendor
                ? (row['buyer_name'] as String? ?? '')
                : (row['storefront_name'] as String? ?? ''))
            : (row['community_name'] as String? ?? '');
        final preview = (row['last_message_content'] as String?) ?? '';
        // A group chat whose store plan is off: no preview, a lock instead of a badge.
        final locked = row['community_locked'] == true;
        final lastIsMine = row['last_message_sender_id'] == currentUserUid;
        final lastIsRead = row['last_message_is_read'] == true;
        final readyToCheckout = row['is_bag'] == true &&
            row['active_bag_status'] == 'vendor_confirmed';
        final showCheckoutStrip = isDm && !isVendor && readyToCheckout;

        return InkWell(
          onTap: () => _open(context, row),
          child: Container(
            decoration: BoxDecoration(
              color: unread > 0 ? t.secondaryBackground : t.primaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: (avatarUrl ?? '').isEmpty
                                ? Container(
                                    color: t.secondaryBackground,
                                    alignment: Alignment.center,
                                    child: Icon(
                                        isDm
                                            ? (isVendor
                                                ? Icons.person
                                                : Icons.storefront)
                                            : Icons.groups,
                                        color: t.secondaryText),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: avatarUrl!,
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          if (isDm && isVendor)
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: t.alternate,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: t.secondary, width: 2),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child:
                                  (row['storefront_logo_url'] as String? ?? '')
                                          .isEmpty
                                      ? Icon(Icons.storefront,
                                          size: 14, color: t.secondaryText)
                                      : Image.network(
                                          row['storefront_logo_url'] as String,
                                          fit: BoxFit.cover),
                            ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title.isEmpty ? 'Orija' : title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: t.primaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  row['last_message_at'] == null
                                      ? ''
                                      : dateTimeFormat(
                                          'relative',
                                          DateTime.parse(row['last_message_at']
                                              as String)),
                                  style: TextStyle(
                                      color: t.secondaryText, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (isDm && lastIsMine)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: FaIcon(
                                      FontAwesomeIcons.checkDouble,
                                      size: 14,
                                      color: lastIsRead
                                          ? t.secondary
                                          : t.secondaryText,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    locked
                                        ? 'Plan inactive · Renew to rejoin'
                                        : preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: t.secondaryText, fontSize: 12),
                                  ),
                                ),
                                if (locked)
                                  Icon(Icons.lock_outline_rounded,
                                      size: 16, color: t.secondaryText)
                                else
                                  badges.Badge(
                                    showBadge: unread > 0,
                                    badgeContent: Text(
                                      formatNumber(unread,
                                          formatType: FormatType.compact),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    badgeColor: t.primary,
                                    shape: badges.BadgeShape.circle,
                                    padding: const EdgeInsets.all(6),
                                    child: const SizedBox(width: 2),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showCheckoutStrip)
                  Container(
                    color: t.secondary,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Checkout your bag',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        const FaIcon(FontAwesomeIcons.shoppingBag,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        AnimatedBuilder(
                          animation: _arrowController,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(_arrowController.value * 5, 0),
                            child: child,
                          ),
                          child: const FaIcon(FontAwesomeIcons.arrowRight,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
