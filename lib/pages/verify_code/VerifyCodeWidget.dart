// 6-Digit Code Input Screen
import 'package:dio/dio.dart';
import 'package:dmp_app/pages/reset_password/ResetPasswordWidget.dart';
import 'package:dmp_app/urls.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  @override
  _CodeInputWidgetState createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void verifyCode() async {
    try {
      var response = await Dio().post(VERIFY_CODE_URL, data: {
        'pin': _codeController.text,
      });

      if (response.data['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResetPasswordWidget(pin: _codeController.text),
          ),
        );
      } else {
        // Display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['msg'])),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Color(0xFF01B8E0),
        title: Text(
          'Verify Code',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'DM Sans',
                color: Color(0xFFF9FBFF),
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the 6-digit code sent to your email',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: '6-Digit Code',
                  labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                ),
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'DM Sans',
                    ),
              ),
              SizedBox(height: 20.0),
              FFButtonWidget(
                onPressed: verifyCode,
                text: 'Verify Code',
                options: FFButtonOptions(
                  width: 150.0,
                  height: 60.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: Color(0xFF01B8E0),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'DM Sans',
                        color: Colors.white,
                        fontSize: 18.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
