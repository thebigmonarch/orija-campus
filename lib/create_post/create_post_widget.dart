import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'create_post_model.dart';
export 'create_post_model.dart';

/// DefaultDesign system: background Surface #FFF5EE, Primary #86370E,
/// Secondary/CTA #FE6601, Tertiary #ED9E66, Ink text #2A1005, Muted #8B6553,
/// Card white.
///
/// Font: Arial. Nav bar 56 px, top app bar 56 px. Radius tokens: sm 4 px, md
/// 8 px, lg 12 px, xl 16 px, 2xl 24 px, full 999 px. Brand feel: warm,
/// vibrant, trusted Nigerian market. Create Post screen. Top app bar: 'New
/// Post', X close left, 'Post' Primary ghost right (disabled until content
/// added). Storefront selector at top: currently active storefront avatar +
/// name + dropdown chevron (vendor may have multiple storefronts). Image
/// upload strip: horizontal scroll row — first slot is camera icon dashed
/// 80×80 px 'Add photo', up to 5 images. Caption textarea: placeholder
/// 'What's happening in your store?', min-height 4 lines, 200-char limit,
/// counter bottom-right. 'Tag a product' row: link icon + 'Add product link'
/// ghost — opens product picker sheet. 'Post to community' row: community
/// icon + 'Select community' — opens community picker chips.
class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({
    super.key,
    required this.storeID,
  });

  final String? storeID;

  static String routeName = 'createPost';
  static String routePath = 'createPost';

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  late CreatePostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatePostModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.communityOut = await CommunityMembersTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'user_id',
              currentUserUid,
            ),
          );
          _model.communityID = _model.communityOut!
              .map((e) => e.communityId)
              .toList()
              .toList()
              .cast<String>();
          safeSetState(() {});
        }),
        Future(() async {
          _model.storeOut = await StorefrontsTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'owner_id',
              currentUserUid,
            ),
          );
          _model.storeID = _model.storeOut?.firstOrNull?.id;
          _model.storeLogo = _model.storeOut?.firstOrNull?.logoUrl;
          _model.storeName = _model.storeOut?.firstOrNull?.name;
          _model.storeCategory = _model.storeOut?.firstOrNull?.category;
          _model.isSelected = true;
          safeSetState(() {});
        }),
      ]);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StorefrontsWithReviewSummaryRow>>(
      future: StorefrontsWithReviewSummaryTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.storeID,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitChasingDots(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 50.0,
                ),
              ),
            ),
          );
        }
        List<StorefrontsWithReviewSummaryRow>
            createPostStorefrontsWithReviewSummaryRowList = snapshot.data!;

        final createPostStorefrontsWithReviewSummaryRow =
            createPostStorefrontsWithReviewSummaryRowList.isNotEmpty
                ? createPostStorefrontsWithReviewSummaryRowList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: SafeArea(
              top: true,
              child: Container(
                child: custom_widgets.OrijaCreatePost(
                  storeId: widget.storeID,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
