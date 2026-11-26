import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'storefront_page_model.dart';
export 'storefront_page_model.dart';

class StorefrontPageWidget extends StatefulWidget {
  const StorefrontPageWidget({
    super.key,
    this.storefontslug,
  });

  final String? storefontslug;

  static String routeName = 'storefrontPage';
  static String routePath = 'storefrontPage';

  @override
  State<StorefrontPageWidget> createState() => _StorefrontPageWidgetState();
}

class _StorefrontPageWidgetState extends State<StorefrontPageWidget> {
  late StorefrontPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StorefrontPageModel());

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
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: Container(
            child: custom_widgets.OrijaStorefront(
              storefrontSlug: widget.storefontslug,
            ),
          ),
        ),
      ),
    );
  }
}
