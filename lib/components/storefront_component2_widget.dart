import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/storefront/storefront_shimmer_new/storefront_shimmer_new_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'storefront_component2_model.dart';
export 'storefront_component2_model.dart';

class StorefrontComponent2Widget extends StatefulWidget {
  const StorefrontComponent2Widget({
    super.key,
    required this.storeID,
    bool? colour,
  }) : this.colour = colour ?? false;

  final String? storeID;
  final bool colour;

  @override
  State<StorefrontComponent2Widget> createState() =>
      _StorefrontComponent2WidgetState();
}

class _StorefrontComponent2WidgetState
    extends State<StorefrontComponent2Widget> {
  late StorefrontComponent2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontComponent2Model());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.storeOut = await FollowsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'storefront_id',
              widget.storeID,
            )
            .eqOrNull(
              'follower_id',
              currentUserUid,
            ),
      );
      if (_model.storeOut != null && (_model.storeOut)!.isNotEmpty) {
        _model.isFollow = true;
        safeSetState(() {});
      } else {
        _model.isFollow = false;
        safeSetState(() {});
      }
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
          return StorefrontShimmerNewWidget();
        }
        List<StorefrontsWithReviewSummaryRow>
            containerStorefrontsWithReviewSummaryRowList = snapshot.data!;

        final containerStorefrontsWithReviewSummaryRow =
            containerStorefrontsWithReviewSummaryRowList.isNotEmpty
                ? containerStorefrontsWithReviewSummaryRowList.first
                : null;

        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed(
              StorefrontPageWidget.routeName,
              queryParameters: {
                'storefontslug': serializeParam(
                  containerStorefrontsWithReviewSummaryRow?.slug,
                  ParamType.String,
                ),
              }.withoutNulls,
            );
          },
          child: Container(
            width: 300.0,
            decoration: BoxDecoration(
              color: valueOrDefault<Color>(
                widget.colour
                    ? FlutterFlowTheme.of(context).primaryBackground
                    : FlutterFlowTheme.of(context).secondaryBackground,
                FlutterFlowTheme.of(context).secondaryBackground,
              ),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130.0,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.network(
                                valueOrDefault<String>(
                                  containerStorefrontsWithReviewSummaryRow
                                      ?.coverUrl,
                                  'https://picsum.photos/seed/625/600',
                                ),
                              ).image,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, 1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.network(
                                        valueOrDefault<String>(
                                          containerStorefrontsWithReviewSummaryRow
                                              ?.logoUrl,
                                          'https://picsum.photos/seed/625/600',
                                        ),
                                      ).image,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            RatingBarIndicator(
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: FlutterFlowTheme.of(context).secondary,
                              ),
                              direction: Axis.horizontal,
                              rating: valueOrDefault<double>(
                                containerStorefrontsWithReviewSummaryRow
                                    ?.avgRating,
                                0.0,
                              ),
                              unratedColor:
                                  FlutterFlowTheme.of(context).accent1,
                              itemCount: 5,
                              itemSize: 24.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          containerStorefrontsWithReviewSummaryRow?.name,
                          'storename',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                      if (containerStorefrontsWithReviewSummaryRow?.ownerId !=
                          currentUserUid)
                        Builder(
                          builder: (context) {
                            if (_model.isFollow ?? false) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await FollowsTable().delete(
                                    matchingRows: (rows) => rows
                                        .eqOrNull(
                                          'follower_id',
                                          currentUserUid,
                                        )
                                        .eqOrNull(
                                          'storefront_id',
                                          containerStorefrontsWithReviewSummaryRow
                                              ?.id,
                                        ),
                                  );
                                  _model.isFollow = !(_model.isFollow ?? true);
                                  safeSetState(() {});
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(24.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 4.0, 0.0, 4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Following',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await FollowsTable().insert({
                                    'follower_id': currentUserUid,
                                    'storefront_id':
                                        containerStorefrontsWithReviewSummaryRow
                                            ?.id,
                                  });
                                  _model.isFollow = !(_model.isFollow ?? true);
                                  safeSetState(() {});
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 4.0, 0.0, 4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Follow',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                  Text(
                    valueOrDefault<String>(
                      containerStorefrontsWithReviewSummaryRow?.description,
                      'null',
                    ),
                    maxLines: 2,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ].divide(SizedBox(height: 10.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}
