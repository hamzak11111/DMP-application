import 'package:dio/dio.dart';
import 'package:dmp_app/urls.dart';
import 'package:dmp_app/pages/security_question/security_question_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'forget_password_model.dart';
export 'forget_password_model.dart';

class ForgetPasswordWidget extends StatefulWidget {
  const ForgetPasswordWidget({Key? key}) : super(key: key);

  @override
  _ForgetPasswordWidgetState createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends State<ForgetPasswordWidget> {
  late ForgetPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ForgetPasswordModel());

    _model.emailAddressController ??= TextEditingController(text: '');
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void getSecurityQuestion() async {
    // if (_model.emailAddressController.text.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         'Email required!',
    //       ),
    //     ),
    //   );
    //   return;
    // }

    var res;
    try {
      res = await Dio().post(SECURITY_QUESTION_URL, data: {
        "email": _model.emailAddressController.text.toString(),
      });
    } catch (e) {
      print(e);
    }

    if (res.data['success']) {
      print(res.data['securityQuestion']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecurityQuestionWidget(
                    question: res.data['securityQuestion'],
                    email: _model.emailAddressController.text.toString(),
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // const Text("Error 101!",
                  //     style: TextStyle(
                  //         fontSize: 20,
                  //         color: Colors.white)),
                  Text(
                    res.data['msg'],
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFF01B8E0),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFFF9FBFF),
              size: 30.0,
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Forgot Password',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'DM Sans',
                  color: Color(0xFFF9FBFF),
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
                child: TextFormField(
                  controller: _model.emailAddressController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                    hintText: 'Your email..',
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                  ),
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'DM Sans',
                      ),
                  validator: _model.emailAddressControllerValidator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        'We will send you an email with a link to reset your password, please enter the email associated with your account above.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'DM Sans',
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.05),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    showLoadingIndicator: true,
                    onPressed: () async {
                      getSecurityQuestion();
                    },
                    text: 'Next',
                    options: FFButtonOptions(
                      width: 340.0,
                      height: 60.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Color(0xFF01B8E0),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'DM Sans',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                      elevation: 2.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
