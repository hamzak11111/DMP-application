import 'package:dio/dio.dart';
import 'package:dmp_app/data/Doctor.dart';
import 'package:dmp_app/data/Patient.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_theme.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_util.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:dmp_app/pages/doctor_home_page/dr_home_page_widget.dart';
import 'package:dmp_app/pages/home_page/home_page_widget.dart';
import 'package:dmp_app/pages/signup/signup_model.dart';
import 'package:dmp_app/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;
  late SignupModel _model;
  late PageController _pageController;
  int _currentStep = 0; // Add this line to track the current step

  // Define security questions
  final List<String> questions = [
    "What is your grandmother’s maiden name?",
    "What year did you enter college?",
    "What is the manufacturer of your first car?",
    "What is your favorite sport?",
    "What breed of cat do you like the most?",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _dotAnimations = List.generate(3, (index) {
      // Set the initial height of the first dot to 50, and others to 12
      double startSize = index == 0 ? 50 : 12;
      return Tween<double>(begin: startSize, end: 50).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    });

    // Start the animation for the first dot
    if (_currentStep == 0) {
      _controller.forward(from: 0.0);
    }
    _model = SignupModel();
    _pageController = PageController();
    // Initialize the question controller with the first question
    _model.questionController = TextEditingController(text: questions.first);
    _model.emailController ??= TextEditingController(text: '');
    _model.passwordController ??= TextEditingController(text: '');
    _model.confirmPasswordController ??= TextEditingController(text: '');
    _model.nameController ??= TextEditingController(text: '');
    _model.mrNoController ??= TextEditingController(text: '');
    _model.employeeIdController ??= TextEditingController(text: '');
    _model.specializationController ??= TextEditingController(text: '');
    _model.hospitalIdController ??= TextEditingController(text: '');
    _model.roleController ??= TextEditingController(text: '');
    _model.dobController ??= TextEditingController(text: '');
    _model.genderController ??= TextEditingController(text: 'Male');
    _model.questionController ??=
        TextEditingController(text: 'Security Question');
    _model.answerController ??= TextEditingController(text: '');
  }

  @override
  void dispose() {
    _controller.dispose();

    _pageController.dispose();
    _model.dispose();
    super.dispose();
  }

  void registerPatient() async {
    var res;
    Patient patient = Patient(
      email: _model.emailController.text,
      password: _model.passwordController.text,
      fullName: _model.nameController.text,
      gender: _model.genderController.text,
      dob: _model.dobController.text,
      securityQuestion: _model.questionController.text,
      securityAnswer: _model.answerController.text,
      role: _model.selectedRole.toString().split('.').last,
      mrNo: _model.mrNoController.text,
    );

    try {
      res = await Dio().post(SIGNUP_URL, data: patient.toJson());
    } catch (e) {
      showValidationMessage(context, e.toString());
      print(e.toString());
    }

    if (res.data['success']) {
      var authenticate;

      try {
        authenticate = await Dio().post(LOGIN_URL, data: {
          "email": _model.emailController.text.toString(),
          "password": _model.passwordController.text.toString()
        });
      } catch (e) {
        showValidationMessage(context, e.toString());
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', _model.emailController!.text.toString());
      prefs.setString(
          "userPassword", _model.passwordController!.text.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageWidget(
                    patientProfile: patient,
                    password: _model.passwordController.text.toString(),
                    token: authenticate.data['token'],
                    decryptPass: _model.passwordController.text.toString(),
                  )));
      print('success');
    } else {
      String error = res.data['msg'];
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
                    error,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ))));
      print(res.data['msg']);
    }
  }

  void registerDoctor() async {
    Doctor doctor = Doctor(
      email: _model.emailController.text,
      password: _model.passwordController.text,
      fullName: _model.nameController.text,
      gender: _model.genderController.text,
      dob: _model.dobController.text,
      securityQuestion: _model.questionController.text,
      securityAnswer: _model.answerController.text,
      role: _model.selectedRole.toString().split('.').last,
      employeeId: _model.employeeIdController.text,
      hospitalId: _model.hospitalIdController.text,
      specialization: _model.specializationController.text,
    );
    var res;

    try {
      res = await Dio().post(SIGNUP_URL, data: doctor.toJson());
    } catch (e) {
      showValidationMessage(context, e.toString());
    }

    if (res.data['success']) {
      var authenticate;

      try {
        authenticate = await Dio().post(LOGIN_URL, data: {
          "email": _model.emailController.text.toString(),
          "password": _model.passwordController.text.toString()
        });
      } catch (e) {
        showValidationMessage(context, e.toString());
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', _model.emailController!.text.toString());
      prefs.setString(
          "userPassword", _model.passwordController!.text.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DrHomePageWidget(
                    token: authenticate.data['token'],
                    decryptPass: _model.passwordController.text.toString(),
                    password: _model.passwordController.text.toString(),
                    doctorProfile: doctor,
                  )));
      print('success');
    } else {
      String error = res.data['msg'];
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Text("Error 101!",
                  //     style: TextStyle(
                  //         fontSize: 20,
                  //         color: Colors.white)),
                  Text(
                    error,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (indexDots) {
                    return AnimatedBuilder(
                        animation: _dotAnimations[indexDots],
                        builder: (context, child) {
                          return GestureDetector(
                              onTap: () {},
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: 8,
                                  height: _currentStep == indexDots
                                      ? _dotAnimations[indexDots].value
                                      : 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: indexDots == _currentStep
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .primary
                                            .withOpacity(0.3),
                                  )));
                        });
                  })),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                    _controller.forward(from: 0.0);
                  });
                },
                controller: _pageController,
                physics:
                    NeverScrollableScrollPhysics(), // Disable swipe to navigate
                children: [
                  buildStepOne(context),
                  buildStepTwo(context),
                  buildStepThree(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStepOne(BuildContext context) {
    // Step one includes common input fields and role selection
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextField(
                  context,
                  "Full Name",
                  _model.nameController,
                  "Your name..",
                  false,
                  Icon(Icons.person_2_rounded,
                      color: FlutterFlowTheme.of(context).primaryColor)),
              buildTextField(
                  context,
                  "Email Address",
                  _model.emailController,
                  "Your email..",
                  false,
                  Icon(Icons.email_rounded,
                      color: FlutterFlowTheme.of(context).primaryColor)),
              buildTextField(
                  context,
                  "Password",
                  _model.passwordController,
                  "Your password..",
                  true,
                  Icon(Icons.password_rounded,
                      color: FlutterFlowTheme.of(context).primaryColor)),
              buildTextField(
                  context,
                  "Confirm Password",
                  _model.confirmPasswordController,
                  "Confirm your password...",
                  true,
                  Icon(Icons.wifi_password_rounded,
                      color: FlutterFlowTheme.of(context).primaryColor)),
// Add space for the keyboard
              buildButton(context, true, 'Next', validateStepOne()),
              SizedBox(
                  height: MediaQuery.of(context)
                      .viewInsets
                      .bottom), // Add space for the keyboard
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStepTwo(BuildContext context) {
    // Use a SingleChildScrollView to prevent overflow
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildUserRoleField(context),
              if (_model.selectedRole == UserRole.Doctor) ...[
                buildDoctorFields(context),
              ] else if (_model.selectedRole == UserRole.Patient) ...[
                buildPatientFields(context),
              ],
              Align(
                alignment: AlignmentDirectional(0.0, 0.05),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      print(_model.emailController.text);
                      String? validationMessage = validateStepTwo();
                      if (validationMessage == null) {
                        if (UserRole.Doctor == _model.selectedRole) {
                          var res;
                          try {
                            res = await Dio().get(CHECK_HOSPIATL_URL, data: {
                              "hospital_id":
                                  _model.hospitalIdController.text.toString()
                            });
                            if (res.data['success']) {
                              res = await Dio()
                                  .get(CHECK_EMPLOYEE_ID_URL, data: {
                                "EmployeeId":
                                    _model.employeeIdController.text.toString()
                              });
                              if (res.data['success']) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              } else {
                                showValidationMessage(context, res.data['msg']);
                              }
                            } else {
                              showValidationMessage(
                                  context, "Hospital does not exist.");
                            }
                          } catch (e) {
                            print(e);
                            showValidationMessage(context, e.toString());
                          }
                        } else {
                          var res;
                          // check MrNo exists
                          try {
                            res = await Dio().get(CHECK_MR_NO_URL, data: {
                              "MrNo": _model.mrNoController.text.toString()
                            });
                            if (res.data['success']) {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            } else {
                              showValidationMessage(context, res.data['msg']);
                            }
                          } catch (e) {
                            print(e);
                            showValidationMessage(context, e.toString());
                          }
                        }
                      } else {
                        showValidationMessage(context, validationMessage);
                      }
                    },
                    showLoadingIndicator: true,
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
              // Add space for the keyboard
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStepThree(context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDOBField(context),
              buildGenderField(context),
              buildSecurityQuestionField(context),
              buildTextField(
                  context,
                  "Answer",
                  _model.answerController,
                  "Your answer..",
                  false,
                  Icon(Icons.question_answer_rounded,
                      color: FlutterFlowTheme.of(context).primaryColor)),
              Align(
                alignment: AlignmentDirectional(0.0, 0.05),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      print(_model.emailController.text);
                      String? validationMessage = validateStepThree();
                      if (validationMessage == null) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        showValidationMessage(context, validationMessage);
                      }
                      print("Name: " + _model.nameController.text.toString());
                      print("Email: " + _model.emailController.text.toString());
                      print("Password: " +
                          _model.passwordController.text.toString());
                      print("Confirm Password: " +
                          _model.confirmPasswordController.text.toString());
                      print("Role: " +
                          _model.selectedRole.toString().split('.').last);
                      print("EMP ID: " +
                          _model.employeeIdController.text.toString());
                      print("Hospiatl ID: " +
                          _model.hospitalIdController.text.toString());
                      print("Specialization: " +
                          _model.specializationController.text.toString());
                      print("Mr No: " + _model.mrNoController.text.toString());

                      if (_model.selectedRole == UserRole.Doctor) {
                        registerDoctor();
                      } else if (_model.selectedRole == UserRole.Patient) {
                        registerPatient();
                      }
                    },
                    showLoadingIndicator: true,
                    text: 'Register',
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
              SizedBox(
                  height: MediaQuery.of(context)
                      .viewInsets
                      .bottom), // Add space for the keyboard
            ],
          ),
        ),
      ),
    );
  }

  String? validateStepOne() {
    // Check if all fields are filled
    if (_model.nameController.text.isEmpty ||
        _model.emailController.text.isEmpty ||
        _model.questionController.text.isEmpty ||
        _model.confirmPasswordController.text.isEmpty) {
      return "All fields are required.";
    }

    // Check if email format is correct
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(_model.emailController.text)) {
      return "Please enter a valid email address.";
    }

    // Check if password and confirm password match
    if (_model.passwordController.text !=
        _model.confirmPasswordController.text) {
      return "Passwords do not match.";
    }

    // If all validations pass, return null
    return null;
  }

  String? validateStepTwo() {
    if (_model.selectedRole == UserRole.None) {
      return "Please select a role.";
    }
    // Check the selected role
    if (_model.selectedRole == UserRole.Doctor) {
      // Doctor-specific fields
      if (_model.hospitalIdController.text.isEmpty ||
          _model.employeeIdController.text.isEmpty ||
          _model.specializationController.text.isEmpty) {
        return "All doctor fields are required.";
      }
    } else if (_model.selectedRole == UserRole.Patient) {
      // Patient-specific fields
      if (_model.mrNoController.text.isEmpty) {
        return "The MR No field is required for patients.";
      }
    }

    // If all validations pass, return null
    return null;
  }

  String? validateStepThree() {
    if (_model.dobController.text.isEmpty ||
        _model.genderController.text.isEmpty ||
        _model.questionController.text.isEmpty ||
        _model.answerController.text.isEmpty) {
      return "All fields are required.";
    }

    // If all validations pass, return null
    return null;
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

  Widget buildButton(
      context, showLoadingIndicator, buttonText, validateFunction) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.05),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
        child: FFButtonWidget(
          onPressed: () async {
            print(_model.emailController.text);
            String? validationMessage = validateStepOne();
            var dio = Dio();
            print("msg");
            if (validationMessage == null) {
              try {
                var res = await dio.get(CHECK_EMAIL_URL, data: {
                  "email": _model.emailController.text.toString(),
                });

                if (res.data['success']) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  showValidationMessage(context, res.data['msg']);
                }
              } catch (e) {
                
                showValidationMessage(context, e.toString());
              }
            } else {
              print("valid msg");
              showValidationMessage(context, validationMessage);
            }
          },
          showLoadingIndicator: showLoadingIndicator,
          text: buttonText,
          options: FFButtonOptions(
            width: 340.0,
            height: 60.0,
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
    );
  }

  Widget buildDoctorFields(BuildContext context) {
    // Doctor-specific input fields
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTextField(
              context,
              "Hospital ID",
              _model.hospitalIdController,
              "Enter the hospital id you work for..",
              false,
              Icon(Icons.local_hospital_rounded,
                  color: FlutterFlowTheme.of(context).primaryColor)),
          buildTextField(
              context,
              "Employee ID",
              _model.employeeIdController,
              "Enter your employee id..",
              false,
              Icon(Icons.work_rounded,
                  color: FlutterFlowTheme.of(context).primaryColor)),
          buildTextField(
              context,
              "Specialization",
              _model.specializationController,
              "Your specialization..",
              false,
              Icon(Icons.medical_services_rounded,
                  color: FlutterFlowTheme.of(context).primaryColor)),
          // Add buttons or form submit actions here
        ],
      ),
    );
  }

  Widget buildPatientFields(BuildContext context) {
    // Patient-specific input fields
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTextField(
              context,
              "Mr No",
              _model.mrNoController,
              "Enter your Mr. No..",
              false,
              Icon(Icons.perm_identity_rounded,
                  color: FlutterFlowTheme.of(context).primaryColor)),
          // Add buttons or form submit actions here
        ],
      ),
    );
  }

  Widget buildDOBField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
      child: TextFormField(
        controller: _model.dobController,
        readOnly: true, // To prevent manual editing
        onTap: () async {
          datePicker();
        },
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today_rounded,
              color: FlutterFlowTheme.of(context).primaryColor),
          labelText: 'Date of Birth',
          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'Your Date of Birth',
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
        ),
      ),
    );
  }

  void datePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      String formatedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        _model.dobController.text = formatedDate;
      });
    } else {
      print("Not Selected");
    }
  }

  Widget buildGenderField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
      child: DropdownButtonFormField<String>(
        value: _model.genderController?.text, // Initial value
        onChanged: (String? newValue) {
          setState(() {
            _model.genderController?.text = newValue ?? '';
          });
        },
        items: ['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: FlutterFlowTheme.of(context).bodyText1),
          );
        }).toList(),
        decoration: InputDecoration(
          icon: _model.genderController.text == 'Male'
              ? Icon(Icons.male_rounded,
                  color: FlutterFlowTheme.of(context).primaryColor)
              : _model.genderController.text == 'Other'
                  ? Icon(Icons.transgender_rounded,
                      color: FlutterFlowTheme.of(context).primaryColor)
                  : Icon(Icons.female_rounded,
                      color: FlutterFlowTheme.of(context).primaryColor),
          labelText: 'Gender',
          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'Select your gender',
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
        ),
      ),
    );
  }

  Widget buildUserRoleField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
      child: DropdownButtonFormField<UserRole>(
        value: _model.selectedRole,
        onChanged: (UserRole? newValue) {
          setState(() {
            _model.selectedRole = newValue ?? UserRole.None;
          });
          // No need to call _pageController.nextPage here. Just update the state.
        },
        items:
            UserRole.values.map<DropdownMenuItem<UserRole>>((UserRole value) {
          return DropdownMenuItem<UserRole>(
            value: value,
            child: Text(
              value.toString().split('.').last,
              style: FlutterFlowTheme.of(context).bodyText1,
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          icon: Icon(Icons.person_search_rounded,
              color: FlutterFlowTheme.of(context).primaryColor),
          labelText: 'Select role',
          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'Choose a role',
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
        ),
      ),
    );
  }

  Widget buildSecurityQuestionField(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
      child: DropdownButtonFormField<String>(
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
        value: _model.questionController?.text,
        onChanged: (String? newValue) {
          setState(() {
            _model.questionController?.text = newValue ?? '';
          });
        },
        items: questions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: FlutterFlowTheme.of(context).bodyText1,
              softWrap: true,
              maxLines: 2,
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          icon: Icon(Icons.question_mark_rounded,
              color: FlutterFlowTheme.of(context).primaryColor),
          labelText: 'Security Question',
          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'Select a security question',
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
        ),
      ),
    );
  }

  Widget buildTextField(
      context,
      String label,
      TextEditingController? controller,
      String hint,
      bool obscureText,
      Icon icon) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: icon,
          labelText: label,
          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: hint,
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
          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
        ),
        style: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'DM Sans',
            ),
      ),
    );
  }

  // Additional methods to build UI components for different steps and roles...
}
