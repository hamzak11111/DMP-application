import 'package:dmp_app/data/Prescription.dart';
import 'package:flutter/material.dart';
import 'package:dmp_app/pages/p_details/p_details_widget.dart';

import '../../index.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CustomTile extends StatelessWidget {
  final Prescription prescription;

  CustomTile({required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDetailsWidget(prescription: prescription),
            ),
          );
        },
      
        title: Text(
          'Doctor: ${prescription.doctorName} \nDate of Visit: ${prescription.dateOfVisit?.year.toString()}-${prescription.dateOfVisit?.month.toString()}-${prescription.dateOfVisit?.day.toString()}',
          style: FlutterFlowTheme.of(context).labelMedium,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 20.0,
        ),
      ),
    );
  }
}
