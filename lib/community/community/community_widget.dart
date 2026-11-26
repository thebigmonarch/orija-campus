import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'community_model.dart';
export 'community_model.dart';

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({
    super.key,
    required this.communitySlug,
    required this.communityID,
  });

  final String? communitySlug;
  final String? communityID;

  static String routeName = 'community';
  static String routePath = 'community';

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  late CommunityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.commMemberOut = await CommunityMembersTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'community_id',
              widget.communityID,
            )
            .eqOrNull(
              'user_id',
              currentUserUid,
            ),
      );
      if (_model.commMemberOut != null && (_model.commMemberOut)!.isNotEmpty) {
        _model.isJoined = true;
        safeSetState(() {});
      } else {
        _model.isJoined = false;
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
    return FutureBuilder<ApiCallResponse>(
      future: GetCommunityPageCall.call(
        communityID: widget.communityID,
        pUserId: currentUserUid,
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
        final communityGetCommunityPageResponse = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Container(
              child: custom_widgets.OrijaCommunity(
                communityId: widget.communityID,
                embedded: false,
              ),
            ),
          ),
        );
      },
    );
  }
}
