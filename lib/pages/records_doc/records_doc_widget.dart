import 'package:dio/dio.dart';
import 'package:dmp_app/data/Prescription.dart';
import '../../urls.dart';
import '../p_details_doc/p_details_doc_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'records_doc_model.dart';
export 'records_doc_model.dart';

class RecordsDocWidget extends StatefulWidget {
  final String email;

  const RecordsDocWidget({Key? key, required this.email}) : super(key: key);
  @override
  _RecordsDocWidgetState createState() => _RecordsDocWidgetState();
}

class _RecordsDocWidgetState extends State<RecordsDocWidget> {
  late RecordsDocModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Prescription> prescriptions = []; // Changed type to List<Prescription>
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecordsDocModel());
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
      var response = await dio.get(GET_DOCTORS_PRESCRIPTION,
          data: {"email": widget.email}); // Changed to queryParameters
      if (response.data['success']) {
        //print(response.data['prescriptions']);
        List<Prescription> pres = [];

        for (var presData in response.data['prescriptions']) {
          print(presData);
          Prescription prescription = Prescription.fromJson(presData);
          if (prescription.approved == "True") {
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

                    
                    print(prescription.seen);

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PDetailsDocWidget(
                                    prescription: prescription,onBack: () {
                                  fetchPrescriptions(); // Example: Refresh prescriptions list
                                },)));
                      },
                      title: Text(
                        prescription.patientName ??
                            '', // Directly using diagnosis with null-aware operator
                        style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                          color: prescription.seen == "true" ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Diagnosis: ${prescription.diagnosis} \nDate of Visit: ${prescription.dateOfVisit?.year.toString()}-${prescription.dateOfVisit?.month.toString()}-${prescription.dateOfVisit?.day.toString()}', // Adjusted to directly use properties
                        style: FlutterFlowTheme.of(context).labelMedium.copyWith(
                          color: prescription.seen == "true" ? Colors.grey : Colors.black,
                        ),
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
