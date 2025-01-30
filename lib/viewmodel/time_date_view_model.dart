import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeDateViewModel extends ChangeNotifier {
  late Timer _timer;
  String _formattedDateTime = '';
  String _formattedDate = '';
  DateTime _mondayOfCurrentWeek = DateTime.now();
  final DateTime _dateTime = DateTime.now();

  TimeDateViewModel() {
    _formattedDateTime = _getCurrentTime();
    _formattedDate = _getcurrentDate();
    _mondayOfCurrentWeek = _getMondayOfCurrentWeek();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  String get formattedDateTime => _formattedDateTime;
  String get formattedDate => _formattedDate;
  DateTime get mondayOfCurrentWeek => _mondayOfCurrentWeek;
  DateTime get dateTime => _dateTime;

  String _getCurrentTime() {
    return DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  String _getcurrentDate() {
    return DateFormat('EEE, MMMM d, y').format(DateTime.now());
  }

  DateTime _getMondayOfCurrentWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime monday = now.subtract(Duration(days: currentWeekday - 1));
    return monday;
  }

  String formatDateString(String dateString) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
    return DateFormat('EEE, d MMM').format(dateTime);
  }

  //convert time string 24hr to 12hr
  String convertTimeto12hrFormat(String time) {
    try {
      final format = DateFormat.jm(); //"6:00:00 PM"
      final dateTime = DateFormat('HH:mm:ss').parse(time);
      return format.format(dateTime);
    } catch (e) {
      return '';
    }
  }

  void _updateTime() {
    _formattedDateTime = _getCurrentTime();
    _formattedDate = _getcurrentDate();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
