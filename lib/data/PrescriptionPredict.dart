class PrescriptionPredict {
  final String? bp;
  final List<String>? diagnosisHistory;
  final List<String>? tests;
  final String? temp;
  final String? weight;
  final String? age;
  final String? date;
  final String? gender;
  final String? name;
  final List<Medicine>? medicines;

  PrescriptionPredict({
    required this.bp,
    required this.diagnosisHistory,
    required this.tests,
    required this.temp,
    required this.weight,
    required this.age,
    required this.date,
    required this.gender,
    required this.medicines,
    required this.name,
  });

  factory PrescriptionPredict.fromJson(Map<String, dynamic> json) {
    print("Parsing JSON...");

    // Ensure json['MEDICINE BLOCK'] is a list
    var meds = json['MEDICINE BLOCK'] as List;
    List<Medicine> medicinesList = meds.map<Medicine>((i) {
      print("Parsing medicine: $i");
      return Medicine.fromJson(i as Map<String, dynamic>);
    }).toList();

    List<String> diagnosisHistoryList = [];
    List<String> testList = [];
    String? bp;
    String? temp;
    String? weight;

    for (var item in json['DIAG BLOCK']) {
      print("Parsing DIAG BLOCK item: $item");
      if (item.containsKey('Diagnosis/History')) {
        print("Found Diagnosis/History");
        diagnosisHistoryList.add(item['Diagnosis/History']);
      } else if (item.containsKey('BP')) {
        print("Found BP");
        bp = item['BP'];
      }
       else if (item.containsKey('Temp')) {
        print("Found BP");
        temp = item['Temp'];
      }
       else if (item.containsKey('Weight')) {
        print("Found BP");
        weight = item['Weight'];
      }


       else if (item.containsKey('Test')) {
        print("Found Test");
        testList.add(item['Test']);
      }
    }

    print("Parsed JSON successfully");
    return PrescriptionPredict(
      bp: bp,
      diagnosisHistory: diagnosisHistoryList,
      tests: testList,
      temp: temp,
      weight: weight,
      age: json['patient info']['AGE'],
      date: json['patient info']['DATE'],
      gender: json['patient info']['GENDER'],
      name: json['patient info']['NAME'],
      medicines: medicinesList,
    );
  }

  Map<String, dynamic> toJson({required String email}) {
    List<Map> medicinesJson = this.medicines!.map((i) => i.toJson()).toList();

    // Concatenate diagnosis entries into a single string
    String diagnosisString = diagnosisHistory!.join(', ');

    return {
      'age': age,
      'gender': gender,
      'visitDate': date,
      'diagnosis': diagnosisString,
      'bp': bp,
      'temp': temp,
      'weight': weight,
      'tests': tests,
      'email': email,
      'patientName': name,
      'medicines': medicinesJson,
    };
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
    print("Parsing Medicine JSON: $json");
    return Medicine(
      name: json['MEDICINE NAME'],
      power: json['MEDICINE POWER'] ?? '',
      type: json['MEDICINE TYPE'],
      dose: json['MEDICINE DOSE'],
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
