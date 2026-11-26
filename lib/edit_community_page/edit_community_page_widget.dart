import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'edit_community_page_model.dart';
export 'edit_community_page_model.dart';

/// Edit-community form, head-only.
class EditCommunityPageWidget extends StatefulWidget {
  const EditCommunityPageWidget({
    super.key,
    this.communityId,
  });

  final String? communityId;

  static String routeName = 'EditCommunityPage';
  static String routePath = 'editCommunity';

  @override
  State<EditCommunityPageWidget> createState() =>
      _EditCommunityPageWidgetState();
}

class _EditCommunityPageWidgetState extends State<EditCommunityPageWidget> {
  late EditCommunityPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditCommunityPageModel());

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
            child: custom_widgets.OrijaEditCommunity(
              communityId: widget.communityId,
            ),
          ),
        ),
      ),
    );
  }
}
