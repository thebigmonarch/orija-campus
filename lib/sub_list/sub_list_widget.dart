import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'sub_list_model.dart';
export 'sub_list_model.dart';

class SubListWidget extends StatefulWidget {
  const SubListWidget({
    super.key,
    required this.name,
    required this.categorySlug,
    this.communitySlug,
    this.communityID,
  });

  final String? name;
  final String? categorySlug;
  final String? communitySlug;
  final String? communityID;

  static String routeName = 'SubList';
  static String routePath = 'subList';

  @override
  State<SubListWidget> createState() => _SubListWidgetState();
}

class _SubListWidgetState extends State<SubListWidget> {
  late SubListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubListModel());

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
            child: custom_widgets.OrijaSubList(
              categorySlug: widget.categorySlug,
              communityID: widget.communityID,
              displayName: widget.name,
            ),
          ),
        ),
      ),
    );
  }
}
