import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'my_storefront_model.dart';
export 'my_storefront_model.dart';

class MyStorefrontWidget extends StatefulWidget {
  const MyStorefrontWidget({super.key});

  static String routeName = 'myStorefront';
  static String routePath = 'myStorefront';

  @override
  State<MyStorefrontWidget> createState() => _MyStorefrontWidgetState();
}

class _MyStorefrontWidgetState extends State<MyStorefrontWidget> {
  late MyStorefrontModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyStorefrontModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.followOut = await FollowsTable().queryRows(
        queryFn: (q) => q.eqOrNull(
          'follower_id',
          currentUserUid,
        ),
      );
      if (_model.followOut != null && (_model.followOut)!.isNotEmpty) {
        _model.followExist = true;
        _model.followStoresIds = _model.followOut!
            .map((e) => e.storefrontId)
            .toList()
            .toList()
            .cast<String>();
        safeSetState(() {});
        _model.followedStoreOut =
            await StorefrontsWithReviewSummaryTable().queryRows(
          queryFn: (q) => q.inFilterOrNull(
            'id',
            _model.followOut?.map((e) => e.id).withoutNulls.toList(),
          ),
        );
      } else {
        _model.followExist = false;
        safeSetState(() {});
      }
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
      future: StorefrontsWithReviewSummaryTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'owner_id',
              currentUserUid,
            )
            .order('created_at'),
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
            myStorefrontStorefrontsWithReviewSummaryRowList = snapshot.data!;

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
                child: custom_widgets.OrijaMyStorefront(),
              ),
            ),
          ),
        );
      },
    );
  }
}
