import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class SecurityQuestionModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for emailAddress widget.
  TextEditingController? questionController;
  String? Function(BuildContext, String?)? questionControllerValidator;

  TextEditingController? answerController;
  String? Function(BuildContext, String?)? answerControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    answerController?.dispose();
    questionController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
