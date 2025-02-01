import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';

class AttendanceCounterTile extends StatelessWidget {
  final Color fontColor;
  final Color color;
  final String counter;
  final String status;

  const AttendanceCounterTile(
      {super.key,
      required this.fontColor,
      required this.color,
      required this.counter,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return Container(
      padding: EdgeInsets.all(2),
      decoration:
          BoxDecoration(
            borderRadius: BorderRadius.circular(10), 
            color: color,
            border: Border.all(
              color: fontColor,
              width: 1
            ),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                counter,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: fontColor,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                    fontSize: 12,
                    color: themeViewModel.currentTheme.textColor,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
