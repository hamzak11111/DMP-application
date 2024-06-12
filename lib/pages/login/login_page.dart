import 'package:dio/dio.dart';
import 'package:dmp_app/data/Doctor.dart';
import 'package:dmp_app/data/Patient.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_model.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_theme.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:dmp_app/pages/doctor_home_page/dr_home_page_widget.dart';
import 'package:dmp_app/pages/forget_password/forget_password_widget.dart';
import 'package:dmp_app/pages/home_page/home_page_widget.dart';
import 'package:dmp_app/pages/login/login_model.dart';
import 'package:dmp_app/pages/signup/signup_page.dart';
import 'package:dmp_app/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.emailAddressController ??= TextEditingController(text: '');
    _model.passwordController ??= TextEditingController(text: '');
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String? validate() {
    if (_model.emailAddressController!.text.isEmpty ||
        _model.passwordController!.text.isEmpty) {
      return "All fields are required.";
    }
    if (!RegExp(r'\S+@\S+\.\S+')
        .hasMatch(_model.emailAddressController!.text.toString())) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      var res;
      print('butn pressed');
      try {
        res = await Dio().post(LOGIN_URL, data: {
          "email": _model.emailAddressController?.text.toString(),
          "password": _model.passwordController?.text.toString()
        });
      } catch (e) {
        showValidationMessage(context, e.toString());
      }
      // print(passwordController.text.toString());
      if (res.data['success']) {
        print('logged on succesfully');
        var rest;
        var rolee;
        var token = res.data['token'];
        Dio dio = new Dio();
        print(token);
        dio.options.headers["authorization"] = "Bearer $token";

        try {
          rest = await dio.get(Profile_URL);
        } catch (e) {
          showValidationMessage(context, e.toString());
        }
        print('profile gotten');

        if (rest.data['success']) {
          rolee = rest.data['profile']['role'];
          print(rest.data['profile']);
        } else {
          print(res.data['msg']);
          print('prfile unsecces');
        }

        print("Role:" + rolee.toString());
        if (rolee.toString() == "Doctor") {
          print('doc');
          Doctor doctor;

          try {
            doctor = Doctor.fromJson(rest.data);
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString(
                'userEmail', _model.emailAddressController!.text.toString());
            prefs.setString(
                "userPassword", _model.passwordController!.text.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DrHomePageWidget(
                          token: res.data['token'],
                          decryptPass:
                              _model.passwordController!.text.toString(),
                          doctorProfile: doctor,
                          password: _model.passwordController!.text.toString(),
                        )));
          } catch (e) {
            showValidationMessage(context, e.toString());
          }
        } else if (rolee.toString() == "Patient") {
          Patient patient;
          try {
            patient = Patient.fromJson(rest.data);
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString(
                'userEmail', _model.emailAddressController!.text.toString());
            prefs.setString(
                "userPassword", _model.passwordController!.text.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePageWidget(
                          token: res.data['token'],
                          patientProfile: patient,
                          password: _model.passwordController!.text.toString(),
                          decryptPass:
                              _model.passwordController!.text.toString(),
                        )));
          } catch (e) {
            showValidationMessage(context, e.toString());
          }
        }
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
                    Text(
                      res.data['msg'],
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ))));
        print(res.data['msg']);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 8,
              child: Image.asset(
                    'assets/images/Medical Report Prescription Logo.png', // Replace with your image asset path
                    fit: BoxFit.contain,
                  ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
              child: TextFormField(
                controller: _model.emailAddressController,
                obscureText: false,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.email_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
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
                validator:
                    _model.emailAddressControllerValidator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
              child: TextFormField(
                controller: _model.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.password_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  labelText: 'Password',
                  labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                  hintText: 'Your password..',
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
                    _model.passwordControllerValidator.asValidator(context),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.05),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: FFButtonWidget(
                  showLoadingIndicator: true,
                  onPressed: () async {
                    String? validationMessage = validate();
                    if (validationMessage == null) {
                      await login();
                    } else {
                      showValidationMessage(context, validationMessage);
                    }
                  },
                  text: 'Login',
                  options: FFButtonOptions(
                    width: 340.0,
                    height: 60.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF01B8E0),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPasswordWidget()));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'DM Sans',
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text(
                        'Create an Account',
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'DM Sans',
                              color: FlutterFlowTheme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Spacer(),
            Spacer(),
          ],
        )),
      ),
    );
  }

  void showValidationMessage(BuildContext context, String message) {
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
        child: Text(
          message,
          style: TextStyle(fontSize: 18, color: Colors.white),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }
}
