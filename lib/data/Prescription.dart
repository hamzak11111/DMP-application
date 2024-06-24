import 'dart:ffi';

import 'package:dmp_app/flutter_flow/flutter_flow_util.dart';

class Prescription {
  final String? doctorName;
  final String? patientName;
  final String? patientAge; // Nullable
  final String? patientGender; // Nullable
  final DateTime? dateOfVisit;
  final String? diagnosis;
  final String? bloodPressure;
  final String? temperature;
  final String? weight;
  final String? history;
  final String? doctorEmpId;
  final String? patientMrNo;
  final List<Medicine>? medicines;
  final String approved;
  String seen;
  String unapproved_seen;
  final int id;

  Prescription(
      {required this.doctorName,
      required this.patientName,
      required this.patientAge, // Nullable
      required this.patientGender, // Nullable
      required this.dateOfVisit,
      required this.diagnosis,
      required this.bloodPressure,
      required this.temperature,
      required this.weight,
      required this.history,
      required this.doctorEmpId,
      required this.patientMrNo,
      required this.medicines,
      required this.approved,
      required this.id,
      required this.seen,
      required this.unapproved_seen});

  factory Prescription.fromJson(Map<String, dynamic> json) {
    var meds = json['medicines'] as List;
    List<Medicine> medicinesList = meds.map<Medicine>((i) {
      return Medicine.fromJson(i as Map<String, dynamic>);
    }).toList();
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final DateTime date = format.parse(json['DateOfVisit']);

    // print("seen  ->  "+json['seen']);
    // print(json['seen']=="true");

    return Prescription(
        doctorName: json['doctorName'],
        patientName: json['patientName'],
        patientAge: json['age'],
        patientGender: json['gender'],
        dateOfVisit: date,
        diagnosis: json['Diagnosis'],
        bloodPressure: json['BP'],
        temperature: json['TEMP'],
        weight: json['Weight'],
        history: json['History'],
        doctorEmpId: json['doctor'],
        patientMrNo: json['patient'],
        medicines: medicinesList,
        approved: json['approved'],
        id: json['prescriptionId'],
        seen: json['seen']??"false",
        unapproved_seen: json['unapproved_seen']??"false");
  }

  Map<String, dynamic> toJson({
  required String age,
  required String gender,
  required String date,
  required String diagnosis,
  required String bp,
  required String temp,
  required String weight,
  required String history,
  required List<Medicine> meds,
  required bool approved,
}) {
  List<Map<String, dynamic>> medicinesJson = meds.map((medicine) => medicine.toJson()).toList();

  return {
    'doctorName': doctorName,
    'patientName': patientName,
    'age': age,
    'gender': gender,
    'visitDate': date,
    'Diagnosis': diagnosis,
    'BP': bp,
    'TEMP': temp,
    'Weight': weight,
    'History': history,
    'doctor': doctorEmpId,
    'patient': patientMrNo,
    'medicines': medicinesJson,
    'approved': approved,
    'id': id,
    'seen': seen,
  };
}

  void printDetails() {
    print('Doctor Name: $doctorName');
    print('Patient Name: $patientName');
    print('Patient Age: $patientAge');
    print('Patient Gender: $patientGender');
    print('Date of Visit: $dateOfVisit');
    print('Diagnosis: $diagnosis');
    print('Blood Pressure: $bloodPressure');
    print('Temperature: $temperature');
    print('Weight: $weight');
    print('History: $history');
    print('Doctor Employee ID: $doctorEmpId');
    print('Patient MR No: $patientMrNo');

    print('Medicines:');
    for (Medicine medicine in medicines!) {
      print(
          '  Name: ${medicine.name}, Power: ${medicine.power}, Type: ${medicine.type}, Dose: ${medicine.dose}');
    }
  }
}

class Medicine {
  final String name;
  final String power;
  final String type;
  final String dose;

  Medicine({
    required this.name,
    required this.power,
    required this.type,
    required this.dose,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      power: json['power'] ?? "",
      type: json['type'],
      dose: json['dose'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'power': power,
      'type': type,
      'dose': dose,
    };
  }
}
