import '/flutter_flow/flutter_flow_util.dart';
import '/storefront/storefront_shimmer_new/storefront_shimmer_new_widget.dart';
import 'package:flutter/material.dart';
import 'list_storefront_shimmer_model.dart';
export 'list_storefront_shimmer_model.dart';

class ListStorefrontShimmerWidget extends StatefulWidget {
  const ListStorefrontShimmerWidget({super.key});

  @override
  State<ListStorefrontShimmerWidget> createState() =>
      _ListStorefrontShimmerWidgetState();
}

class _ListStorefrontShimmerWidgetState
    extends State<ListStorefrontShimmerWidget> {
  late ListStorefrontShimmerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListStorefrontShimmerModel());

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
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          wrapWithModel(
            model: _model.storefrontShimmerNewModel1,
            updateCallback: () => safeSetState(() {}),
            child: StorefrontShimmerNewWidget(),
          ),
          wrapWithModel(
            model: _model.storefrontShimmerNewModel2,
            updateCallback: () => safeSetState(() {}),
            child: StorefrontShimmerNewWidget(),
          ),
          wrapWithModel(
            model: _model.storefrontShimmerNewModel3,
            updateCallback: () => safeSetState(() {}),
            child: StorefrontShimmerNewWidget(),
          ),
          wrapWithModel(
            model: _model.storefrontShimmerNewModel4,
            updateCallback: () => safeSetState(() {}),
            child: StorefrontShimmerNewWidget(),
          ),
          wrapWithModel(
            model: _model.storefrontShimmerNewModel5,
            updateCallback: () => safeSetState(() {}),
            child: StorefrontShimmerNewWidget(),
          ),
        ]
            .divide(SizedBox(width: 10.0))
            .addToStart(SizedBox(width: 16.0))
            .addToEnd(SizedBox(width: 16.0)),
      ),
    );
  }
}
