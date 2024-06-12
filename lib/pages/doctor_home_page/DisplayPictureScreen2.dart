import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dmp_app/data/Prescription.dart';
import 'package:dmp_app/data/PrescriptionPredict.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_theme.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:dmp_app/pages/p_details_doc/p_details_doc_widget.dart';
import 'package:dmp_app/urls.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String email;
  final List<String> docnames;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.email,
    required this.docnames,
  }) : super(key: key);


  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late TextEditingController doctorController;

  @override
  void initState() {
    super.initState();
    doctorController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    void showValidationMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      padding: const EdgeInsets.all(16),
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        "Your perscription has been sent to doctor for verification",  // Use the provided message parameter here
        style: const TextStyle(fontSize: 18, color: Colors.white),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    ),
  ));

  // Delay before popping the context to allow the user to see the message
  Future.delayed(Duration(seconds: 2), () {
    Navigator.pop(context);
  });
}
  String? initialValue;
 Future<void> runModel() async {
      File imageFile = File(widget.imagePath);
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      Dio dio = Dio();

      try {
        var response = await dio.post(predictURL, data: formData);
        var responseData;
if (response.data is String) {
          responseData = jsonDecode(response.data);
          print(responseData);
        } else {
          responseData = response.data as Map<String, dynamic>;
        }
        PrescriptionPredict returnedPrescription =
            PrescriptionPredict.fromJson(responseData as Map<String, dynamic>);

        print("returned perscritption:");
        print(returnedPrescription);
        print("PrescriptionPredict parsed successfully");

        var createPres = await dio.post(CREATE_PRESCRIPTION_URL,
            data: {
    ...returnedPrescription.toJson(email: widget.email),
    'docname': doctorController.text,
  },);


        print("createPres data: ${createPres.data}");
        if (createPres.data['success']) {
          print('ok');
          // get prescription by id:
          var res = await dio.get(GET_PRESCRIPTION_BY_ID,
              queryParameters: {'id': createPres.data['prescriptionId']});
          print("Received prescription data: ${res.data}");
          // create a prescription object based on returned data:
          Prescription finalPres =
              Prescription.fromJson(res.data['prescription']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDetailsDocWidget(prescription: finalPres),
            ),
          );
          // use the final prescription now for testing just print values for now:
        }
      } catch (e) {
        print('Error occurred: $e');
        showValidationMessage(context, e.toString());
        return null;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display the Picture'),
        backgroundColor: Color.fromRGBO(0, 110, 194, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: widget.imagePath == ""
                ? Container()
                : Image.file(File(widget.imagePath)),
          ),
          buildDoctorNameField(context, widget.docnames),
          FFButtonWidget(
            showLoadingIndicator: true,
            text: 'Use This Picture',
            onPressed: () async {
              await runModel();
            },
            options: FFButtonOptions(
              textStyle: const TextStyle(color: Colors.white),
              elevation: 5,
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDoctorNameField(BuildContext context, List<String> doctorNames) {

    String? initialValue = doctorNames.contains(doctorController.text)
        ? doctorController.text
        : null;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 12.0),
      child: DropdownButtonFormField<String>(
        value: initialValue, // Set the initial value only if it's in the list
        onChanged: (String? newValue) {
          setState(() {
            doctorController.text = newValue ?? '';
          });
        },
        items: doctorNames.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: FlutterFlowTheme.of(context).bodyText1),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Doctor Name',
          hintText: 'Select a doctor',
          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 0.0, 24.0),
        ),
      ),
    );
  }
}
