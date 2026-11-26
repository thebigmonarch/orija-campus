import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'approval_card2_widget.dart' show ApprovalCard2Widget;
import 'package:flutter/material.dart';

class ApprovalCard2Model extends FlutterFlowModel<ApprovalCard2Widget> {
  ///  Local state fields for this component.

  bool? ifRegert = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (market head review storefront)] action in Button widget.
  ApiCallResponse? approveStore;
  // Stores action output result for [Backend Call - API (market head review storefront)] action in Button widget.
  ApiCallResponse? apiResultbxb;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
