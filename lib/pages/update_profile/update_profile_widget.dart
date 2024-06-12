import 'package:dio/dio.dart';
import 'package:dmp_app/urls.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'update_profile_model.dart';
export 'update_profile_model.dart';

class UpdateProfileWidget extends StatefulWidget {
  final String fullName;
  final String email;
  final String gender;
  final int age;
  final String DOB;
  final String token;
  final String password;

  const UpdateProfileWidget(
      {Key? key,
      required this.fullName,
      required this.email,
      required this.gender,
      required this.age,
      required this.DOB,
      required this.token,
      required this.password})
      : super(key: key);

  @override
  _UpdateProfileWidgetState createState() => _UpdateProfileWidgetState();
}

class _UpdateProfileWidgetState extends State<UpdateProfileWidget> {
  late UpdateProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpdateProfileModel());

    _model.fullnamecontroller ??= TextEditingController(text: widget.fullName);
    _model.emailAddressController ??= TextEditingController(text: widget.email);

    _model.dobcpontroller ??= TextEditingController(text: widget.DOB);
    _model.gendercontroller ??= TextEditingController(text: widget.gender);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  void datePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      String formatedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        _model.dobcpontroller.text = formatedDate;
      });
    } else {
      print("Not Selected");
    }
  }

  @override

  // void getProfile() async {
  //   var res;
  //   String token = widget.token;
  //   Dio dio = new Dio();

  //   dio.options.headers["authorization"] = "Bearer $token";

  //   try {
  //     res = await dio.get(Profile_URL);
  //   } catch (e) {
  //     print(e);
  //   }

  //   if (res.data['success']) {
  //     setState(() {
  //       fullName = res.data['fullName'];
  //       email = res.data['email'];
  //       gender = res.data['gender'];
  //       age = res.data['age'];
  //       dOB = res.data['DOB'];
  //       password = res.data['password'];
  //     });
  //   } else {
  //     print(res.data['msg']);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Theme(
        data: Theme.of(context),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: Color(0xFF01B8E0),
            automaticallyImplyLeading: false,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left_rounded,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                size: 24.0,
              ),
            ),
            title: Text(
              'Your profile',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'DM Sans',
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
                /*Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
                  child: TextFormField(
                    controller: _model.emailAddressController,
                    obscureText: false,
                    //  initialValue:  _model.emailAddressController.text,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'DM Sans',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Text color for dark mode
                              : Colors.black,
                        ),
                    validator: _model.emailAddressControllerValidator
                        .asValidator(context),
                  ),
                ),*/
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                  child: TextFormField(
                    controller: _model.fullnamecontroller,
                    obscureText: false,
                    //initialValue: _model.fullnamecontroller.text,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      hintText: 'Your full name...',
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
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'DM Sans',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Text color for dark mode
                              : Colors.black,
                        ),
                    validator:
                        _model.fullnamecontrollerValidator.asValidator(context),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                  child: TextFormField(
                    controller: _model.gendercontroller,
                    obscureText: false,
                    //initialValue: _model.gendercontroller.text,
                    decoration: InputDecoration(
                      labelText: 'Gender\n',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      hintText: 'Your full name...',
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
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'DM Sans',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Text color for dark mode
                              : Colors.black,
                        ),
                    textAlign: TextAlign.justify,
                    validator:
                        _model.genderControllerValidator.asValidator(context),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                  child: TextFormField(
                    controller: _model.dobcpontroller,
                    obscureText: false,
                    onTap: () async {
                      datePicker();
                    },

                    //initialValue: _model.dobcpontroller.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: 'Date of Birth\n',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      hintText: 'Your full name...',
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
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
                    ),

                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'DM Sans',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Text color for dark mode
                              : Colors.black,
                        ),
                    textAlign: TextAlign.justify,
                    validator:
                        _model.dobcpontrollerValidator.asValidator(context),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        var res;
                        try {
                          res = await Dio().post(Update_profile, data: {
                            "email":
                                _model.emailAddressController.text.toString(),
                            "fullName":
                                _model.fullnamecontroller.text.toString(),
                            "gender": _model.gendercontroller.text.toString(),
                            "DOB": _model.dobcpontroller.text.toString(),
                          });
                        } catch (e) {
                          print(e);
                        }

                        if (res.data['success']) {
                          var rest;
                          try {
                            rest = await Dio().post(LOGIN_URL, data: {
                              "email":
                                  _model.emailAddressController.text.toString(),
                              "password": widget.password
                            });
                          } catch (e) {
                            print(e);
                          }
                          print(rest.data['token']);
                          if (rest.data['success']) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => HomePageWidget(
                            //             token: res.data['token'],
                            //             decryptPass: widget.password)));
                            Navigator.pop(context, rest.data['token']);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(rest.data['msg']),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res.data['msg']),
                            ),
                          );
                        }
                      },
                      text: 'Update',
                      options: FFButtonOptions(
                        width: 150.0,
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
