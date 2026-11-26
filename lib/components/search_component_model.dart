import '/components/listing_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/storefront/storefront_component/storefront_component_widget.dart';
import 'search_component_widget.dart' show SearchComponentWidget;
import 'package:flutter/material.dart';

class SearchComponentModel extends FlutterFlowModel<SearchComponentWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Models for listingCard dynamic component.
  late FlutterFlowDynamicModels<ListingCardModel> listingCardModels;
  // Models for storefrontComponent dynamic component.
  late FlutterFlowDynamicModels<StorefrontComponentModel>
      storefrontComponentModels;

  @override
  void initState(BuildContext context) {
    listingCardModels = FlutterFlowDynamicModels(() => ListingCardModel());
    storefrontComponentModels =
        FlutterFlowDynamicModels(() => StorefrontComponentModel());
  }

  @override
  void dispose() {
    listingCardModels.dispose();
    storefrontComponentModels.dispose();
  }
}
