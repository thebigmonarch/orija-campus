import '/components/listing_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'listing_market_place_widget.dart' show ListingMarketPlaceWidget;
import 'package:flutter/material.dart';

class ListingMarketPlaceModel
    extends FlutterFlowModel<ListingMarketPlaceWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for listingCard dynamic component.
  late FlutterFlowDynamicModels<ListingCardModel> listingCardModels;

  @override
  void initState(BuildContext context) {
    listingCardModels = FlutterFlowDynamicModels(() => ListingCardModel());
  }

  @override
  void dispose() {
    listingCardModels.dispose();
  }
}
