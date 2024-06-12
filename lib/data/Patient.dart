class Patient {
  String email;
  String? password;
  String fullName;
  String gender;
  String dob;
  String? securityQuestion;
  String? securityAnswer;
  String role;
  String mrNo;
  int age;

  Patient({
    required this.email,
    this.password,
    required this.fullName,
    required this.gender,
    required this.dob,
    this.securityQuestion,
    this.securityAnswer,
    required this.role,
    required this.mrNo,
    this.age = 0,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      email: json['profile']['email'],
      password: json['profile']['password'],
      fullName: json['profile']['fullName'],
      gender: json['profile']['gender'],
      dob: json['profile']['DOB'],
      securityQuestion: json['profile']['securityQuestion'],
      securityAnswer: json['profile']['securityAnswer'],
      role: json['profile']['role'],
      mrNo: json['profile']['MrNo'],
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
      'MrNo': mrNo,
    };
  }
}
