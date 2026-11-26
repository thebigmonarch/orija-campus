import '/components/feedcomponent_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'list_feed_shimmer_model.dart';
export 'list_feed_shimmer_model.dart';

class ListFeedShimmerWidget extends StatefulWidget {
  const ListFeedShimmerWidget({super.key});

  @override
  State<ListFeedShimmerWidget> createState() => _ListFeedShimmerWidgetState();
}

class _ListFeedShimmerWidgetState extends State<ListFeedShimmerWidget> {
  late ListFeedShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListFeedShimmerModel());

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
              model: _model.feedcomponentShimmerModel1,
              updateCallback: () => safeSetState(() {}),
              child: FeedcomponentShimmerWidget(),
            ),
            wrapWithModel(
              model: _model.feedcomponentShimmerModel2,
              updateCallback: () => safeSetState(() {}),
              child: FeedcomponentShimmerWidget(),
            ),
            wrapWithModel(
              model: _model.feedcomponentShimmerModel3,
              updateCallback: () => safeSetState(() {}),
              child: FeedcomponentShimmerWidget(),
            ),
            wrapWithModel(
              model: _model.feedcomponentShimmerModel4,
              updateCallback: () => safeSetState(() {}),
              child: FeedcomponentShimmerWidget(),
            ),
          ].divide(SizedBox(height: 26.0)),
        ),
      ),
    );
  }
}
