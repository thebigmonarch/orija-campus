import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'select_storefront_model.dart';
export 'select_storefront_model.dart';

class SelectStorefrontWidget extends StatefulWidget {
  const SelectStorefrontWidget({
    super.key,
    required this.postID,
    required this.userID,
    this.width,
  });

  final String? postID;
  final String? userID;
  final double? width;

  @override
  State<SelectStorefrontWidget> createState() => _SelectStorefrontWidgetState();
}

class _SelectStorefrontWidgetState extends State<SelectStorefrontWidget> {
  late SelectStorefrontModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectStorefrontModel());

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
      width: widget.width,
      height: widget.width,
      child: custom_widgets.OrijaSelectStorefront(
        width: widget.width,
        height: widget.width,
        postID: widget.postID,
        userID: widget.userID,
      ),
    );
  }
}
