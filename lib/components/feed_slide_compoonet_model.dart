import '/components/ask_component_widget.dart';
import '/components/listing_card_widget.dart';
import '/components/storefront_component2_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'feed_slide_compoonet_widget.dart' show FeedSlideCompoonetWidget;
import 'package:flutter/material.dart';

class FeedSlideCompoonetModel
    extends FlutterFlowModel<FeedSlideCompoonetWidget> {
  ///  Local state fields for this component.

  bool? isTapped = false;

  bool? isLike = false;

  bool? isReshare = false;

  bool? isSaved = false;

  bool? isFollow = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Models for storefrontComponent2 dynamic component.
  late FlutterFlowDynamicModels<StorefrontComponent2Model>
      storefrontComponent2Models;
  // Model for askComponent component.
  late AskComponentModel askComponentModel;
  // Models for listingCard dynamic component.
  late FlutterFlowDynamicModels<ListingCardModel> listingCardModels;

  @override
  void initState(BuildContext context) {
    storefrontComponent2Models =
        FlutterFlowDynamicModels(() => StorefrontComponent2Model());
    askComponentModel = createModel(context, () => AskComponentModel());
    listingCardModels = FlutterFlowDynamicModels(() => ListingCardModel());
  }

  @override
  void dispose() {
    storefrontComponent2Models.dispose();
    askComponentModel.dispose();
    listingCardModels.dispose();
  }
}
