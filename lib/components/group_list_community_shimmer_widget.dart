import '/components/list_community_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'group_list_community_shimmer_model.dart';
export 'group_list_community_shimmer_model.dart';

class GroupListCommunityShimmerWidget extends StatefulWidget {
  const GroupListCommunityShimmerWidget({super.key});

  @override
  State<GroupListCommunityShimmerWidget> createState() =>
      _GroupListCommunityShimmerWidgetState();
}

class _GroupListCommunityShimmerWidgetState
    extends State<GroupListCommunityShimmerWidget> {
  late GroupListCommunityShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupListCommunityShimmerModel());

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
          children: [
            wrapWithModel(
              model: _model.listCommunityShimmerModel1,
              updateCallback: () => safeSetState(() {}),
              child: ListCommunityShimmerWidget(),
            ),
            wrapWithModel(
              model: _model.listCommunityShimmerModel2,
              updateCallback: () => safeSetState(() {}),
              child: ListCommunityShimmerWidget(),
            ),
            wrapWithModel(
              model: _model.listCommunityShimmerModel3,
              updateCallback: () => safeSetState(() {}),
              child: ListCommunityShimmerWidget(),
            ),
            wrapWithModel(
              model: _model.listCommunityShimmerModel4,
              updateCallback: () => safeSetState(() {}),
              child: ListCommunityShimmerWidget(),
            ),
            wrapWithModel(
              model: _model.listCommunityShimmerModel5,
              updateCallback: () => safeSetState(() {}),
              child: ListCommunityShimmerWidget(),
            ),
          ].divide(SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}
