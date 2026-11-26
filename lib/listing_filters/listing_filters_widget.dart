import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'listing_filters_model.dart';
export 'listing_filters_model.dart';

/// Full filters for browsing goods and services.
class ListingFiltersWidget extends StatefulWidget {
  const ListingFiltersWidget({
    super.key,
    this.filters,
  });

  final String? filters;

  static String routeName = 'listingFilters';
  static String routePath = 'listingFilters';

  @override
  State<ListingFiltersWidget> createState() => _ListingFiltersWidgetState();
}

class _ListingFiltersWidgetState extends State<ListingFiltersWidget> {
  late ListingFiltersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListingFiltersModel());

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
            child: custom_widgets.OrijaListingFilters(
              filters: widget.filters,
            ),
          ),
        ),
      ),
    );
  }
}
