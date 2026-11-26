import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'listlng_page_model.dart';
export 'listlng_page_model.dart';

class ListlngPageWidget extends StatefulWidget {
  const ListlngPageWidget({
    super.key,
    required this.suvcategorySlug,
    this.communityID,
    required this.name,
    required this.type,
  });

  final String? suvcategorySlug;
  final String? communityID;
  final String? name;
  final String? type;

  static String routeName = 'listlngPage';
  static String routePath = 'listlngPage';

  @override
  State<ListlngPageWidget> createState() => _ListlngPageWidgetState();
}

class _ListlngPageWidgetState extends State<ListlngPageWidget> {
  late ListlngPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListlngPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.stateOut = await StatesTable().queryRows(
        queryFn: (q) => q,
      );
      _model.state =
          _model.stateOut!.map((e) => e.name).toList().toList().cast<String>();
      safeSetState(() {});
    });

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
            child: custom_widgets.OrijaListingBrowse(
              communityId: widget.communityID,
              subcategorySlug: widget.suvcategorySlug,
              title: widget.name,
              type: widget.type,
            ),
          ),
        ),
      ),
    );
  }
}
