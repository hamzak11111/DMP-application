import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

enum UserRole { None, Doctor, Patient }

class SignupModel extends FlutterFlowModel {
  /// State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  // State field(s) for email, name, date of birth, etc.
  TextEditingController? emailController;
  TextEditingController? nameController;
  TextEditingController? dobController;
  TextEditingController? genderController;
  TextEditingController? passwordController;
  TextEditingController? confirmPasswordController;
  TextEditingController? questionController;
  TextEditingController? answerController;
  TextEditingController? roleController;
  TextEditingController? hospitalIdController; // Doctor-specific
  TextEditingController? employeeIdController; // Doctor-specific
  TextEditingController? specializationController; // Doctor-specific
  TextEditingController? mrNoController; // Patient-specific

  // Validators can be added similarly to the LoginModel
  String? Function(BuildContext, String?)? emailValidator;
  String? Function(BuildContext, String?)? nameValidator;
  String? Function(BuildContext, String?)? passwordValidator;
  String? Function(BuildContext, String?)? confirmPasswordValidator;

  // ... Other validators

  UserRole selectedRole = UserRole.None;

  /// Initialization and disposal methods.
  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    emailController?.dispose();
    nameController?.dispose();
    dobController?.dispose();
    genderController?.dispose();
    passwordController?.dispose();
    confirmPasswordController?.dispose();
    questionController?.dispose();
    answerController?.dispose();
    roleController?.dispose();
    hospitalIdController?.dispose();
    employeeIdController?.dispose();
    specializationController?.dispose();
    mrNoController?.dispose();
  }

  /// Action blocks are added here.
  void setSelectedRole(UserRole role) {
    selectedRole = role;
  }

  /// Additional helper methods are added here.
}
