import '/components/shimmer_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'chat_shimmer_model.dart';
export 'chat_shimmer_model.dart';

class ChatShimmerWidget extends StatefulWidget {
  const ChatShimmerWidget({super.key});

  @override
  State<ChatShimmerWidget> createState() => _ChatShimmerWidgetState();
}

class _ChatShimmerWidgetState extends State<ChatShimmerWidget> {
  late ChatShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatShimmerModel());

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
      height: 64.0,
      decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Container(
                width: 46.0,
                height: 46.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.circle,
                ),
                child: wrapWithModel(
                  model: _model.shimmerModel1,
                  updateCallback: () => safeSetState(() {}),
                  child: ShimmerWidget(),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 130.0,
                          height: 16.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: wrapWithModel(
                            model: _model.shimmerModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: ShimmerWidget(),
                          ),
                        ),
                        Container(
                          width: 60.0,
                          height: 18.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: wrapWithModel(
                            model: _model.shimmerModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: ShimmerWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: wrapWithModel(
                          model: _model.shimmerModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: ShimmerWidget(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 100.0,
                          height: 14.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: wrapWithModel(
                            model: _model.shimmerModel5,
                            updateCallback: () => safeSetState(() {}),
                            child: ShimmerWidget(),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 10.0)),
                  ),
                ].divide(SizedBox(height: 4.0)),
              ),
            ),
          ]
              .divide(SizedBox(width: 10.0))
              .addToStart(SizedBox(width: 16.0))
              .addToEnd(SizedBox(width: 16.0)),
        ),
      ),
    );
  }
}
