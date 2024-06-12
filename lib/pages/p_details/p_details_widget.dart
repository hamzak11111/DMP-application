import 'package:dmp_app/data/Prescription.dart';
import 'package:flutter/material.dart';
export 'p_details_model.dart';

class PDetailsWidget extends StatelessWidget {
  final Prescription prescription;

  PDetailsWidget({required this.prescription});

  @override
  Widget build(BuildContext context) {
    var medicines = prescription.medicines;
print(prescription);
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details'),
        backgroundColor: Color(0xFF01B8E0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctor: ${prescription.doctorName}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        'Date of Visit: ${prescription.dateOfVisit?.year.toString()}-${prescription.dateOfVisit?.month.toString()}-${prescription.dateOfVisit?.day.toString()}'),
                    SizedBox(height: 10),
                    Text(
                      'Diagnosis: ${prescription.diagnosis}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text('Gender: ${prescription.patientGender}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text('BP: ${prescription.bloodPressure}'),
                    SizedBox(height: 10),
                    Text('Temperature: ${prescription.temperature}'),
                    SizedBox(height: 10),
                    Text('Weight: ${prescription.weight}'),
                    SizedBox(height: 10),
                    Text('Age: ${prescription.patientAge}'),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
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
          ],
        ),
      ),
    );
  }
}
