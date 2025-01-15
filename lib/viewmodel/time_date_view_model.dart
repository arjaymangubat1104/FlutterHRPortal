import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeDateViewModel extends ChangeNotifier {
  late Timer _timer;
  String _formattedDateTime = '';
  String _formattedDate = '';
  final DateTime _dateTime = DateTime.now();

  TimeDateViewModel() {
    _formattedDateTime = _getCurrentTime();
    _formattedDate = _getcurrentDate();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  String get formattedDateTime => _formattedDateTime;
  String get formattedDate => _formattedDate;
  DateTime get dateTime => _dateTime;

  String _getCurrentTime() {
    return DateFormat('hh:mm:ss a').format(DateTime.now());
  }

  String _getcurrentDate() {
    return DateFormat('EEE, MMMM d, y').format(DateTime.now());
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
