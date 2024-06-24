import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:dmp_app/data/Doctor.dart';
import 'package:dmp_app/index.dart';
import 'package:dmp_app/pages/patients/patients_widget.dart';
import 'package:dmp_app/pages/pending_approval_doc/pending_doc_widget.dart';
import 'package:dmp_app/pages/records_doc/records_doc_widget.dart';
import 'package:dmp_app/urls.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:dmp_app/data/Prescription.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'DisplayPictureScreen2.dart';
import 'dr_home_page_model.dart';
export 'dr_home_page_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:convert';

// ignore: unused_import
import 'dart:io';

class DrHomePageWidget extends StatefulWidget {
  final String token;
  final String decryptPass;
  final Doctor doctorProfile;
  final String password;
  const DrHomePageWidget(
      {Key? key,
      required this.token,
      required this.decryptPass,
      required this.doctorProfile,
      required this.password})
      : super(key: key);

  @override
  _DrHomePageWidgetState createState() => _DrHomePageWidgetState(
      token: this.token,
      decryptPass: this.decryptPass,
      doctorProfile: this.doctorProfile);
}

class _DrHomePageWidgetState extends State<DrHomePageWidget> {
  //File imageFile = File('');

  late String token;
  final String decryptPass;
  late Doctor doctorProfile;

  _DrHomePageWidgetState(
      {required this.token,
      required this.decryptPass,
      required this.doctorProfile});

