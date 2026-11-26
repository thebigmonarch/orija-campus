import '/components/community_component_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'list_community_shimmer_widget.dart' show ListCommunityShimmerWidget;
import 'package:flutter/material.dart';

class ListCommunityShimmerModel
    extends FlutterFlowModel<ListCommunityShimmerWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for communityComponentShimmer component.
  late CommunityComponentShimmerModel communityComponentShimmerModel1;
  // Model for communityComponentShimmer component.
  late CommunityComponentShimmerModel communityComponentShimmerModel2;
  // Model for communityComponentShimmer component.
  late CommunityComponentShimmerModel communityComponentShimmerModel3;
  // Model for communityComponentShimmer component.
  late CommunityComponentShimmerModel communityComponentShimmerModel4;

  @override
  void initState(BuildContext context) {
    communityComponentShimmerModel1 =
        createModel(context, () => CommunityComponentShimmerModel());
    communityComponentShimmerModel2 =
        createModel(context, () => CommunityComponentShimmerModel());
    communityComponentShimmerModel3 =
        createModel(context, () => CommunityComponentShimmerModel());
    communityComponentShimmerModel4 =
        createModel(context, () => CommunityComponentShimmerModel());
  }

  @override
  void dispose() {
    communityComponentShimmerModel1.dispose();
    communityComponentShimmerModel2.dispose();
    communityComponentShimmerModel3.dispose();
    communityComponentShimmerModel4.dispose();
  }
}
