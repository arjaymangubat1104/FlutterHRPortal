import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/models/user_model.dart';
import 'package:flutter_attendance_system/viewmodel/auth_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:intl/intl.dart';

class AttendanceViewModel extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthViewModel authViewModel;
  final TimeDateViewModel timeDateViewModel;

  AttendanceViewModel ({required this.authViewModel, required this.timeDateViewModel});

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<UserAttendanceModel> _attendanceList = [];
  List<UserAttendanceModel> get attendanceList => _attendanceList;

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

  Future<void> fetchUserAttendance(DateTime date) async {
    try {
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      QuerySnapshot attendanceQuery = await _firestore.collection('attendance')
        .where('user_id', isEqualTo: userModel.uid)
        .where('attendance_date', isEqualTo: formattedDate)
        .orderBy('attendance_date', descending: true)
        .get();
      _attendanceList = attendanceQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserAttendanceModel.fromJson(data);
      }).toList();
      notifyListeners();
      _isSuccessFetch = true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  String statusMessage() {
    if (_attendanceList.isNotEmpty) {
      String? timeIn = _attendanceList.first.timeIn;
      String? timeOut = _attendanceList.first.timeOut;
      if((timeIn != null && timeIn.isNotEmpty) && (timeOut == null || timeOut.isEmpty)) {
        return 'You have timed in today, Pending time out...';
      }
      else if((timeIn != null && timeIn.isNotEmpty) && (timeOut != null && timeOut.isNotEmpty)) {
        return 'You have timed in and out today';
      }
    }
    return 'You have not timed in today';
  }

  // Method to get the latest time in and convert it to 12-hour format
  String getLatestTimeIn() {
    if (_attendanceList.isNotEmpty) {
      String? timeIn = _attendanceList.first.timeIn;
      if (timeIn != null && timeIn.isNotEmpty) {
        DateTime parsedTime = DateFormat('HH:mm:ss').parse(timeIn);
        return DateFormat('hh:mm:ss a').format(parsedTime);
      }
    }
    return 'Pending time in...';
  }

  // Method to get the latest time out and convert it to 12-hour format
  String getLatestTimeOut() {
    if (_attendanceList.isNotEmpty) {
      String? timeOut = _attendanceList.first.timeOut;
      if (timeOut != null && timeOut.isNotEmpty) {
        DateTime parsedTime = DateFormat('HH:mm:ss').parse(timeOut);
        return DateFormat('hh:mm:ss a').format(parsedTime);
      }
    }
    return 'Pending time out...';
  }

}

