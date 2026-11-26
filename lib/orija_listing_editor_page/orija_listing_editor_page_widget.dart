import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'orija_listing_editor_page_model.dart';
export 'orija_listing_editor_page_model.dart';

/// Standalone host for the OrijaListingEditor custom widget.
class OrijaListingEditorPageWidget extends StatefulWidget {
  const OrijaListingEditorPageWidget({
    super.key,
    this.listingId,
    this.storefrontId,
  });

  final String? listingId;
  final String? storefrontId;

  static String routeName = 'OrijaListingEditorPage';
  static String routePath = 'orija-listing-editor';

  @override
  State<OrijaListingEditorPageWidget> createState() =>
      _OrijaListingEditorPageWidgetState();
}

class _OrijaListingEditorPageWidgetState
    extends State<OrijaListingEditorPageWidget> {
  late OrijaListingEditorPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrijaListingEditorPageModel());

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
            width: MediaQuery.sizeOf(context).width * 1.0,
            height: MediaQuery.sizeOf(context).height * 1.0,
            child: custom_widgets.OrijaListingEditor(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: MediaQuery.sizeOf(context).height * 1.0,
              listingId: widget.listingId,
              storefrontId: widget.storefrontId,
            ),
          ),
        ),
      ),
    );
  }
}
