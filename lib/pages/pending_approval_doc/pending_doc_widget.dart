import 'package:dio/dio.dart';
import 'package:dmp_app/data/Prescription.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:dmp_app/pages/pending_approval_doc/pending_doc_mode.dart';
import '../../urls.dart';
import '../p_details_doc/p_details_doc_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class PendingDocWidget extends StatefulWidget {
  final String email;

final Function callback;

  const PendingDocWidget({
    Key? key,
    required this.email,
    required this.callback,
  }) : super(key: key);
  @override
  _PendingDocWidgetState createState() => _PendingDocWidgetState();
}

class _PendingDocWidgetState extends State<PendingDocWidget> {
  late PendingRecordsDocModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Prescription> prescriptions = []; // Changed type to List<Prescription>
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PendingRecordsDocModel());
    fetchPrescriptions();
  }

  void showValidationMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 6,
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


  Future<void> fetchPrescriptions() async {
    try {
      var response = await dio.get(GET_DOCTORS_PRESCRIPTION,
          data: {"email": widget.email}); // Changed to queryParameters
      if (response.data['success']) {
        //print(response.data['prescriptions']);
        List<Prescription> pres = [];

        for (var presData in response.data['prescriptions']) {
          print(presData);
          Prescription prescription = Prescription.fromJson(presData);
          if (prescription.approved == "False") {
            pres.add(prescription);
          }
        }
        if (response.statusCode == 200) {
          setState(() {
            prescriptions = pres;
          });
        } else {
          print('Failed to fetch prescriptions.');
        }
      } else {
        showValidationMessage(context, response.data['msg']);
      }
    } catch (e) {
      showValidationMessage(context, e.toString());
    }
  }

  void showPrescriptionDetailsDialog(Prescription prescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prescription Details'),
          content: SizedBox(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(
                children: [
                  Center(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Patient: $prescription.patientName',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                'Date of Visit: ${prescription.dateOfVisit?.year}-${prescription.dateOfVisit?.month}-${prescription.dateOfVisit?.day}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Diagnosis: ${prescription.diagnosis}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('BP: ${prescription.bloodPressure}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Gender: ${prescription.patientGender}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Temperature: ${prescription.temperature}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Weight: ${prescription.weight}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('History: ${prescription.history}'),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Medicines:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            ...prescription.medicines!.map<Widget>((medicine) {
                              return ListTile(
                                title: Text(
                                    '${medicine.name} (${medicine.power})'),
                                subtitle:
                                    Text('${medicine.type} - ${medicine.dose}'),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showPrescriptionDetailsBottomSheet(Prescription prescription) {
    TextEditingController patientNameController =
        TextEditingController(text: prescription.patientName);
    TextEditingController diagnosisController =
        TextEditingController(text: prescription.diagnosis);
    TextEditingController genderController =
        TextEditingController(text: prescription.patientGender);
    TextEditingController bloodPressureController =
        TextEditingController(text: prescription.bloodPressure);
    TextEditingController temperatureController =
        TextEditingController(text: prescription.temperature);
    TextEditingController weightController =
        TextEditingController(text: prescription.weight);
    TextEditingController historyController =
        TextEditingController(text: prescription.patientAge);
    TextEditingController dateController = TextEditingController(
        text:
            '${prescription.dateOfVisit?.year}-${prescription.dateOfVisit?.month}-${prescription.dateOfVisit?.day}');

    // List of controllers for medicines
    List<TextEditingController> medicineNameControllers = [];
    List<TextEditingController> medicineDoseControllers = [];
    List<TextEditingController> medicinePowerControllers = [];
    List<TextEditingController> medicineTypeControllers = [];
    // Initialize the medicine controllers
    for (var medicine in prescription.medicines!) {
      medicineNameControllers.add(TextEditingController(text: medicine.name));
      medicineDoseControllers.add(TextEditingController(text: medicine.dose));
      medicinePowerControllers.add(TextEditingController(text: medicine.power));
      medicineTypeControllers.add(TextEditingController(text: medicine.type));
    }

    List<Row> medicineRows =
        prescription.medicines!.asMap().entries.map((entry) {
      int index = entry.key;
      Medicine medicine = entry.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
                    Expanded(
            child: TextField(
              controller: medicineTypeControllers[index],
              decoration: InputDecoration(
                hintText: 'Type',
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          // Medicine Name
          Expanded(
            child: TextField(
              controller: medicineNameControllers[index],
              decoration: InputDecoration(
                hintText: 'Name',
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          // Medicine Power
          Expanded(
            child: TextField(
              controller: medicinePowerControllers[index],
              decoration: InputDecoration(
                hintText: 'Power',
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          // Medicine Type

          // Medicine Dose
          Expanded(
            child: TextField(
              controller: medicineDoseControllers[index],
              decoration: InputDecoration(
                hintText: 'Dose',
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ],
      );
    }).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Controllers for each editable field

        // Using a custom input decoration that makes the text fields look less like form fields
        InputDecoration customDecoration = InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        );

        // Modify the medicines section

        return Wrap(children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: patientNameController,
                        decoration:
                            customDecoration.copyWith(labelText: 'Patient'),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: dateController,
                        decoration: customDecoration.copyWith(
                            labelText: 'Date of Visit'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: diagnosisController,
                        decoration:
                            customDecoration.copyWith(labelText: 'Diagnosis'),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: genderController,
                        decoration:
                            customDecoration.copyWith(labelText: 'Gender'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: bloodPressureController,
                        decoration: customDecoration.copyWith(labelText: 'BP'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: temperatureController,
                        decoration:
                            customDecoration.copyWith(labelText: 'Temperature'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: weightController,
                        decoration:
                            customDecoration.copyWith(labelText: 'Weight'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: historyController,
                        decoration:
                            customDecoration.copyWith(labelText: 'Age'),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      Text('Medicines:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 133, 215))),
                      SizedBox(height: 10),
                      ...medicineRows,
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.05),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            showLoadingIndicator: true,
                            onPressed: () async {
                              var dio =
                                  Dio(); // Ensure Dio is properly initialized and configured

                              // Collecting data from controllers
                              Map<String, dynamic> updatedPrescriptionData = {
                                'prescriptionId': prescription.id, // Assuming 'id' is the field used to identify the prescription
                                'patientName': patientNameController.text,
                                'DateOfVisit': dateController.text,
                                'Diagnosis': diagnosisController.text,
                                'patientGender': genderController.text,
                                'BP': bloodPressureController.text,
                                'TEMP': temperatureController.text,
                                'Weight': weightController.text,
                                'age': historyController.text,
                                'medicines': List.generate(prescription.medicines!.length, (index) {
                                  return {
                                    'name': medicineNameControllers[index].text,
                                    'dose': medicineDoseControllers[index].text,
                                    'power': medicinePowerControllers[index].text,
                                    'type': medicineTypeControllers[index].text,
                                  };
                                }),
                                'approved': 'True', // Explicitly setting the 'approved' status to True
                              };


                              try {
                                // Sending the updated data to the backend
                               
                                var response = await dio.post(
                                    APPROVE_PRESCRIPTION,
                                    data: updatedPrescriptionData);
                                if (response.data['success']) {
                                  showValidationMessage(
                                      context, response.data['msg']);
                                  fetchPrescriptions();
                                  
                           
                                  Navigator.pop(
                                      context); // Dismiss bottom modal sheet
                                } else {
                                  showValidationMessage(
                                      context, response.data['msg']);
                                    
                                  Navigator.pop(
                                      context); // Dismiss bottom modal sheet if there's an error
                                }
                              } catch (e) {
                                showValidationMessage(
                                    context, 'Error occurred: ${e.toString()}');
                                  widget.callback();
                                Navigator.pop(
                                    context); // Ensuring the modal is dismissed even in case of error
                              }
                            },
                            text: 'Approve',
                            options: FFButtonOptions(
                              width: 340.0,
                              height: 60.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF01B8E0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
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
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.05),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            showLoadingIndicator: true,
                            onPressed: () async {
                              var dio = Dio();
                              var response =
                                  await dio.post(DELETE_PRESCRIPTION, data: {
                                "id": prescription.id,
                              });
                              if (response.data['success']) {
                                showValidationMessage(
                                    context, response.data['msg']);
                                fetchPrescriptions();
                                // dismiss bottom modalsheet
                                Navigator.pop(context);
                              } else {
                                showValidationMessage(
                                    context, response.data['msg']);
                                Navigator.pop(context);
                              }
                            },
                            text: 'Reject',
                            options: FFButtonOptions(
                              width: 340.0,
                              height: 60.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF01B8E0),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
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
            ),
          ),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 110, 194, 1),
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              widget.callback();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left_rounded,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 24.0,
            ),
          ),
          title: Text(
            'Prescriptions',
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'DM Sans',
                  color: Colors.white,
                  fontSize: 25
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: prescriptions.length,
                  itemBuilder: (context, index) {
                    final Prescription prescription = prescriptions[index];

                    return ListTile(
                      onTap: () {
                        showPrescriptionDetailsBottomSheet(prescription);
                      },
                      title: Text(
                        prescription.patientName ??
                            '', // Directly using diagnosis with null-aware operator
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                      subtitle: Text(
                        'Diagnosis: ${prescription.diagnosis} \nDate of Visit: ${prescription.dateOfVisit?.year.toString()}-${prescription.dateOfVisit?.month.toString()}-${prescription.dateOfVisit?.day.toString()}', // Adjusted to directly use properties
                        style: FlutterFlowTheme.of(context).labelMedium,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 20.0,
                      ),
                      tileColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      dense: false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
