import '/components/info_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'editable_section_child2_model.dart';
export 'editable_section_child2_model.dart';

class EditableSectionChild2Widget extends StatefulWidget {
  const EditableSectionChild2Widget({
    super.key,
    required this.state,
    required this.city,
    required this.fullAddress,
  });

  final String? state;
  final String? city;
  final String? fullAddress;

  @override
  State<EditableSectionChild2Widget> createState() =>
      _EditableSectionChild2WidgetState();
}

class _EditableSectionChild2WidgetState
    extends State<EditableSectionChild2Widget> {
  late EditableSectionChild2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditableSectionChild2Model());

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
              Icons.map_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            label: 'State',
            value: widget.state,
          ),
        ),
        wrapWithModel(
          model: _model.infoFieldModel2,
          updateCallback: () => safeSetState(() {}),
          child: InfoFieldWidget(
            icon: Icon(
              Icons.location_city_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            label: 'City / LGA',
            value: widget.city,
          ),
        ),
        wrapWithModel(
          model: _model.infoFieldModel3,
          updateCallback: () => safeSetState(() {}),
          child: InfoFieldWidget(
            icon: Icon(
              Icons.location_on_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            label: 'Full Address',
            value: widget.fullAddress,
          ),
        ),
      ].divide(SizedBox(height: 10.0)),
    );
  }
}
