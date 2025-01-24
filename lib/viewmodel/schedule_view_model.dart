import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/schedule_model.dart';

class ScheduleViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> saveDefaultSchedule(String userId) async {
    ScheduleModel defaultSchedule = ScheduleModel(
      scheduleStartDayOfTheWeek: '1', // example start date
      scheduleEndDayofTheWeek: '5', // example end date
      scheduleType: 'Regular',
      breakStartTime: '12:00:00',
      breakEndTime: '13:00:00',
      scheduleIn: '09:00:00', // example in time
      scheduleOut: '18:00:00', // example out time
    );

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update(defaultSchedule.toJson());
      print('Default schedule saved successfully');
    } catch (e) {
      print('Error saving default schedule: $e');
    }
  }

  Future<List<String>> getUserSchedule(String userId) async {
    try {
      List<String> schedules = [];
      // Get user schedule from Firestore
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!documentSnapshot.exists) {
        throw Exception('User schedule does not exist');
      }
      Map<String, dynamic> scheduleDate =
          documentSnapshot.data() as Map<String, dynamic>;
      int scheduleStart = int.parse(scheduleDate['schedule_start_date']);
      int scheduleEnd = int.parse(scheduleDate['schedule_end_date']);
      Map<int, String> daysOfWeek = {
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday',
        7: 'Sunday'
      };
      for (int i = scheduleStart; i <= scheduleEnd; i++) {
        schedules.add(daysOfWeek[i] ?? 'Unknown');
      }
      return schedules;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
