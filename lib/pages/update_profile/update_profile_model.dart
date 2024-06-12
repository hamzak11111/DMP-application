import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class UpdateProfileModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  TextEditingController? fullnamecontroller;
  String? Function(BuildContext, String?)? fullnamecontrollerValidator;
  // State field(s) for emailAddress widget.

  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;

  TextEditingController? gendercontroller;
  String? Function(BuildContext, String?)? genderControllerValidator;

  TextEditingController? dobcpontroller;
  String? Function(BuildContext, String?)? dobcpontrollerValidator;

  TextEditingController? passwordController;
  String? Function(BuildContext, String?)? passwordControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    fullnamecontroller?.dispose();
    emailAddressController?.dispose();
    gendercontroller?.dispose();
    dobcpontroller?.dispose();
    passwordController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
