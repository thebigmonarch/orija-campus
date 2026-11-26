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

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/widgets/orija_review_card.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Replaces storefront_page's Reviews-tab list. The native `reviewcontainer`
/// component embedded there before this was never wired to real data --
/// just one static, unbound instance -- so this fetches the storefront's
/// actual reviews (joined to the reviewer's name/avatar via the
/// reviews_reviewer_id_fkey relationship) and renders a real OrijaReviewCard
/// per row, with reply enabled when the viewer owns this storefront.
class OrijaStorefrontReviewsList extends StatefulWidget {
  const OrijaStorefrontReviewsList({
    super.key,
    this.width,
    this.height,
    required this.storefrontSlug,
  });

  final double? width;
  final double? height;
  final String? storefrontSlug;

  @override
  State<OrijaStorefrontReviewsList> createState() =>
      _OrijaStorefrontReviewsListState();
}

class _OrijaStorefrontReviewsListState
    extends State<OrijaStorefrontReviewsList> {
  bool _loading = true;
  String? _ownerId;
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final slug = widget.storefrontSlug ?? '';
    if (slug.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final store = await Supabase.instance.client
          .from('storefronts')
          .select('id, owner_id')
          .eq('slug', slug)
          .maybeSingle();
      if (store == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      final rows = await Supabase.instance.client
          .from('reviews')
          .select(
              '*, users!reviews_reviewer_id_fkey(first_name, last_name, avatar_url)')
          .eq('storefront_id', store['id'])
          .eq('status', 'visible')
          .order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _ownerId = store['owner_id'] as String?;
        _reviews = List<Map<String, dynamic>>.from(rows as List);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isOwner = _ownerId != null && _ownerId == currentUserUid;

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('No reviews yet.',
              style: TextStyle(color: theme.secondaryText)),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final r in _reviews) ...[
          Builder(builder: (context) {
            final user = r['users'] as Map<String, dynamic>?;
            final first = (user?['first_name'] as String?)?.trim() ?? '';
            final last = (user?['last_name'] as String?)?.trim() ?? '';
            final name = [first, last].where((s) => s.isNotEmpty).join(' ');
            return OrijaReviewCard(
              avatarUrl: user?['avatar_url'] as String?,
              reviewerName: name.isEmpty ? 'Anonymous' : name,
              createdAt: r['created_at'] as String?,
              overallRating: (r['overall_rating'] as num?)?.toInt(),
              comment: r['comment'] as String?,
              reviewId: r['id'] as String?,
              vendorReply: r['vendor_reply'] as String?,
              isOwner: isOwner,
            );
          }),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
