import '/components/community_component_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'list_community_shimmer_model.dart';
export 'list_community_shimmer_model.dart';

class ListCommunityShimmerWidget extends StatefulWidget {
  const ListCommunityShimmerWidget({super.key});

  @override
  State<ListCommunityShimmerWidget> createState() =>
      _ListCommunityShimmerWidgetState();
}

class _ListCommunityShimmerWidgetState
    extends State<ListCommunityShimmerWidget> {
  late ListCommunityShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListCommunityShimmerModel());

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 0.0, 0.0),
            child: Container(
              width: 100.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        wrapWithModel(
                          model: _model.communityComponentShimmerModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: CommunityComponentShimmerWidget(),
                        ),
                        wrapWithModel(
                          model: _model.communityComponentShimmerModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: CommunityComponentShimmerWidget(),
                        ),
                      ].divide(SizedBox(width: 10.0)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        wrapWithModel(
                          model: _model.communityComponentShimmerModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: CommunityComponentShimmerWidget(),
                        ),
                        wrapWithModel(
                          model: _model.communityComponentShimmerModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: CommunityComponentShimmerWidget(),
                        ),
                      ].divide(SizedBox(width: 10.0)),
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              ]
                  .addToStart(SizedBox(width: 16.0))
                  .addToEnd(SizedBox(width: 16.0)),
            ),
          ),
        ].divide(SizedBox(height: 16.0)),
      ),
    );
  }
}
