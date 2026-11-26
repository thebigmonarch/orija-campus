import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'create_bid_listing_model.dart';
export 'create_bid_listing_model.dart';

/// DSL page createBidListing
class CreateBidListingWidget extends StatefulWidget {
  const CreateBidListingWidget({super.key});

  static String routeName = 'createBidListing';
  static String routePath = 'create-bid-listing';

  @override
  State<CreateBidListingWidget> createState() => _CreateBidListingWidgetState();
}

class _CreateBidListingWidgetState extends State<CreateBidListingWidget> {
  late CreateBidListingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateBidListingModel());

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
            child: custom_widgets.OrijaCreateBidListing(),
          ),
        ),
      ),
    );
  }
}
