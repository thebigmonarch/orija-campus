import '/components/info_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'editable_section_child_widget.dart' show EditableSectionChildWidget;
import 'package:flutter/material.dart';

class EditableSectionChildModel
    extends FlutterFlowModel<EditableSectionChildWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for InfoField.
  late InfoFieldModel infoFieldModel1;
  // Model for InfoField.
  late InfoFieldModel infoFieldModel2;

  @override
  void initState(BuildContext context) {
    infoFieldModel1 = createModel(context, () => InfoFieldModel());
    infoFieldModel2 = createModel(context, () => InfoFieldModel());
  }

  @override
  void dispose() {
    infoFieldModel1.dispose();
    infoFieldModel2.dispose();
  }
}
