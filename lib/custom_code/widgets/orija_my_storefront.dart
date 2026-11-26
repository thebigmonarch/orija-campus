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
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/storefront/storefront_component/storefront_component_widget.dart';

/// Hand-authored replacement for the generated `myStorefront` page.
/// Deliberately scoped to exactly what it was before: the storefront(s)
/// the signed-in user owns, and the storefronts they follow. Nothing else
/// (no reviews, no stats) -- that lives on storefront_page instead.
class OrijaMyStorefront extends StatefulWidget {
  const OrijaMyStorefront({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OrijaMyStorefront> createState() => _OrijaMyStorefrontState();
}

class _OrijaMyStorefrontState extends State<OrijaMyStorefront> {
  bool _loading = true;
  List<StorefrontsWithReviewSummaryRow> _owned = [];
  List<StorefrontsWithReviewSummaryRow> _following = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final owned = await StorefrontsWithReviewSummaryTable().queryRows(
        queryFn: (q) =>
            q.eqOrNull('owner_id', currentUserUid).order('created_at'),
      );
      final follows = await FollowsTable().queryRows(
        queryFn: (q) => q.eqOrNull('follower_id', currentUserUid),
      );
      List<StorefrontsWithReviewSummaryRow> followed = [];
      if (follows.isNotEmpty) {
        followed = await StorefrontsWithReviewSummaryTable().queryRows(
          queryFn: (q) => q.inFilterOrNull(
            'id',
            follows.map((e) => e.storefrontId).withoutNulls.toList(),
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        _owned = owned;
        _following = followed;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _section(String title, List<StorefrontsWithReviewSummaryRow> rows,
      FlutterFlowTheme theme,
      {required String emptyText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        if (rows.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.alternate),
            ),
            alignment: Alignment.center,
            child: Text(emptyText,
                style: TextStyle(color: theme.secondaryText, fontSize: 12.5)),
          )
        else
          Column(
            children: [
              for (final row in rows) ...[
                StorefrontComponentWidget(
                  key: Key('myStorefront_${row.id}'),
                  storefrontID: row.id,
                  logo: row.logoUrl,
                  name: row.name,
                  isVerified: row.isVerified ?? false,
                  discription: row.description,
                  rating: (row.avgRating ?? 0).toStringAsFixed(1),
                  slug: row.slug,
                  isEdit: false,
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Desktop Shell rollout, Phase 7 (Pattern E group, simple centered
    // treatment). Mobile body below is untouched; this gate is
    // unreachable on a real phone.
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
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        automaticallyImplyLeading: false,
        elevation: 2,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('My Store',
            style: TextStyle(
                color: theme.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: theme.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _section('My Storefront', _owned, theme,
                        emptyText: "You haven't opened a storefront yet."),
                    const SizedBox(height: 24),
                    _section('Following', _following, theme,
                        emptyText: "You're not following any storefronts yet."),
                  ],
                ),
              ),
      ),
    );
  }
}
