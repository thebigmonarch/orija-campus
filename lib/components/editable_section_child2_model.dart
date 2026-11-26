import '/components/info_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'editable_section_child2_widget.dart' show EditableSectionChild2Widget;
import 'package:flutter/material.dart';

class EditableSectionChild2Model
    extends FlutterFlowModel<EditableSectionChild2Widget> {
  ///  State fields for stateful widgets in this component.

  // Model for InfoField.
  late InfoFieldModel infoFieldModel1;
  // Model for InfoField.
  late InfoFieldModel infoFieldModel2;
  // Model for InfoField.
  late InfoFieldModel infoFieldModel3;

  @override
  void initState(BuildContext context) {
    infoFieldModel1 = createModel(context, () => InfoFieldModel());
    infoFieldModel2 = createModel(context, () => InfoFieldModel());
    infoFieldModel3 = createModel(context, () => InfoFieldModel());
  }

  @override
  void dispose() {
    infoFieldModel1.dispose();
    infoFieldModel2.dispose();
    infoFieldModel3.dispose();
  }
}
