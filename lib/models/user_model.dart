
class UserModel {
  final String uid;
  final String email;
  final String? userName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final String? civilStatus;
  final String? birthDate;
  UserModel({
    required this.uid,
    required this.email,
    this.userName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.civilStatus,
    this.birthDate,
  });

  factory UserModel.fromFirebase(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      userName: data['user_name'] ?? '',
      firstName: data['first_name'] ?? '',
      middleName: data['middle_name'] ?? '',
      lastName: data['last_name'] ?? '',
      gender: data['gender'] ?? '',
      civilStatus: data['civil_status'] ?? '',
      birthDate: data['birth_date'] ?? '',
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'user_name': userName,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'gender': gender,
      'civil_status': civilStatus,
      'birth_date': birthDate,
    };
  }
}