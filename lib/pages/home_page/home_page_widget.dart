import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dmp_app/data/Patient.dart';
import 'package:dmp_app/index.dart';
import 'package:dmp_app/pages/doctor_home_page/DisplayPictureScreen2.dart';
import 'package:dmp_app/urls.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';
import 'package:dmp_app/data/Prescription.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

// import 'dart:convert';

// ignore: unused_import
import 'dart:io';

class HomePageWidget extends StatefulWidget {
  final String token;
  final String decryptPass;
  final Patient patientProfile;
  final String password;
  const HomePageWidget(
      {Key? key,
      required this.token,
      required this.decryptPass,
      required this.patientProfile,
      required this.password})
      : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState(
      token: this.token,
      decryptPass: this.decryptPass,
      patientProfile: patientProfile);
}

class _HomePageWidgetState extends State<HomePageWidget> {
  //File imageFile = File('');

  late String token;
  final String decryptPass;
  late Patient patientProfile;

  _HomePageWidgetState(
      {required this.token,
      required this.decryptPass,
      required this.patientProfile});

  // wrote this function

  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  final List<String> imagePaths = [
    'assets/images/MediScan Banner.png',
    'assets/images/HEC Banner.png',
    'assets/images/Powered by DataInsight.png',
  ];

  Future<List<String>> getDocNames() async {
    List<String> docNames = [];
    try {
      var response = await Dio().get(GET_DOC_NAMES);
      if (response.statusCode == 200) {
        print('ok');
        print(response.data);
        for (var i in response.data['doctors']) {
          print(i);
          docNames.add(i['fullName']);
        }
      }
    } catch (e) {
      print(e);
    }
    return docNames;
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
        patientProfile = Patient.fromJson(res.data);
      });
    } else {
      print(res.data['msg']);
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    _model = createModel(context, () => HomePageModel());
    fetchPrescriptions();

    Timer.periodic(Duration(seconds: 5), (Timer t) { 
       period_fetchPrescriptions();
    });
  }
  Dio dio = new Dio();
  List<Prescription> prescriptions = [];
  bool hasapprovedPrescriptions = false;

  Future<void> period_fetchPrescriptions() async {

    total=0;
    // print("ello");
    var response = await dio
          .get(GET_PATIENT_PRESCRIPTION, data: {"email": patientProfile.email});

      if (response.data['success']) {
        //print(response.data['prescriptions']);
        List<Prescription> pres = [];

        for (var presData in response.data['prescriptions']) {
          // print(presData);
          Prescription prescription = Prescription.fromJson(presData);
          if (prescription.approved == "False") {
            hasapprovedPrescriptions=true;
            pres.add(prescription);
            total++;
          }
        }
      }

  }

  Future<void> fetchPrescriptions() async {
    try {
      total =0;
      var response = await dio
          .get(GET_PATIENT_PRESCRIPTION, data: {"email": patientProfile.email});

      if (response.data['success']) {
        //print(response.data['prescriptions']);
        List<Prescription> pres = [];

        for (var presData in response.data['prescriptions']) {
          print(presData);
          Prescription prescription = Prescription.fromJson(presData);
          if (prescription.approved == "False") {
            hasapprovedPrescriptions=true;
            pres.add(prescription);
            total++;
          }
        }
        if (response.statusCode == 200) {
          setState(() {
            prescriptions = pres;
          });
        } 
        
      } 
      if (hasapprovedPrescriptions) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You have $total unapproved prescriptions',
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
              builder: (context) => RecordsWidget(
                email: patientProfile.email,
              ),
            ),
          );
          },
        ),
            ),
        
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
        runModel();
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                        docnames: docNames,
                        imagePath: _imagePath,
                        email: patientProfile.email,
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

    print(Permission.photos);

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
      List<String> docNames = await getDocNames();
      print("awd");
      print(docNames);
      if (image != null) {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                      docnames: docNames,
                      imagePath: _imagePath,
                      email: patientProfile.email)));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Uint8List? image;

  void runModel() async {
    File imageFile = File(_imagePath);
    Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
    // String base64string =
    //     base64.encode(imagebytes); //convert bytes to base64 string
    // print(base64string);
    print(imagebytes);
  }

   var total=0;

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
          automaticallyImplyLeading: false,
          title: Text(
            patientProfile.fullName,
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
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileWidget(
                              fullName: patientProfile.fullName,
                              gender: patientProfile.gender,
                              DOB: patientProfile.dob,
                              age: patientProfile.age,
                              email: patientProfile.email,
                              token: token,
                              password: widget.decryptPass,
                              role: patientProfile.role,
                            )));

                getProfile();
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
        title: Text('Records'),
        onTap: () {
          // Handle prescriptions tap
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordsWidget(
              email: patientProfile.email,
            ),
          ),
        );

        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () {
               
              },
      ),
      // Add more list tiles as needed
    ],
  ),
),
        body:Stack(
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
      ), SafeArea(
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
                            detectObjectfromGallery();
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
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
  child: Stack(
    children: [
      InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordsWidget(
                email: patientProfile.email,
              ),
            ),
          );
        },
        child: Column(
  children: [
        
   Stack(
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
          ),
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
        icon: FaIcon(
          FontAwesomeIcons.fileSignature,
          color: Color.fromRGBO(0, 110, 194, 1),
          size: 40.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordsWidget(
                email: patientProfile.email,
              ),
            ),
          );
        },
      ),
    ),
    if (total > 0)  // Only show the badge if there are notifications
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          constraints: BoxConstraints(
            minWidth: 20.0,
            minHeight: 20.0,
          ),
          child: Center(
            child: Text(
              '$total',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
  ],
),

    SizedBox(height: 10.0), // Add some space between the container and the text
    InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordsWidget(
              email: patientProfile.email,
            ),
          ),
        );
      },
      child: Text(
        'Record',
        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
          color: Color.fromRGBO(0, 110, 194, 1),
        ),
      ),
    ),
  ],
),


      ),

      
    ],
  ),
),


                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ])
    )
     
    );
  }

  // /// Get from gallery
  // _getFromGallery() async {
  //   final picker = ImagePicker();
  //   XFile? pickedFile = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile!.path);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   DisplayPictureScreen(imagePath: imageFile.path)));
  //     });
  //   }
  // }

  // /// Get from Camera
  // _getFromCamera() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile!.path);
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   DisplayPictureScreen(imagePath: imageFile.path)));
  //     });
  //   }
  // }
}

