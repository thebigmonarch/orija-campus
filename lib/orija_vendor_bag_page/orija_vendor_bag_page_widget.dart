import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'orija_vendor_bag_page_model.dart';
export 'orija_vendor_bag_page_model.dart';

/// Standalone host for the OrijaVendorBag custom widget.
class OrijaVendorBagPageWidget extends StatefulWidget {
  const OrijaVendorBagPageWidget({
    super.key,
    this.bagId,
  });

  final String? bagId;

  static String routeName = 'OrijaVendorBagPage';
  static String routePath = 'orija-vendor-bag';

  @override
  State<OrijaVendorBagPageWidget> createState() =>
      _OrijaVendorBagPageWidgetState();
}

class _OrijaVendorBagPageWidgetState extends State<OrijaVendorBagPageWidget> {
  late OrijaVendorBagPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaVendorBagPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.OrijaVendorBag(
              width: double.infinity,
              height: double.infinity,
              bagId: widget.bagId,
            ),
          ),
        ),
      ),
    );
  }
}