  // wrote this function

  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  int _currentIndex = 0;
  
  
  final List<String> imagePaths = [
    'assets/images/MediScan Banner.png',
    'assets/images/HEC Banner.png',
    'assets/images/Powered by DataInsight.png',
  ];


@override
void initState() {
  super.initState();
  getProfile();
  _model = createModel(context, () => HomePageModel());

  // Fetch prescriptions and show Snackbar if any are unapproved
  fetchPrescriptions();

  // Periodically execute period_fetchPrescriptions after 5 seconds
  Timer.periodic(Duration(seconds: 5), (Timer t) { 
       period_fetchPrescriptions();
    });
}
List<Prescription> prescriptions = []; // Changed type to List<Prescription>
final Dio dio = Dio();

var total = 0; 
void period_fetchPrescriptions() async {
  total = 0;
  var response = await dio.get(GET_DOCTORS_PRESCRIPTION, data: {"email": doctorProfile!.email}); // Changed to queryParameters
  if (response.data['success']) {
    List<Prescription> pres = [];
    // print(response.data['prescriptions']);d
    // if(response.data['prescriptions'] == pres)
    for (var presData in response.data['prescriptions']) {
      // print(presData);
      Prescription prescription = Prescription.fromJson(presData);
      if (prescription.approved != "True") {

        total = total + 1 ;
      }
      pres.add(prescription); // Add the prescription to the list
    }

}
      setState(() {
        
      });
}

void fetchPrescriptions() async {
  total = 0;
  var response = await dio.get(GET_DOCTORS_PRESCRIPTION, data: {"email": doctorProfile!.email}); // Changed to queryParameters
  if (response.data['success']) {
    List<Prescription> pres = [];
    bool hasUnapprovedPrescriptions = false;
    // print(response.data['prescriptions']);d
    // if(response.data['prescriptions'] == pres)
    for (var presData in response.data['prescriptions']) {
      // print(presData);
      Prescription prescription = Prescription.fromJson(presData);
      if (prescription.approved != "True") {
        hasUnapprovedPrescriptions = true; // Mark that there are unapproved prescriptions
        total = total + 1 ;
      }
      pres.add(prescription); // Add the prescription to the list
    }


    if (response.statusCode == 200) {
      setState(() {
        prescriptions = pres;
      });

      // Show Snackbar if there are unapproved prescriptions
      if (hasUnapprovedPrescriptions) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You have $total unapproved prescriptions pending',
                style: TextStyle(color: Colors.white),
                
              ),
              
              backgroundColor: Colors.red,
              action: SnackBarAction(
          label: 'Review',
          textColor: Colors.white,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingDocWidget(email: doctorProfile!.email,callback:fetchPrescriptions),
              ),
            );
          },
        ),
            ),
        
          );
        });
      }
    } else {
      print('Failed to fetch prescriptions.');
    }
  }
}



  void getProfile() async {
    print("Hello");
    var res;

    Dio dio = new Dio();

    dio.options.headers["authorization"] = "Bearer $token";

    try {
      res = await dio.get(Profile_URL);
    } catch (e) {
      print(e);
    }

    if (res.data['success']) {
      setState(() {
        doctorProfile = Doctor.fromJson(res.data);
      });
    } else {
      print(res.data['msg']);
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<String>> getDocNames() async {
    List<String> docNames = [];
    try {
      var response = await Dio().get(GET_DOC_NAMES);
      if (response.statusCode == 200) {
        for (var i in response.data) {
          docNames.add(response.data['doctors'][i].fullName);
        }
      }
    } catch (e) {
      print(e);
    }
    return docNames;
  }

  String _imagePath = "";

  // for edge detection using camera
  void detectObjectfromCamera() async {
    _imagePath = Path.join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    print(_imagePath);

    // if (await Permission.camera.request().isGranted) {
    // } else {
    //   Map<Permission, PermissionStatus> statuses = await [
    //     Permission.camera,
    //     //Permission.storage,
    //   ].request();
    //   print(statuses[Permission.camera]);
    // }
    // Either the permission was already granted before or the user just granted it.

    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }
    //PermissionStatus result;
    if (!isCameraGranted) {
      openAppSettings();

      return;
    }
    try {
        final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    setState(() {
      _imagePath = image.path;
    });
  }
      List<String> docNames = await getDocNames();
      if (image != null) {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                        imagePath: _imagePath,
                        email: doctorProfile.email,
                        docnames: docNames,
                      )));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // for edge detection using gallery
  void detectObjectfromGallery() async {
    _imagePath = Path.join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    print(_imagePath);

    print("Permission: " + Permission.photos.toString());

    bool isPhotoGranted = await Permission.photos.request().isGranted;
    isPhotoGranted = await Permission.photos.request().isLimited;
    if (!isPhotoGranted) {
      isPhotoGranted =
          await Permission.photos.request() == PermissionStatus.granted;
    }

    if (!isPhotoGranted) {
      isPhotoGranted =
          await Permission.photos.request() == PermissionStatus.limited;
    }
    //PermissionStatus result;
    if (!isPhotoGranted) {
      openAppSettings();
    }

    try {
       final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    setState(() {
      _imagePath = image.path;
    });
  }
      // print(success);
      List<String> docNames = await getDocNames();

      if (image != null) {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                        imagePath: _imagePath,
                        email: doctorProfile.email,
                        docnames: docNames,
                      )));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 110, 194, 1),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Text(
            doctorProfile!.fullName,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: Color(0x004B39EF),
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: Color(0x004B39EF),
              icon: Icon(
                Icons.person_3,
                color: Color(0xFFF9FBFF),
                size: 24.0,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileWidget(
                              fullName: doctorProfile.fullName,
                              gender: doctorProfile.gender,
                              DOB: doctorProfile.dob,
                              age: doctorProfile.age,
                              email: doctorProfile.email,
                              token: token,
                              password: widget.password,
                              role: doctorProfile.role,
                            ))).then((_) async {
                  // var authenticate;

                  // try {
                  //   print(email);
                  //   print(password);
                  //   authenticate = await Dio().post(LOGIN_URL,
                  //       data: {"email": email, "password": password});
                  // } catch (e) {
                  //   print(e);
                  // }

                  // token = authenticate.data['token'];

                  getProfile();
                });
              },
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      Container(
        height: 100.0, // Set the desired height here
        child: DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 110, 194, 1),
          ),
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
      ListTile(
        leading: Icon(Icons.camera),
        title: Text('Camera'),
        onTap: () {
          // Handle profile tap
          detectObjectfromCamera();
        },
      ),
       ListTile(
        leading: Icon(Icons.image),
        title: Text('Import'),
        onTap: () {
          // Handle prescriptions tap
           detectObjectfromGallery();
        },
      ),
      ListTile(
        leading: Icon(Icons.receipt_long),
        title: Text('Perscriptions'),
        onTap: () {
          // Handle prescriptions tap
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordsDocWidget(
                    email: doctorProfile!.email)));
        },
      ),
      ListTile(
        leading: Icon(Icons.check_circle_outline),
        title: Text('Approve Perscriptions'),
        onTap: () {
          // Handle approve prescriptions tap
          
        },
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text('Patients'),
        onTap: () {
          // Handle patients tap
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PatientsWidget(
                      email: doctorProfile.email))));
        },
      ),
      ListTile(
        leading: Icon(Icons.analytics),
        title: Text('Analyze'),
        onTap: () {
          // Handle analyze tap
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileWidget(
                              fullName: doctorProfile.fullName,
                              gender: doctorProfile.gender,
                              DOB: doctorProfile.dob,
                              age: doctorProfile.age,
                              email: doctorProfile.email,
                              token: token,
                              password: widget.password,
                              role: doctorProfile.role,
                            ))).then((_) async {
                  // var authenticate;

                  // try {
                  //   print(email);
                  //   print(password);
                  //   authenticate = await Dio().post(LOGIN_URL,
                  //       data: {"email": email, "password": password});
                  // } catch (e) {
                  //   print(e);
                  // }

                  // token = authenticate.data['token'];

                  getProfile();
                });
              },
      ),
      // Add more list tiles as needed
    ],
  ),
),



        
        body: Stack(
      children: [
       Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Color.fromRGBO(0, 110, 194, 1),
          height: 200,
          padding: EdgeInsets.all(8),
          child: Center(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 500,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 200),
                enableInfiniteScroll: true,
                viewportFraction: 0.9, // Make the current item occupy 80% of the viewport
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: imagePaths.map((imagePath) {
                int index = imagePaths.indexOf(imagePath);
                return Builder(
                  builder: (BuildContext context) {
                    return AnimatedOpacity(
                      opacity: _currentIndex == index ? 1.0 : 0.9, // Fade out non-active images
                      duration: Duration(milliseconds: 400),
                      child: Transform.scale(
                        scale: _currentIndex == index ? 1.0 : 0.9, // Scale down non-active images
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 20.0, 10.0, 10.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            detectObjectfromCamera();
                          },
                          child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      width: 75.0,
      height: 75.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: FlutterFlowIconButton(
        borderRadius: 20.0,
        borderWidth: 1.0,
        buttonSize: 60.0,
        fillColor: Colors.white,
        icon: Icon(
          Icons.photo_camera,
          color: Color.fromRGBO(0, 110, 194, 1),
          size: 40.0,
        ),
        onPressed: () {
          detectObjectfromCamera();
        },
      ),
    ),
    SizedBox(height: 8.0), // Add some space between the Container and the text
    InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        detectObjectfromCamera();
      },
      child: Text(
        'Camera',
        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
          color: Color.fromRGBO(0, 110, 194, 1),
        ),
      ),
    ),
  ],
)

                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 20.0, 10.0, 10.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecordsDocWidget(
                                          email: doctorProfile!.email,
                                        )));
                          },
                          child: Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [    Container(
      width: 75.0,
      height: 75.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: FlutterFlowIconButton(
        borderColor: Colors.white,
        borderRadius: 20.0,
        borderWidth: 1.0,
        buttonSize: 60.0,
        fillColor: Colors.white,
        icon: Icon(
          Icons.image_outlined,
          color: Color.fromRGBO(0, 110, 194, 1),
          size: 40.0,
        ),
        onPressed: () {
          detectObjectfromGallery();
        },
      ),
    ),
    SizedBox(height: 8.0), // Add some space between the Container and the text
    InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        detectObjectfromGallery();
      },
      child: Text(
        'Import',
        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
          color: Color.fromRGBO(0, 110, 194, 1),
        ),
      ),
    ),]))),
    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 10.0),
                        child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      width: 75.0,
      height: 75.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: FlutterFlowIconButton(
        borderColor: Colors.white,
        borderRadius: 20.0,
        borderWidth: 1.0,
        buttonSize: 60.0,
        fillColor: Colors.white,
        icon: Icon(
          Icons.manage_search_rounded,
          color: Color.fromRGBO(0, 110, 194, 1),
          size: 40.0,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PatientsWidget(
                      email: doctorProfile.email))));
        },
      ),
    ),
    Text(
      'Patients',
      style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
        color: Color.fromRGBO(0, 110, 194, 1),
      ),
    ),
  ],
)

                      ),
                      
                      
                      
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 10.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            detectObjectfromGallery();
                          },
                          child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [Container(
      width: 75.0,
      height: 75.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FlutterFlowIconButton(
            borderColor: Colors.white,
            borderRadius: 20.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            fillColor: Colors.white,
            icon: FaIcon(
              FontAwesomeIcons.fileSignature,
              color: Color.fromRGBO(0, 110, 194, 1), // Change this to your desired color
              size: 40.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PendingDocWidget(
                    email: doctorProfile!.email,
                    callback: fetchPrescriptions,
                  ),
                ),
              );
            },
          ),
          if (total > 0)
            Positioned(
              top: -10,
              right: -20,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                ),
                constraints: BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    '$total',  // Replace this with your unread notification count variable
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    // SizedBox(height: 10.0), // Add some space between the Container and the text
    InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PendingDocWidget(
              email: doctorProfile!.email,
              callback: fetchPrescriptions,
            ),
          ),
        );
      },
      child: Text(
        'Unpproved\nPrescriptions',
        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
          color: Color.fromRGBO(0, 110, 194, 1),
        ),
        textAlign: TextAlign.center,
      ),
    ),
    
  ],
)

                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 20.0, 10.0, 10.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecordsDocWidget(
                                          email: doctorProfile!.email,
                                        )));
                          },
                          child: Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      width: 75.0,
      height: 75.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: FlutterFlowIconButton(
        // borderColor: Color.fromARGB(255, 83, 121, 255),
        borderRadius: 20.0,
        borderWidth: 1.0,
        buttonSize: 60.0,
        fillColor: Colors.white,
        icon: FaIcon(
          FontAwesomeIcons.fileSignature,
          color: Color.fromRGBO(0, 110, 194, 1),
          size: 40.0,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecordsDocWidget(
                      email: doctorProfile!.email)));
        },
      ),
    ),
    SizedBox(height: 8.0), // Add some space between the Container and the text
    InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecordsDocWidget(
                    email: doctorProfile!.email)));
      },
      child: Text(
        'Approved\nPrescriptions',
        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
          color: Color.fromRGBO(0, 110, 194, 1),
        ),
        textAlign: TextAlign.center,
      ),
      
    ),

  ],
)
              
                        ),
                      ),
                      
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 20.0, 10.0, 10.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PendingDocWidget(
                                          email: doctorProfile!.email,callback: fetchPrescriptions,
                                        )));
                          },
                          child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  ],
)

                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    ));
  }

  // /// Get from gallery
  _getFromGallery() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    List<String> docNames = await getDocNames();

    if (pickedFile != null) {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    docnames: docNames,
                    imagePath: pickedFile.path,
                    email: doctorProfile.email)));
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    List<String> docNames = await getDocNames();
    if (pickedFile != null) {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                      docnames: docNames,
                      imagePath: pickedFile.path,
                      email: doctorProfile.email,
                    )));
      });
    }
  }
}
