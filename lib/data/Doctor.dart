class Doctor {
  String email;
  String? password;
  String fullName;
  String gender;
  String dob;
  String? securityQuestion;
  String? securityAnswer;
  String role;
  String employeeId;
  String hospitalId;
  String specialization;
  int age;

  Doctor({
    required this.email,
    this.password,
    required this.fullName,
    required this.gender,
    required this.dob,
    this.securityQuestion,
    this.securityAnswer,
    required this.role,
    required this.employeeId,
    required this.hospitalId,
    required this.specialization,
    this.age = 0,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      email: json['profile']['email'],
      fullName: json['profile']['fullName'],
      gender: json['profile']['gender'],
      dob: json['profile']['DOB'],
      role: json['profile']['role'],
      employeeId: json['profile']['EmployeeId'],
      hospitalId: json['profile']['hospital_id'],
      specialization: json['profile']['specialization'],
      age: json['profile']['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      'gender': gender,
      'DOB': dob,
      'securityQuestion': securityQuestion,
      'securityAnswer': securityAnswer,
      'role': role,
      'EmployeeId': employeeId,
      'hospital_id': hospitalId,
      'specialization': specialization,
    };
  }
}
