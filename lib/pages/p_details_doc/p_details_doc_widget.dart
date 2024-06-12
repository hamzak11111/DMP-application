import 'package:dmp_app/data/Prescription.dart';
import 'package:dmp_app/urls.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PDetailsDocWidget extends StatefulWidget {
  final Prescription prescription;
  final VoidCallback? onBack;

  PDetailsDocWidget({required this.prescription, this.onBack});

  @override
  _PDetailsDocWidgetState createState() => _PDetailsDocWidgetState();
}

class _PDetailsDocWidgetState extends State<PDetailsDocWidget> {
  late Future<void> _updatePrescriptionSeen;

  @override
  void initState() {
    super.initState();
    _updatePrescriptionSeen = _updateSeenStatus();
  }

  Future<void> _updateSeenStatus() async {
    try {
      final Dio dio = Dio();
      await dio.post(APPROVE_PRESCRIPTION, data: {
        "doctorName": widget.prescription.doctorName,
  "patientName": widget.prescription.patientName,
  "age": widget.prescription.patientAge,
  "gender": widget.prescription.patientGender,
  "date": widget.prescription.dateOfVisit?.toIso8601String(),
  "Diagnosis": widget.prescription.diagnosis,
  "BP": widget.prescription.bloodPressure,
  "TEMP": widget.prescription.temperature,
  "Weight": widget.prescription.weight,
  "History": widget.prescription.history,
  "doctor": widget.prescription.doctorEmpId,
  "patient": widget.prescription.patientMrNo,
  "medicinesList":widget.prescription.medicines,
  "approved": widget.prescription.approved,
  "prescriptionId": widget.prescription.id,
  "seen": "true"});
    } catch (e) {
      // Handle Dio errors or network failures
      print('Error updating prescription seen status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prescription fields
    var patientName = widget.prescription.patientName;
    var dateOfVisit = widget.prescription.dateOfVisit!.year.toString() +
        '-' +
        widget.prescription.dateOfVisit!.month.toString() +
        '-' +
        widget.prescription.dateOfVisit!.day.toString();
    var diagnosis = widget.prescription.diagnosis;
    var bloodPressure = widget.prescription.bloodPressure;
    var temperature = widget.prescription.temperature ?? 0;
    var weight = widget.prescription.weight ?? 0;
    var history = widget.prescription.history;
    var medicines = widget.prescription.medicines;

    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details'),
        backgroundColor: Color(0xFF01B8E0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.onBack?.call();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
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
                        'Patient: $patientName',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Date of Visit: $dateOfVisit'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Diagnosis: $diagnosis'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('BP: $bloodPressure'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Gender: ${widget.prescription.patientGender}'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Temperature: $temperature'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Weight: $weight'),
                      SizedBox(
                        height: 10,
                      ),
                      Text('History: $history'),
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
                      ...medicines!.map<Widget>((medicine) {
                        return ListTile(
                          title: Text('${medicine.name} (${medicine.power})'),
                          subtitle: Text('${medicine.type} - ${medicine.dose}'),
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
    );
  }
}
