import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/models/user_model.dart';
import 'package:flutter_attendance_system/viewmodel/auth_view_model.dart';
import 'package:intl/intl.dart';

class AttendanceViewModel extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthViewModel authViewModel;

  AttendanceViewModel ({required this.authViewModel});

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSuccessInOut = false;
  bool _isSuccessFetch = false;

  bool get isSuccessInOut => _isSuccessInOut;
  bool get isSuccessFetch => _isSuccessFetch;

  set isSuccessInOut(bool value) {
    _isSuccessInOut = value;
    notifyListeners();
  }

  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  Future<void> timeIn() async {
    try {
      _checkInTime = DateTime.now();
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }

      QuerySnapshot attendanceQuery = await _firestore.collection('attendance')
        .where('user_id', isEqualTo: userModel.uid)
        .where('attendance_date', isEqualTo: DateFormat('yyyy-MM-dd').format(_checkInTime!))
        .get();

      if (attendanceQuery.docs.isNotEmpty) {
        throw Exception("You've already timed in today");
      }

      UserAttendanceModel attendance = UserAttendanceModel(
        id: _firestore.collection('attendance').doc().id,
        userId: userModel.uid,
        userName: userModel.displayName,
        attendanceStatus: 'AWOL',
        attendanceDate: DateFormat('yyyy-MM-dd').format(_checkInTime!),
        timeIn: DateFormat('HH:mm:ss').format(_checkInTime!),
        timeOut: '',
      );
      await _firestore.collection('attendance').doc(attendance.id).set(attendance.toJson());
      _isSuccessInOut = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isSuccessInOut = false;
      notifyListeners();
    }
  }

  Future<void> timeOut() async {
    try {
      _checkOutTime = DateTime.now();
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      QuerySnapshot attendanceQuery = await _firestore.collection('attendance')
        .where('user_id', isEqualTo: userModel.uid)
        .where('attendance_date', isEqualTo: DateFormat('yyyy-MM-dd').format(_checkOutTime!))
        .get();
      if (attendanceQuery.docs.isNotEmpty) {
        DocumentSnapshot doc = attendanceQuery.docs.first;
         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['time_out'] != null && data['time_out'].isNotEmpty) {
          throw Exception("You've already timed out today");
        }
        await _firestore.collection('attendance').doc(doc.id).update({
          'time_out': DateFormat('HH:mm:ss').format(_checkOutTime!),
        });
        _isSuccessInOut = true;
        notifyListeners();
      } else {
        throw Exception("Time in not recorded");
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isSuccessInOut = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserAttendance() async {
    try {
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      QuerySnapshot attendanceQuery = await _firestore.collection('attendance')
        .where('user_id', isEqualTo: userModel.uid)
        .orderBy('attendance_date', descending: true)
        .get();
      List<UserAttendanceModel> userAttendanceList = attendanceQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserAttendanceModel.fromJson(data);
      }).toList();
      _userModel?.attendanceList = userAttendanceList;
      notifyListeners();
      _isSuccessFetch = true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Method to get the latest time in
  String getLatestTimeIn() {
    if (_userModel != null && _userModel!.attendanceList.isNotEmpty) {
      return _userModel!.attendanceList.first.timeIn ?? 'Not Available';
    }
    return 'Not Available';
  }

  // Method to get the latest time out
  String getLatestTimeOut() {
    if (_userModel != null && _userModel!.attendanceList.isNotEmpty) {
      return _userModel!.attendanceList.first.timeOut ?? 'Not Available';
    }
    return 'Not Available';
  }


}
