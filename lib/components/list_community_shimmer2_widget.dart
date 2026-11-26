import '/components/community_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'list_community_shimmer2_model.dart';
export 'list_community_shimmer2_model.dart';

class ListCommunityShimmer2Widget extends StatefulWidget {
  const ListCommunityShimmer2Widget({super.key});

  @override
  State<ListCommunityShimmer2Widget> createState() =>
      _ListCommunityShimmer2WidgetState();
}

class _ListCommunityShimmer2WidgetState
    extends State<ListCommunityShimmer2Widget> {
  late ListCommunityShimmer2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListCommunityShimmer2Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          wrapWithModel(
            model: _model.communityShimmerModel1,
            updateCallback: () => safeSetState(() {}),
            child: CommunityShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.communityShimmerModel2,
            updateCallback: () => safeSetState(() {}),
            child: CommunityShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.communityShimmerModel3,
            updateCallback: () => safeSetState(() {}),
            child: CommunityShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.communityShimmerModel4,
            updateCallback: () => safeSetState(() {}),
            child: CommunityShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.communityShimmerModel5,
            updateCallback: () => safeSetState(() {}),
            child: CommunityShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.communityShimmerModel6,
            updateCallback: () => safeSetState(() {}),
            child: CommunityShimmerWidget(),
          ),
        ].divide(SizedBox(height: 10.0)),
      ),
    );
  }
}
