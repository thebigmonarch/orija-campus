import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_post_model.dart';
export 'view_post_model.dart';

class ViewPostWidget extends StatefulWidget {
  const ViewPostWidget({
    super.key,
    required this.postID,
    required this.postType,
    required this.storeID,
  });

  final String? postID;
  final String? postType;
  final String? storeID;

  static String routeName = 'viewPost';
  static String routePath = 'viewPost';

  @override
  State<ViewPostWidget> createState() => _ViewPostWidgetState();
}

class _ViewPostWidgetState extends State<ViewPostWidget> {
  late ViewPostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewPostModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.apiResultm4r = await GetpostuserstateCall.call(
        postID: widget.postID,
        storeID: widget.storeID,
        userID: currentUserUid,
      );

      if ((_model.apiResultm4r?.succeeded ?? true)) {
        _model.hasLiked = GetpostuserstateCall.hasLiked(
          (_model.apiResultm4r?.jsonBody ?? ''),
        );
        _model.hasCommented = GetpostuserstateCall.hasCommented(
          (_model.apiResultm4r?.jsonBody ?? ''),
        );
        _model.hasReposted = GetpostuserstateCall.hasRecommend(
          (_model.apiResultm4r?.jsonBody ?? ''),
        );
        _model.hasSaved = GetpostuserstateCall.hasSaved(
          (_model.apiResultm4r?.jsonBody ?? ''),
        );
        _model.hasFollowed = GetpostuserstateCall.hasFollowed(
          (_model.apiResultm4r?.jsonBody ?? ''),
        );
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      FFAppState().commentID = '';
      FFAppState().commentorName = '';
      safeSetState(() {});
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 54.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              title: Text(
                'Back',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.plusJakartaSans(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 18.0,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2.0,
            )
          ],
          body: Builder(
            builder: (context) {
              return SafeArea(
                top: false,
                child: Container(
                  child: custom_widgets.OrijaViewPost(
                    postId: widget.postID,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
