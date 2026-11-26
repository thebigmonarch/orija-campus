import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'explore_see_more_model.dart';
export 'explore_see_more_model.dart';

/// Full grid view of one Explore rail.
class ExploreSeeMoreWidget extends StatefulWidget {
  const ExploreSeeMoreWidget({
    super.key,
    this.section,
  });

  final String? section;

  static String routeName = 'ExploreSeeMore';
  static String routePath = 'explore-see-more';

  @override
  State<ExploreSeeMoreWidget> createState() => _ExploreSeeMoreWidgetState();
}

class _ExploreSeeMoreWidgetState extends State<ExploreSeeMoreWidget> {
  late ExploreSeeMoreModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExploreSeeMoreModel());

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
            child: custom_widgets.OrijaExploreSeeMore(
              section: widget.section,
            ),
          ),
        ),
      ),
    );
  }
}
