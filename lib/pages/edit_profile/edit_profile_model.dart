import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for emailAddress widget.
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;
  // State field(s) for TextField widget.
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  TextEditingController? genderController;
  String? Function(BuildContext, String?)? genderControllerValidator;
  /// Initialization and disposal methods.
  TextEditingController? dobController;
  String? Function(BuildContext, String?)?dobControllerValidator;


  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    textController1?.dispose();
    emailAddressController?.dispose();
    textController3?.dispose();
    genderController?.dispose();
    dobController?.dispose();
    

  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
