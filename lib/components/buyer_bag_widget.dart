import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'buyer_bag_model.dart';
export 'buyer_bag_model.dart';

class BuyerBagWidget extends StatefulWidget {
  const BuyerBagWidget({
    super.key,
    this.parameter1,
  });

  final String? parameter1;

  @override
  State<BuyerBagWidget> createState() => _BuyerBagWidgetState();
}

class _BuyerBagWidgetState extends State<BuyerBagWidget> {
  late BuyerBagModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BuyerBagModel());

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
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: MediaQuery.sizeOf(context).height * 1.0,
      child: custom_widgets.OrijaBuyerBag(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: MediaQuery.sizeOf(context).height * 1.0,
        bagId: widget.parameter1,
      ),
    );
  }
}
