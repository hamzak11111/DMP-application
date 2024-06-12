import 'package:dio/dio.dart';
import 'package:dmp_app/pages/verify_code/VerifyCodeWidget.dart';
import 'package:dmp_app/urls.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'security_question_model.dart';
export 'security_question_model.dart';

class SecurityQuestionWidget extends StatefulWidget {
  final String question;
  final String email;

  const SecurityQuestionWidget(
      {Key? key, required this.question, required this.email})
      : super(key: key);

  @override
  _SecurityQuestionWidgetState createState() => _SecurityQuestionWidgetState();
}

class _SecurityQuestionWidgetState extends State<SecurityQuestionWidget> {
  late SecurityQuestionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SecurityQuestionModel());

    _model.questionController ??= TextEditingController(text: widget.question);
    _model.answerController ??= TextEditingController(text: "");
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void verifyAnswer() async {
    print(_model.answerController.text.toString());
    if (_model.answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Answer required!',
          ),
        ),
      );
      return;
    }
    var res;
    try {
      res = await Dio().post(SECURITY_ANSWER_URL, data: {
        'email': widget.email,
        'securityAnswer': _model.answerController.text.toString()
      });

      if (res.data['success']) {
        res = await Dio().post(FORGOT_PASSWORD_URL, data: {
          "email": widget.email.toString(),
        });
        if (res.data['success']) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CodeInputWidget(),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.data['msg']),
            ),
          );
        }

        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res.data['msg']),
        ));
      }
    } catch (e) {
      print(e);
    }

    return;
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
                  readOnly: true,
                  controller: _model.questionController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Security Question',
                    labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                    hintText: 'Your question..',
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
                  validator:
                      _model.questionControllerValidator.asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
                child: TextFormField(
                  controller: _model.answerController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Security Answer',
                    labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                    hintText: 'Your answer..',
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
                  validator:
                      _model.answerControllerValidator.asValidator(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        'We need you to verify your identity by providing answer to the security Question.',
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
                      verifyAnswer();
                    },
                    text: 'Verify',
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
