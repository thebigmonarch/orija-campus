import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/community_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'community_component_model.dart';
export 'community_component_model.dart';

class CommunityComponentWidget extends StatefulWidget {
  const CommunityComponentWidget({
    super.key,
    required this.communityId,
  });

  final String? communityId;

  @override
  State<CommunityComponentWidget> createState() =>
      _CommunityComponentWidgetState();
}

class _CommunityComponentWidgetState extends State<CommunityComponentWidget> {
  late CommunityComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityComponentModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.communityOut = await CommunityMembersTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'community_id',
              widget.communityId,
            )
            .eqOrNull(
              'user_id',
              currentUserUid,
            ),
      );
      _model.isJoined =
          _model.communityOut != null && (_model.communityOut)!.isNotEmpty
              ? true
              : false;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommunitiesRow>>(
      future: CommunitiesTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.communityId,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Container(
            width: double.infinity,
            child: CommunityShimmerWidget(),
          );
        }
        List<CommunitiesRow> containerCommunitiesRowList = snapshot.data!;

        final containerCommunitiesRow = containerCommunitiesRowList.isNotEmpty
            ? containerCommunitiesRowList.first
            : null;

        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed(
              CommunityWidget.routeName,
              queryParameters: {
                'communitySlug': serializeParam(
                  containerCommunitiesRow?.slug,
                  ParamType.String,
                ),
                'communityID': serializeParam(
                  containerCommunitiesRow?.id,
                  ParamType.String,
                ),
              }.withoutNulls,
            );
          },
          child: Container(
            width: double.infinity,
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.network(
                  valueOrDefault<String>(
                    containerCommunitiesRow?.coverUrl,
                    'https://picsum.photos/seed/332/600',
                  ),
                ).image,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          height: 110.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).tertiary,
                            ),
                          ),
                          child: Stack(
                            children: [
                              ClipRect(
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 6.0,
                                    sigmaY: 6.0,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0x93000000),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              valueOrDefault<String>(
                                                containerCommunitiesRow?.name,
                                                'null',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.people_outline,
                                                  color: Color(0xFFE5E5E5),
                                                  size: 16.0,
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      containerCommunitiesRow
                                                          ?.memberCount,
                                                      formatType:
                                                          FormatType.compact,
                                                    ),
                                                    '0',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        color:
                                                            Color(0xFFE5E5E5),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 6.0)),
                                            ),
                                          ].divide(SizedBox(height: 6.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(
                                              height: 40.0,
                                              child: VerticalDivider(
                                                thickness: 2.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                            ),
                                            Container(
                                              child: custom_widgets
                                                  .OrijaCommunityAction(
                                                communityId:
                                                    widget.communityId,
                                                storeId: '',
                                                isLink: false,
                                                isJoined: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
                                      maxLines: 2,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Color(0xFFE5E5E5),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ].divide(SizedBox(height: 10.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ].divide(SizedBox(height: 10.0)),
            ),
          ),
        );
      },
    );
  }
}
