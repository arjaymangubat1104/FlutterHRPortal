import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/schedule_model.dart';

class ScheduleViewModel extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


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
      await _firestore.collection('users').doc(userId).update(defaultSchedule.toJson());
      print('Default schedule saved successfully');
    } catch (e) {
      print('Error saving default schedule: $e');
    }
  }


}