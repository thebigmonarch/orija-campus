import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'store_listing_component_model.dart';
export 'store_listing_component_model.dart';

class StoreListingComponentWidget extends StatefulWidget {
  const StoreListingComponentWidget({
    super.key,
    required this.section,
  });

  final SectionsMarketStruct? section;

  @override
  State<StoreListingComponentWidget> createState() =>
      _StoreListingComponentWidgetState();
}

class _StoreListingComponentWidgetState
    extends State<StoreListingComponentWidget> {
  late StoreListingComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StoreListingComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        widget.section?.title,
                        'null',
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
                    Text(
                      'See more',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget.section?.subtitle,
                    'null',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
          Builder(
            builder: (context) {
              final storeList = widget.section?.items.toList() ?? [];

              return ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: storeList.length,
                itemBuilder: (context, storeListIndex) {
                  final storeListItem = storeList[storeListIndex];
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
                            storeListItem.slug,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    valueOrDefault<String>(
                                      storeListItem.logo,
                                      'https://picsum.photos/seed/660/600',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        14.0, 0.0, 14.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            storeListItem.name,
                                            'null',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 2.0, 0.0, 0.0),
                                              child: RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: valueOrDefault<
                                                          String>(
                                                        formatNumber(
                                                          storeListItem
                                                              .followerCount,
                                                          formatType: FormatType
                                                              .compact,
                                                        ),
                                                        '0',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodySmall
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmallFamily,
                                                            color: Color(
                                                                0xFF9E7A52),
                                                            fontSize: 13.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmallIsCustom,
                                                          ),
                                                    ),
                                                    TextSpan(
                                                      text: ' Followers · ',
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmallFamily,
                                                        color:
                                                            Color(0xFF9E7A52),
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmallIsCustom,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            RatingBarIndicator(
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                Icons.star_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                              ),
                                              direction: Axis.horizontal,
                                              rating: valueOrDefault<double>(
                                                storeListItem.avgRating,
                                                0.0,
                                              ),
                                              unratedColor:
                                                  FlutterFlowTheme.of(context)
                                                      .accent1,
                                              itemCount: 5,
                                              itemSize: 16.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  fillColor:
                                      FlutterFlowTheme.of(context).secondary,
                                  icon: Icon(
                                    FFIcons.kchat,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.apiResultetx =
                                        await OpenChatStorefrontCall.call(
                                      storeID: storeListItem.id,
                                      userID: currentUserUid,
                                    );

                                    context.pushNamed(
                                      OrijaMessageThreadPageWidget.routeName,
                                      queryParameters: {
                                        'threadId': serializeParam(
                                          OpenChatStorefrontCall.threadid(
                                            (_model.apiResultetx?.jsonBody ??
                                                ''),
                                          ),
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );

                                    safeSetState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (widget.section?.id == 'trending_stores')
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 12.0),
                              child: Builder(
                                builder: (context) {
                                  final listing =
                                      storeListItem.topListings.toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: List.generate(listing.length,
                                              (listingIndex) {
                                        final listingItem =
                                            listing[listingIndex];
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
                                                  listingItem.id,
                                                  ParamType.String,
                                                ),
                                                'storefrontId': serializeParam(
                                                  storeListItem.id,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              valueOrDefault<String>(
                                                listingItem.image,
                                                'https://picsum.photos/seed/941/600',
                                              ),
                                              width: 60.0,
                                              height: 60.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      })
                                          .divide(SizedBox(width: 4.0))
                                          .addToStart(SizedBox(width: 16.0))
                                          .addToEnd(SizedBox(width: 16.0)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (widget.section?.id != 'trending_stores')
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 12.0),
                              child: Builder(
                                builder: (context) {
                                  final listingLatestStore =
                                      storeListItem.latestListings.toList();

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: List.generate(
                                              listingLatestStore.length,
                                              (listingLatestStoreIndex) {
                                        final listingLatestStoreItem =
                                            listingLatestStore[
                                                listingLatestStoreIndex];
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
                                                  listingLatestStoreItem.id,
                                                  ParamType.String,
                                                ),
                                                'storefrontId': serializeParam(
                                                  storeListItem.id,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              valueOrDefault<String>(
                                                listingLatestStoreItem.image,
                                                'https://picsum.photos/seed/941/600',
                                              ),
                                              width: 60.0,
                                              height: 60.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      })
                                          .divide(SizedBox(width: 4.0))
                                          .addToStart(SizedBox(width: 16.0))
                                          .addToEnd(SizedBox(width: 16.0)),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ].divide(SizedBox(height: 10.0)),
      ),
    );
  }
}
