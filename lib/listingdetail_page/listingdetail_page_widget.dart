import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'listingdetail_page_model.dart';
export 'listingdetail_page_model.dart';

class ListingdetailPageWidget extends StatefulWidget {
  const ListingdetailPageWidget({
    super.key,
    this.listingId,
    this.storefrontId,
  });

  final String? listingId;
  final String? storefrontId;

  static String routeName = 'listingdetailPage';
  static String routePath = 'listingdetailPage';

  @override
  State<ListingdetailPageWidget> createState() =>
      _ListingdetailPageWidgetState();
}

class _ListingdetailPageWidgetState extends State<ListingdetailPageWidget> {
  late ListingdetailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListingdetailPageModel());

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
        body: Container(
          child: custom_widgets.OrijaListingDetail(
            listingId: widget.listingId,
            storefrontId: widget.storefrontId,
          ),
        ),
      ),
    );
  }
}
