import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/listing_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'listing_card_model.dart';
export 'listing_card_model.dart';

class ListingCardWidget extends StatefulWidget {
  const ListingCardWidget({
    super.key,
    required this.listingID,
    required this.storefrontslug,
    bool? isSend,
    this.treadID,
    double? height,
    bool? color,
  })  : this.isSend = isSend ?? false,
        this.height = height ?? 180.0,
        this.color = color ?? false;

  final String? listingID;
  final String? storefrontslug;
  final bool isSend;
  final String? treadID;
  final double height;
  final bool color;

  @override
  State<ListingCardWidget> createState() => _ListingCardWidgetState();
}

class _ListingCardWidgetState extends State<ListingCardWidget> {
  late ListingCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListingCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListingSummaryRow>>(
      future: ListingSummaryTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          widget.listingID,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Container(
            width: 250.0,
            child: ListingShimmerWidget(),
          );
        }
        List<ListingSummaryRow> containerListingSummaryRowList = snapshot.data!;

        final containerListingSummaryRow =
            containerListingSummaryRowList.isNotEmpty
                ? containerListingSummaryRowList.first
                : null;

        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed(
              ListingdetailPageWidget.routeName,
              queryParameters: {
                'listingId': serializeParam(
                  widget.listingID,
                  ParamType.String,
                ),
                'storefrontId': serializeParam(
                  containerListingSummaryRow.storefrontId,
                  ParamType.String,
                ),
              }.withoutNulls,
            );
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 250.0,
            ),
            decoration: BoxDecoration(
              color: valueOrDefault<Color>(
                widget.color
                    ? FlutterFlowTheme.of(context).primaryBackground
                    : FlutterFlowTheme.of(context).secondaryBackground,
                FlutterFlowTheme.of(context).secondaryBackground,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Color(0x77FE6601),
                  offset: Offset(
                    0.0,
                    2.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: valueOrDefault<Color>(
                  containerListingSummaryRow!.isFeatured!
                      ? FlutterFlowTheme.of(context).tertiary
                      : FlutterFlowTheme.of(context).secondaryBackground,
                  FlutterFlowTheme.of(context).secondaryBackground,
                ),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 500),
                        imageUrl: valueOrDefault<String>(
                          containerListingSummaryRow.photos.firstOrNull,
                          'https://picsum.photos/seed/15/600',
                        ),
                        width: double.infinity,
                        height: widget.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (containerListingSummaryRow.viewCount! > 0)
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 16.0,
                            ),
                            Text(
                              valueOrDefault<String>(
                                formatNumber(
                                  containerListingSummaryRow.viewCount,
                                  formatType: FormatType.compact,
                                ),
                                '0',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyMediumIsCustom,
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 10.0, 8.0, 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                valueOrDefault<String>(
                                  formatNumber(
                                    containerListingSummaryRow.price,
                                    formatType: FormatType.decimal,
                                    decimalType: DecimalType.periodDecimal,
                                    currency: '₦',
                                  ),
                                  '₦0.00',
                                ),
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                valueOrDefault<String>(
                                  functions.formatSubscriptionLabel(
                                      valueOrDefault<String>(
                                    containerListingSummaryRow.pricingType,
                                    'null',
                                  )),
                                  'Fixed',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                valueOrDefault<String>(
                                  containerListingSummaryRow.title,
                                  'null',
                                ),
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                valueOrDefault<String>(
                                  containerListingSummaryRow.description,
                                  'null',
                                ),
                                maxLines: 2,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ].divide(SizedBox(height: 2.0)),
                          ),
                        ].divide(SizedBox(height: 4.0)),
                      ),
                      Builder(
                        builder: (context) {
                          if (widget.isSend) {
                            return FFButtonWidget(
                              onPressed: () async {
                                var _shouldSetState = false;
                                _model.apiResultyyh =
                                    await SenddmmessageCall.call(
                                  treadID: widget.treadID,
                                  userID: currentUserUid,
                                  listingID: containerListingSummaryRow.id,
                                );

                                _shouldSetState = true;
                                if ((_model.apiResultyyh?.succeeded ?? true)) {
                                  Navigator.pop(context);
                                } else {
                                  if (_shouldSetState) safeSetState(() {});
                                  return;
                                }

                                if (_shouldSetState) safeSetState(() {});
                              },
                              text: 'Send',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 30.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).secondary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .titleSmallIsCustom,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            );
                          } else {
                            return Builder(
                              builder: (context) {
                                if (containerListingSummaryRow.vendorId !=
                                    currentUserUid) {
                                  return Builder(
                                    builder: (context) {
                                      if (_model.addtoBag) {
                                        return FFButtonWidget(
                                          onPressed: () async {
                                            _model.apiResult4xfz =
                                                await RemoveFromBagCall.call(
                                              bagitemid: _model.itemBageId,
                                              buyerId: currentUserUid,
                                              bagID: _model.bagId,
                                            );

                                            if ((_model
                                                    .apiResult4xfz?.succeeded ??
                                                true)) {
                                              _model.addtoBag = false;
                                              safeSetState(() {});
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to Remove',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .error,
                                                ),
                                              );
                                            }

                                            safeSetState(() {});
                                          },
                                          text: 'Added',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 30.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FFButtonWidget(
                                              onPressed: () async {
                                                _model.apiResult8q52 =
                                                    await AddToBagCall.call(
                                                  buyerId: currentUserUid,
                                                  listingId:
                                                      containerListingSummaryRow
                                                          .id,
                                                  quantity: 1,
                                                  storefrontId:
                                                      containerListingSummaryRow
                                                          .storefrontId,
                                                  unitPrice:
                                                      containerListingSummaryRow
                                                          .price,
                                                );

                                                if (AddToBagCall.success(
                                                  (_model.apiResult8q52
                                                          ?.jsonBody ??
                                                      ''),
                                                )!) {
                                                  _model.addtoBag = true;
                                                  _model.bagId =
                                                      AddToBagCall.bagid(
                                                    (_model.apiResult8q52
                                                            ?.jsonBody ??
                                                        ''),
                                                  );
                                                  _model.itemBageId =
                                                      AddToBagCall.bagitemid(
                                                    (_model.apiResult8q52
                                                            ?.jsonBody ??
                                                        ''),
                                                  );
                                                  safeSetState(() {});
                                                  ScaffoldMessenger.of(context)
                                                      .clearSnackBars();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        AddToBagCall.message(
                                                          (_model.apiResult8q52
                                                                  ?.jsonBody ??
                                                              ''),
                                                        )!,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      action: SnackBarAction(
                                                        label: 'View Bag',
                                                        textColor: Colors.white,
                                                        onPressed: () async {
                                                          context.pushNamed(
                                                            OrijaBuyerBagPageWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'bagId':
                                                                  serializeParam(
                                                                AddToBagCall
                                                                    .bagid(
                                                                  (_model.apiResult8q52
                                                                          ?.jsonBody ??
                                                                      ''),
                                                                ),
                                                                ParamType
                                                                    .String,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        valueOrDefault<String>(
                                                          AddToBagCall.message(
                                                            (_model.apiResult8q52
                                                                    ?.jsonBody ??
                                                                ''),
                                                          ),
                                                          'null',
                                                        ),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                    ),
                                                  );
                                                }

                                                safeSetState(() {});
                                              },
                                              text: 'Add to Bag',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 30.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallIsCustom,
                                                    ),
                                                elevation: 0.0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondary,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return FFButtonWidget(
                                    onPressed: () async {
                                      context.pushNamed(
                                        CreatelistingPageWidget.routeName,
                                        queryParameters: {
                                          'storeforntId': serializeParam(
                                            containerListingSummaryRow
                                                .storefrontId,
                                            ParamType.String,
                                          ),
                                          'listingId': serializeParam(
                                            containerListingSummaryRow.id,
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    text: 'Edit',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 30.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: valueOrDefault<Color>(
                                        widget.color
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                        FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmallFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleSmallIsCustom,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ].divide(SizedBox(height: 10.0)),
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
