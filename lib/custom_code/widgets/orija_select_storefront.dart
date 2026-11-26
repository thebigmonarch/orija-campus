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

import 'package:flutter/material.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Bottom sheet: "which of my storefronts should respond to this Ask?".
/// Rebuild of the native `SelectStorefrontWidget` component as custom code,
/// same public interface (postID, userID -- userID here is the Ask post's
/// author, i.e. the buyer, not the vendor opening this sheet) so its one
/// live call site (`orija_post_card.dart`'s `_replyToAsk`) is a drop-in
/// swap. The other two native call sites (`ask_component_widget.dart` via
/// `feed_slide_compoonet_widget.dart`/`ask_market_place_widget.dart`) are
/// confirmed orphaned -- neither of those parent widgets is placed on any
/// live page -- so they're left untouched rather than risked for no benefit.
///
/// Picking a store calls `vendor_respond_to_ask` -- a dedicated RPC for
/// this flow, deliberately separate from the shared `openchat_ask` that
/// `orija_oja_feed.dart`'s single-storefront quick-respond still uses, so
/// this flow's behavior can evolve independently. Same validation and
/// thread find-or-create shape (ownership check, ask status/expiry, author
/// match, no replying to your own ask), verified directly against live
/// data before wiring it in here.
class OrijaSelectStorefront extends StatefulWidget {
  const OrijaSelectStorefront({
    super.key,
    this.width,
    this.height,
    required this.postID,
    required this.userID,
  });

  final double? width;
  final double? height;
  final String? postID;
  final String? userID;

  @override
  State<OrijaSelectStorefront> createState() => _OrijaSelectStorefrontState();
}

class _OrijaSelectStorefrontState extends State<OrijaSelectStorefront> {
  bool _loading = true;
  String? _busyStoreId;
  List<StorefrontsWithReviewSummaryRow> _stores = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await StorefrontsWithReviewSummaryTable().queryRows(
        queryFn: (q) => q.eqOrNull('owner_id', currentUserUid),
      );
      if (!mounted) return;
      setState(() {
        _stores = rows;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fail(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)),
      duration: const Duration(milliseconds: 4000),
      backgroundColor: FlutterFlowTheme.of(context).error,
    ));
  }

  Future<void> _respond(StorefrontsWithReviewSummaryRow store) async {
    if (_busyStoreId != null) return;
    setState(() => _busyStoreId = store.id);
    try {
      final res =
          await Supabase.instance.client.rpc('vendor_respond_to_ask', params: {
        'p_storefront_id': store.id,
        'p_ask_post_id': widget.postID,
        'p_ask_author_id': widget.userID,
      });
      if (!mounted) return;
      if (res is Map && res['success'] == true) {
        Navigator.of(context).pop();
        context.pushNamed(
          'OrijaMessageThreadPage',
          queryParameters: {
            'threadId': serializeParam('${res['thread_id']}', ParamType.String),
          }.withoutNulls,
        );
      } else {
        _fail((res is Map ? res['message'] as String? : null) ??
            'Could not respond. Please try again.');
      }
    } catch (_) {
      _fail('Failed. Please try again in a few minutes.');
    } finally {
      if (mounted) setState(() => _busyStoreId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 600),
      decoration: BoxDecoration(
        color: t.primaryBackground,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: t.alternate, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Choose a storefront to respond',
                    style: TextStyle(
                        color: t.primaryText,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: _loading
                  ? Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                          child: CircularProgressIndicator(color: t.secondary)),
                    )
                  : _stores.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text('You have no storefronts yet.',
                              style: TextStyle(
                                  color: t.secondaryText, fontSize: 13.5)),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          shrinkWrap: true,
                          itemCount: _stores.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final s = _stores[i];
                            final busy = _busyStoreId == s.id;
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: t.secondaryBackground,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: t.alternate),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: (s.logoUrl ?? '').isEmpty
                                          ? Container(
                                              color: t.alternate,
                                              child: Icon(
                                                  Icons.storefront_rounded,
                                                  color: t.secondaryText))
                                          : Image.network(s.logoUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                      color: t.alternate,
                                                      child: Icon(
                                                          Icons
                                                              .storefront_rounded,
                                                          color: t
                                                              .secondaryText))),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(s.name ?? '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: t.primaryText,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            if (s.isVerified == true) ...[
                                              const SizedBox(width: 4),
                                              Icon(Icons.verified_rounded,
                                                  size: 15, color: t.secondary),
                                            ],
                                            const Spacer(),
                                            Icon(Icons.star_rounded,
                                                size: 14,
                                                color: const Color(0xFFFFC94D)),
                                            const SizedBox(width: 2),
                                            Text(
                                                (s.avgRating ?? 0)
                                                    .toStringAsFixed(1),
                                                style: TextStyle(
                                                    color: t.secondaryText,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        if ((s.description ?? '')
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(s.description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: t.secondaryText,
                                                  fontSize: 12)),
                                        ],
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 36,
                                          child: ElevatedButton(
                                            onPressed:
                                                busy ? null : () => _respond(s),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: t.primary,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            child: busy
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color:
                                                                Colors.white))
                                                : const Text('Chat',
                                                    style: TextStyle(
                                                        fontSize: 13.5,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                          ),
                                        ),
                                      ],
                                    ),
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
}
