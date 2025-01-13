import 'package:flutter_attendance_system/models/attendance_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  List<UserAttendanceModel> attendanceList;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.attendanceList = const [], // Initialize with an empty list
  });

  factory UserModel.fromFirebase(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      attendanceList: data['attendanceList'] != null
          ? (data['attendanceList'] as List)
              .map((item) => UserAttendanceModel.fromJson(item))
              .toList()
          : [],
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'attendanceList': attendanceList.map((item) => item.toJson()).toList(),
    };
  }
}