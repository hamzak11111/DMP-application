import 'package:dio/dio.dart';
import 'package:dmp_app/data/Prescription.dart';

import '../p_details_doc/p_details_doc_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'patient_doc_record_model.dart';
export 'patient_doc_record_model.dart';

class PatientsDocRecordWidget extends StatefulWidget {
  final String patientMrNo;
  final List<Prescription> prescriptions;

  const PatientsDocRecordWidget(
      {Key? key, required this.patientMrNo, required this.prescriptions})
      : super(key: key);
  @override
  _PatientsDocRecordWidgetState createState() =>
      _PatientsDocRecordWidgetState();
}

class _PatientsDocRecordWidgetState extends State<PatientsDocRecordWidget> {
  late RecordsDocModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => RecordsDocModel());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            'Prescriptions',
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'DM Sans',
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
              Expanded(
                child: ListView.builder(
                  itemCount: widget.prescriptions.length,
                  itemBuilder: (context, index) {
                    final prescription = widget.prescriptions[index];
                    if (prescription.patientMrNo == widget.patientMrNo) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PDetailsDocWidget(
                                      prescription: prescription)));
                        },
                        title: Text(
                          prescription.patientName ?? '', // use the correct key
                          style: FlutterFlowTheme.of(context).titleLarge,
                        ),
                        subtitle: Text(
                          'Date of Visit: ${prescription.dateOfVisit?.year.toString()}-${prescription.dateOfVisit?.month.toString()}-${prescription.dateOfVisit?.day.toString()}',
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
                    } else {
                      return Container();
                    }
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
