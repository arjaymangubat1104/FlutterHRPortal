
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
  });

  factory UserModel.fromFirebase(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'],
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
    };
  }
}