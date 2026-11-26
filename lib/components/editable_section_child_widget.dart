import '/components/info_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'editable_section_child_model.dart';
export 'editable_section_child_model.dart';

class EditableSectionChildWidget extends StatefulWidget {
  const EditableSectionChildWidget({
    super.key,
    String? communityName,
    required this.description,
  }) : this.communityName = communityName ?? 'The Arena Market, Oshodi';

  final String communityName;
  final String? description;

  @override
  State<EditableSectionChildWidget> createState() =>
      _EditableSectionChildWidgetState();
}

class _EditableSectionChildWidgetState
    extends State<EditableSectionChildWidget> {
  late EditableSectionChildModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditableSectionChildModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        wrapWithModel(
          model: _model.infoFieldModel1,
          updateCallback: () => safeSetState(() {}),
          child: InfoFieldWidget(
            icon: Icon(
              Icons.store_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            label: 'Market Name',
            value: widget.communityName,
          ),
        ),
        wrapWithModel(
          model: _model.infoFieldModel2,
          updateCallback: () => safeSetState(() {}),
          child: InfoFieldWidget(
            icon: Icon(
              Icons.description_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            label: 'Description',
            value: widget.description,
          ),
        ),
      ].divide(SizedBox(height: 10.0)),
    );
  }
}
