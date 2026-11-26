import '/backend/schema/structs/index.dart';
import '/component/community_component_search/community_component_search_widget.dart';
import '/components/listing_card_widget.dart';
import '/emptystate/community_empty_state/community_empty_state_widget.dart';
import '/emptystate/listing_empty_state2/listing_empty_state2_widget.dart';
import '/emptystate/post_empty_state/post_empty_state_widget.dart';
import '/emptystate/storefront_empty_state/storefront_empty_state_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/storefront/storefront_component/storefront_component_widget.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'search_component_model.dart';
export 'search_component_model.dart';

class SearchComponentWidget extends StatefulWidget {
  const SearchComponentWidget({
    super.key,
    required this.searchpath,
  });

  final SearchItemsStruct? searchpath;

  @override
  State<SearchComponentWidget> createState() => _SearchComponentWidgetState();
}

class _SearchComponentWidgetState extends State<SearchComponentWidget> {
  late SearchComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchComponentModel());

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: FlutterFlowChoiceChips(
                          options: [
                            ChipData('Posts'),
                            ChipData('Communities'),
                            ChipData('Storefronts'),
                            ChipData('Listings')
                          ],
                          onChanged: (val) => safeSetState(
                              () => _model.choiceChipsValue = val?.firstOrNull),
                          selectedChipStyle: ChipStyle(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            iconColor: FlutterFlowTheme.of(context).info,
                            iconSize: 16.0,
                            elevation: 0.0,
                            borderColor: FlutterFlowTheme.of(context).primary,
                            borderWidth: 1.0,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            iconColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            iconSize: 16.0,
                            elevation: 0.0,
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          chipSpacing: 8.0,
                          rowSpacing: 8.0,
                          multiselect: false,
                          initialized: _model.choiceChipsValue != null,
                          alignment: WrapAlignment.start,
                          controller: _model.choiceChipsValueController ??=
                              FormFieldController<List<String>>(
                            ['Posts'],
                          ),
                          wrapped: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if (_model.choiceChipsValue == 'Listings') {
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final listing =
                            widget.searchpath?.listings.items.toList() ?? [];
                        if (listing.isEmpty) {
                          return ListingEmptyState2Widget();
                        }

                        return MasonryGridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          itemCount: listing.length,
                          shrinkWrap: true,
                          itemBuilder: (context, listingIndex) {
                            final listingItem = listing[listingIndex];
                            return wrapWithModel(
                              model: _model.listingCardModels.getModel(
                                listingItem.id,
                                listingIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: ListingCardWidget(
                                key: Key(
                                  'Keym9q_${listingItem.id}',
                                ),
                                listingID: listingItem.id,
                                storefrontslug: listingItem.storefrontSlug,
                                isSend: false,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (_model.choiceChipsValue == 'Posts') {
                  return Builder(
                    builder: (context) {
                      final postList =
                          widget.searchpath?.posts.items.toList() ?? [];
                      if (postList.isEmpty) {
                        return PostEmptyStateWidget();
                      }

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          childAspectRatio: 0.6,
                        ),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: postList.length,
                        itemBuilder: (context, postListIndex) {
                          final postListItem = postList[postListIndex];
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                ViewPostWidget.routeName,
                                queryParameters: {
                                  'postID': serializeParam(
                                    postListItem.id,
                                    ParamType.String,
                                  ),
                                  'postType': serializeParam(
                                    postListItem.type,
                                    ParamType.String,
                                  ),
                                  'storeID': serializeParam(
                                    postListItem.storefrontId,
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: custom_widgets.SocialMediaMediaPlayer(
                                width: double.infinity,
                                height: double.infinity,
                                mediaUrl: valueOrDefault<String>(
                                  postListItem.mediaUrls.firstOrNull,
                                  'https://picsum.photos/seed/625/600',
                                ),
                                autoPlay: true,
                                showMuteButton: false,
                                initialMute: true,
                                loopVideo: true,
                                fit: 'cover',
                                enableZoomForImages: false,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (_model.choiceChipsValue == 'Storefronts') {
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final storeList =
                            widget.searchpath?.storefronts.items.toList() ??
                                [];
                        if (storeList.isEmpty) {
                          return StorefrontEmptyStateWidget();
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: storeList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.0),
                          itemBuilder: (context, storeListIndex) {
                            final storeListItem = storeList[storeListIndex];
                            return wrapWithModel(
                              model: _model.storefrontComponentModels.getModel(
                                storeListItem.id,
                                storeListIndex,
                              ),
                              updateCallback: () => safeSetState(() {}),
                              child: StorefrontComponentWidget(
                                key: Key(
                                  'Keyye7_${storeListItem.id}',
                                ),
                                storefrontID: storeListItem.id,
                                logo: storeListItem.logoUrl,
                                name: storeListItem.name,
                                isVerified: storeListItem.isVerified,
                                discription: storeListItem.description,
                                rating: storeListItem.avgRating.toString(),
                                slug: storeListItem.slug,
                                isEdit: false,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final communitiesList =
                            widget.searchpath?.communities.items.toList() ??
                                [];
                        if (communitiesList.isEmpty) {
                          return CommunityEmptyStateWidget();
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: communitiesList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.0),
                          itemBuilder: (context, communitiesListIndex) {
                            final communitiesListItem =
                                communitiesList[communitiesListIndex];
                            return CommunityComponentSearchWidget(
                              key: Key(
                                  'Keyfpm_${communitiesListIndex}_of_${communitiesList.length}'),
                              communityId: communitiesListItem.id,
                              isLink: false,
                              storeID: '',
                              imageUrl: communitiesListItem.coverUrl,
                              name: communitiesListItem.name,
                              members: communitiesListItem.memberCount,
                              discription: communitiesListItem.description,
                              communitySlug: communitiesListItem.slug,
                              isJoined: communitiesListItem.isJoined,
                              memberView: communitiesListItem.memberPreview,
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ].addToEnd(SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}
