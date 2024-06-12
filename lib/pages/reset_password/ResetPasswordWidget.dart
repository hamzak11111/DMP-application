import 'package:dio/dio.dart';
import 'package:dmp_app/pages/login/login_page.dart';
import 'package:dmp_app/urls.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class ResetPasswordWidget extends StatefulWidget {
  final String pin;

  ResetPasswordWidget({required this.pin});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordWidget> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    try {
      final Dio dio = Dio();

      final response = await dio.patch(
        RESET_PASSWORD_URL, // Replace this with the actual endpoint
        data: {
          'pin': widget.pin,
          'password': _passwordController.text,
        },
      );

      if (response.data['success']) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Password reset successfully'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    ); // Navigate back to the login screen
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['msg'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resetting password')),
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
          'Reset Password',
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
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Hide password
                decoration: InputDecoration(
                  labelText: 'New Password',
                  // ... Other styles similar to your 6-digit code input
                ),
                // ... Styling and other properties
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true, // Hide password
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  // ... Other styles similar to your 6-digit code input
                ),
                // ... Styling and other properties
              ),
              SizedBox(height: 20.0),
              FFButtonWidget(
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
                onPressed: resetPassword,
                text: 'Confirm Reset',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
