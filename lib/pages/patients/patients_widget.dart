import 'package:dio/dio.dart';
import 'package:dmp_app/data/Prescription.dart';
import 'package:dmp_app/pages/patient_doc_record/patient_doc_record_widget.dart';
import 'package:dmp_app/pages/patients/patients_model.dart';

import '../../urls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
export 'patients_model.dart';

class PatientsWidget extends StatefulWidget {
  final String email;

  const PatientsWidget({Key? key, required this.email}) : super(key: key);
  @override
  _PatientsWidgetState createState() => _PatientsWidgetState();
}

class _PatientsWidgetState extends State<PatientsWidget> {
  late PatientsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Prescription> prescriptions = [];
  List<Prescription> patients = [];
  List<Prescription> filteredPatients = [];
  final Dio dio = Dio();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PatientsModel());
    fetchPrescriptions();
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

  Future<void> fetchPrescriptions() async {
    try {
      var response = await dio
          .get(GET_DOCTORS_PRESCRIPTION, data: {"email": widget.email});
      if (response.data['success']) {
        var tempPrescriptions = (response.data['prescriptions'] as List)
            .map((e) => Prescription.fromJson(e))
            .toList();

        Map<String, List<Prescription>> aggregatedPrescriptions = {};
        for (var prescription in tempPrescriptions) {
          aggregatedPrescriptions.update(
            prescription.patientMrNo ?? '',
            (list) => list..add(prescription),
            ifAbsent: () => [prescription],
          );
        }

        setState(() {
          prescriptions = tempPrescriptions;
          patients = aggregatedPrescriptions.entries
              .map((e) => e.value.first)
              .toList();
          filteredPatients = patients;
        });
      } else {
        showValidationMessage(context, response.data['msg']);
      }
    } catch (e) {
      showValidationMessage(context, e.toString());
      print('Error: $e');
    }
  }

  void changeFilteredPatients(String query) {
    setState(() {
      filteredPatients = patients.where((patient) {
        return patient.patientName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      }).toList();
    });
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
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left_rounded,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 24.0,
            ),
          ),
          title: Text(
            'Patients',
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
        // ... other properties ...
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    changeFilteredPatients(value);
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                      // labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PatientsDocRecordWidget(
                                    patientMrNo: patient.patientMrNo ?? '',
                                    prescriptions: prescriptions)));
                      },
                      title: Text(
                        patient.patientName ?? '',
                        style: FlutterFlowTheme.of(context).titleLarge,
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
