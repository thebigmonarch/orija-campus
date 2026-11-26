import '/components/chat_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'list_chat_component_model.dart';
export 'list_chat_component_model.dart';

class ListChatComponentWidget extends StatefulWidget {
  const ListChatComponentWidget({super.key});

  @override
  State<ListChatComponentWidget> createState() =>
      _ListChatComponentWidgetState();
}

class _ListChatComponentWidgetState extends State<ListChatComponentWidget> {
  late ListChatComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListChatComponentModel());

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
        children: [
          wrapWithModel(
            model: _model.chatShimmerModel1,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.chatShimmerModel2,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.chatShimmerModel3,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.chatShimmerModel4,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.chatShimmerModel5,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.chatShimmerModel6,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.chatShimmerModel7,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
          wrapWithModel(
            model: _model.chatShimmerModel8,
            updateCallback: () => safeSetState(() {}),
            child: ChatShimmerWidget(),
          ),
        ],
      ),
    );
  }
}
