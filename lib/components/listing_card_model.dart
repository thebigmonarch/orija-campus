import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'listing_card_widget.dart' show ListingCardWidget;
import 'package:flutter/material.dart';

class ListingCardModel extends FlutterFlowModel<ListingCardWidget> {
  ///  Local state fields for this component.

  bool addtoBag = false;

  String? bagId;

  String? itemBageId;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (senddmmessage)] action in Button widget.
  ApiCallResponse? apiResultyyh;
  // Stores action output result for [Backend Call - API (Remove from Bag)] action in Button widget.
  ApiCallResponse? apiResult4xfz;
  // Stores action output result for [Backend Call - API (Add to bag)] action in Button widget.
  ApiCallResponse? apiResult8q52;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
