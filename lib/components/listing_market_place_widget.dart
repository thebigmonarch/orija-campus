import '/backend/schema/structs/index.dart';
import '/components/listing_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'listing_market_place_model.dart';
export 'listing_market_place_model.dart';

class ListingMarketPlaceWidget extends StatefulWidget {
  const ListingMarketPlaceWidget({
    super.key,
    required this.listingSection,
  });

  final SectionsMarketStruct? listingSection;

  @override
  State<ListingMarketPlaceWidget> createState() =>
      _ListingMarketPlaceWidgetState();
}

class _ListingMarketPlaceWidgetState extends State<ListingMarketPlaceWidget> {
  late ListingMarketPlaceModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListingMarketPlaceModel());

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
                        widget.listingSection?.title,
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
                    widget.listingSection?.subtitle,
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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Builder(
              builder: (context) {
                final listingOut = widget.listingSection?.items
                        .map((e) => e)
                        .toList()
                        .toList() ??
                    [];

                return MasonryGridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  itemCount: listingOut.length,
                  shrinkWrap: true,
                  itemBuilder: (context, listingOutIndex) {
                    final listingOutItem = listingOut[listingOutIndex];
                    return wrapWithModel(
                      model: _model.listingCardModels.getModel(
                        listingOutItem.listingId,
                        listingOutIndex,
                      ),
                      updateCallback: () => safeSetState(() {}),
                      child: ListingCardWidget(
                        key: Key(
                          'Keyh6i_${listingOutItem.listingId}',
                        ),
                        listingID: listingOutItem.listingId,
                        storefrontslug: listingOutItem.storefront.slug,
                        isSend: false,
                        height:
                            functions.getStaggeredCardHeight(listingOutIndex),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ].divide(SizedBox(height: 8.0)),
      ),
    );
  }
}
