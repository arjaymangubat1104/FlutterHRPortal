import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/models/user_model.dart';
import 'package:flutter_attendance_system/viewmodel/auth_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/schedule_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthViewModel authViewModel;
  final TimeDateViewModel timeDateViewModel;
  final ScheduleViewModel scheduleViewModel = ScheduleViewModel();

  AttendanceViewModel(
      {required this.authViewModel, required this.timeDateViewModel});

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

  List<UserAttendanceModel> _attendanceListCalendar = [];
  List<UserAttendanceModel> get attendanceListCalendar =>
      _attendanceListCalendar;

  set attendanceListCalendar(List<UserAttendanceModel> value) {
    _attendanceListCalendar = value;
    notifyListeners();
  }

  List<String> _scheduleDays = [];
  List<String> get scheduleDays => _scheduleDays;

  set scheduleDays(List<String> value) {
    _scheduleDays = value;
    notifyListeners();
  }

  List<UserAttendanceModel> _activityAttendanceListCalendar = [];
  List<UserAttendanceModel> get activityAttendanceListCalendar =>
      _activityAttendanceListCalendar;

  set activityAttendanceListCalendar(List<UserAttendanceModel> value) {
    _activityAttendanceListCalendar = value;
    notifyListeners();
  }

  List<UserAttendanceModel> _attendanceList = [];
  List<UserAttendanceModel> get attendanceList => _attendanceList;
  set attendanceList(List<UserAttendanceModel> value) {
    _attendanceList = value;
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

      QuerySnapshot attendanceQuery = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userModel.uid)
          .where('attendance_date',
              isEqualTo: DateFormat('yyyy-MM-dd').format(_checkInTime!))
          .get(GetOptions(source: Source.cache));

      if (attendanceQuery.docs.isNotEmpty) {
        throw Exception("You've already timed in today");
      }

      String lateTime = '';
      String attendanceStatus = '';
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userModel.uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String scheduleIn = data['schedule_in'];
        String timeIn = DateFormat('HH:mm:ss').format(_checkInTime!);
        DateTime scheduleInDateTime = DateFormat('HH:mm:ss').parse(scheduleIn);
        DateTime timeInDateTime = DateFormat('HH:mm:ss').parse(timeIn);
        if (timeInDateTime.isAfter(scheduleInDateTime)) {
          lateTime = DateFormat('HH:mm:ss').format(
              DateTime(0).add(timeInDateTime.difference(scheduleInDateTime)));
        }
      }
      if (lateTime.isNotEmpty) {
        attendanceStatus = 'Late/Undertime';
      }
      UserAttendanceModel attendance = UserAttendanceModel(
        id: _firestore.collection('attendance').doc().id,
        userId: userModel.uid,
        userName: userModel.userName,
        attendanceStatus: attendanceStatus,
        attendanceDate: DateFormat('yyyy-MM-dd').format(_checkInTime!),
        timeIn: DateFormat('HH:mm:ss').format(_checkInTime!),
        timeOut: '',
        totalTime: '',
        lateTime: lateTime,
        underTime: '',
      );
      await _firestore
          .collection('attendance')
          .doc(attendance.id)
          .set(attendance.toJson());
      _isSuccessInOut = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isSuccessInOut = false;
      notifyListeners();
    }
  }

  Future<int> countDaysWithNoLoggedAttendance() async {
    try {
      // Fetch the user's schedule
      UserModel? userModel = authViewModel.userModel;

      DateTime now = DateTime.now();

      List<String> scheduledDaysOfWeek =
          await scheduleViewModel.getUserSchedule(userModel!.uid);

      // Generate the list of days in the current month
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      int count = 0;

      for (DateTime day = firstDayOfMonth;
          day.isBefore(lastDayOfMonth) || day.isAtSameMomentAs(lastDayOfMonth);
          day = day.add(Duration(days: 1))) {
        if (scheduledDaysOfWeek.contains(DateFormat('EEEE').format(day)) &&
            day.isBefore(now)) {
          QuerySnapshot attendanceQuery = await _firestore
              .collection('attendance')
              .where('user_id', isEqualTo: userModel.uid)
              .where('attendance_date',
                  isEqualTo: DateFormat('yyyy-MM-dd').format(day))
              .get(GetOptions(source: Source.cache));

          if (attendanceQuery.docs.isEmpty) {
            count++;
          }
        }
      }
      notifyListeners();
      return count;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return 0;
    }
  }

  Future<void> timeOut() async {
    try {
      _checkOutTime = DateTime.now();
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      QuerySnapshot attendanceQuery = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userModel.uid)
          .where('attendance_date',
              isEqualTo: DateFormat('yyyy-MM-dd').format(_checkOutTime!))
          .get(GetOptions(source: Source.cache));
      if (attendanceQuery.docs.isNotEmpty) {
        DocumentSnapshot doc = attendanceQuery.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['time_out'] != null && data['time_out'].isNotEmpty) {
          throw Exception("You've already timed out today");
        }
        await _firestore.collection('attendance').doc(doc.id).update({
          'time_out': DateFormat('HH:mm:ss').format(_checkOutTime!),
        });

        // Calculate hours worked
        DateTime timeIn = DateFormat('HH:mm:ss').parse(data['time_in']);
        DateTime timeOut = DateFormat('HH:mm:ss')
            .parse(DateFormat('HH:mm:ss').format(_checkOutTime!));
        Duration workedDuration = timeOut.difference(timeIn);

        // Fetch user's schedule (assuming you have a method to get the user's schedule)
        // Duration scheduledDuration =
        //     await _fetchUserScheduledDuration(userModel.uid);

        // Update the attendance record with the worked hours
        String adjustedWorkedDurationFormatted =
            getAdjustedWorkedDurationFormatted(workedDuration);
        await _firestore.collection('attendance').doc(doc.id).update({
          'total_time': adjustedWorkedDurationFormatted,
        });

        String underTime = '';
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('users').doc(userModel.uid).get();
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        String scheduleOut = userData['schedule_out'];
        String stringTimeout = DateFormat('HH:mm:ss').format(_checkOutTime!);
        DateTime scheduleOutDateTime =
            DateFormat('HH:mm:ss').parse(scheduleOut);
        DateTime timeOutDateTime = DateFormat('HH:mm:ss').parse(stringTimeout);
        if (timeOutDateTime.isBefore(scheduleOutDateTime)) {
          Duration durationOfUnderTime =
              scheduleOutDateTime.difference(timeOutDateTime);
          underTime = DateFormat('HH:mm:ss')
              .format(DateTime(0).add(durationOfUnderTime));
          await _firestore.collection('attendance').doc(doc.id).update({
            'under_time': underTime,
            'attendance_status': 'Late/Undertime',
          });
        }

        if (data['late_time'].isEmpty && underTime == '') {
          await _firestore.collection('attendance').doc(doc.id).update({
            'attendance_status': 'Present',
          });
        }

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

  Future<int> countPresents(
      {required int year, required int month, int? cutoffs}) async {
    try {
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      DateTime startDate = DateTime(year, month, 1); // Start date of the month
      DateTime endDate = DateTime(year, month + 1, 0); // Last day of the month
      if (cutoffs != null) {
        startDate = cutoffs == 15
            ? DateTime(year, month, 1)
            : DateTime(year, month, 16); // Start date of the month
        endDate = cutoffs == 15
            ? DateTime(year, month, 15)
            : DateTime(year, month + 1, 0); // Last day of the month
      }
      QuerySnapshot attendanceQuery = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userModel.uid)
          .where('attendance_status', isEqualTo: 'Present')
          .where('attendance_date',
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(startDate))
          .where('attendance_date',
              isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(endDate))
          .get(GetOptions(source: Source.cache));
      return attendanceQuery.docs.length;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return 0;
    }
  }

  Future<int> countLateOrUndertime(
      {required int year, required int month, int? cutoffs}) async {
    try {
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      print(userModel.uid);
      DateTime startDate = DateTime(year, month, 1); // Start date of the month
      DateTime endDate = DateTime(year, month + 1, 0); // Last day of the month
      if (cutoffs != null) {
        startDate = cutoffs == 15
            ? DateTime(year, month, 1)
            : DateTime(year, month, 16); // Start date of the month
        endDate = cutoffs == 15
            ? DateTime(year, month, 15)
            : DateTime(year, month + 1, 0); // Last day of the month
      }
      QuerySnapshot attendanceQuery = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userModel.uid)
          .where('attendance_status', isEqualTo: 'Late/Undertime')
          .where('attendance_date',
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(startDate))
          .where('attendance_date',
              isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(endDate))
          .get(GetOptions(source: Source.cache));
      return attendanceQuery.docs.length;
    } catch (e) {
      _errorMessage = e.toString();
      print(_errorMessage);
      notifyListeners();
      return 0;
    }
  }

  String getAdjustedWorkedDurationFormatted(Duration adjustedWorkedDuration) {
    int hours = adjustedWorkedDuration.inHours;
    int minutes = adjustedWorkedDuration.inMinutes.remainder(60);
    int seconds = adjustedWorkedDuration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Duration stringToDuration(String durationString) {
    List<String> parts = durationString.split(':');
    if (parts.length == 3) {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else if (parts.length == 2) {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      return Duration(hours: hours, minutes: minutes);
    } else {
      return Duration.zero;
    }
  }

  Map<String, int> getDurationComponents(String durationString) {
    Duration duration = stringToDuration(durationString);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return {
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }

  Future<void> fetchUserAttendance(DateTime date) async {
    try {
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      QuerySnapshot attendanceQuery = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userModel.uid)
          .where('attendance_date', isEqualTo: formattedDate)
          .orderBy('attendance_date', descending: true)
          .get(GetOptions(source: Source.cache));
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

  Future<List<UserAttendanceModel>> fetchAllUserAttendanceByYearAndMonth(
      {required int year, int? month, int? cutoffs}) async {
    try {
      List<UserAttendanceModel> attendanceListByYearAndMonth = [];
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      DateTime startDate;
      DateTime endDate;
      if (month == null) {
        startDate = DateTime(year, 1, 1);
        endDate = DateTime(year, 12, 31);
      } else {
        startDate = DateTime(year, month, 1); // Start date of the month
        endDate = DateTime(year, month + 1, 0); // Last day of the month
      }

      if (cutoffs != null && month != null) {
        startDate = cutoffs == 15
            ? DateTime(year, month, 1)
            : DateTime(year, month, 16); // Start date of the month
        endDate = cutoffs == 15
            ? DateTime(year, month, 15)
            : DateTime(year, month + 1, 0); // Last day of the month
      }

      QuerySnapshot attendanceQuery = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userModel.uid)
          .where('attendance_date',
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(startDate))
          .where('attendance_date',
              isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(endDate))
          .orderBy('attendance_date', descending: true)
          .get(GetOptions(source: Source.cache));
      attendanceListByYearAndMonth = attendanceQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserAttendanceModel.fromJson(data);
      }).toList();
      return attendanceListByYearAndMonth;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  //create a method that count the incomplete attendance for the whole month
  Future<int> countIncompleteAttendance(DateTime date) async {
    try {
      UserModel? userModel = authViewModel.userModel;
      if (userModel == null) {
        throw Exception("User not logged in");
      }
      DateTime startDate = DateTime(date.year, date.month, 1);
      DateTime endDate = DateTime(date.year, date.month + 1, 0);
      QuerySnapshot attendanceQuery = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userModel.uid)
          .where('attendance_date',
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(startDate))
          .where('attendance_date',
              isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(endDate))
          .get(GetOptions(source: Source.cache));
      int count = 0;
      for (DocumentSnapshot doc in attendanceQuery.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['time_in'] != null && data['time_in'].isNotEmpty) {
          if (data['time_out'] == null || data['time_out'].isEmpty) {
            count++;
          }
        }
      }
      return count;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return 0;
    }
  }

  List<Object?> Function(DateTime) getEventsForDay(BuildContext context) {
    return (DateTime day) {
      final events = attendanceListCalendar.where((attendance) {
        return isSameDay(DateTime.parse(attendance.attendanceDate ?? ''), day);
      }).toList();

      if (scheduleDays.contains(DateFormat('EEEE').format(day)) &&
          day.isBefore(DateTime.now())) {
        if (events.isEmpty &&
            day.month == DateTime.now().month &&
            day.year == DateTime.now().year) {
          final userId = authViewModel.userModel?.uid ?? '';
          final formattedDate = DateFormat('yyyy-MM-dd').format(day);

          // Set attendance status to "Absent" if no attendance is found
          final absentAttendance = UserAttendanceModel(
            id: '',
            userId: userId,
            userName: '', // You may want to fetch the user's name if needed
            attendanceStatus: 'Absent',
            attendanceDate: formattedDate,
            timeIn: '',
            timeOut: '',
          );

          // Add the absent attendance to the list
          attendanceListCalendar.add(absentAttendance);
          events.add(absentAttendance);

          // Optionally, you can save this to Firestore if needed
          //attendanceViewModel.saveAttendance(absentAttendance);
        }
      }
      return events;
    };
  }

  void getScheduleDays() async {
    _scheduleDays = await scheduleViewModel
        .getUserSchedule(authViewModel.userModel?.uid ?? '');
  }

  //create a method that returns index of the user model attendance date in attendancelistCalendar
  int getAttendanceIndex(DateTime date) {
    for (int i = 0; i < activityAttendanceListCalendar.length; i++) {
      if (DateFormat('yyyy-MM-dd').format(date) ==
          activityAttendanceListCalendar[i].attendanceDate) {
        return i;
      }
    }
    return -1;
  }

  void addNoLoggedAcivity() {
    //get first day of the month
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1).day;
    // get last day of the month
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 0).day;
    for (var i = firstDayOfMonth; i <= lastDayOfMonth; i++) {
      final date = DateTime(today.year, today.month, i);
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final hasAttendance = activityAttendanceListCalendar
          .any((attendance) => attendance.attendanceDate == formattedDate);
      if (!hasAttendance) {
        activityAttendanceListCalendar.add(UserAttendanceModel(
          id: '',
          userId: authViewModel.userModel?.uid ?? '',
          userName: '', // You may want to fetch the user's name if needed
          attendanceStatus: 'No Logged Activity',
          attendanceDate: formattedDate,
          timeIn: '',
          timeOut: '',
        ));
      }
    }
  }

  String statusMessage() {
    if (attendanceList.isNotEmpty) {
      String? timeIn = attendanceList.first.timeIn;
      String? timeOut = attendanceList.first.timeOut;
      if ((timeIn != null && timeIn.isNotEmpty) &&
          (timeOut == null || timeOut.isEmpty)) {
        return 'You have timed in today, Pending time out...';
      } else if ((timeIn != null && timeIn.isNotEmpty) &&
          (timeOut != null && timeOut.isNotEmpty)) {
        return 'You have timed in and out today';
      }
    }
    return 'You have not yet timed in today';
  }
}
