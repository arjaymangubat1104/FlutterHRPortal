import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/theme_view_model.dart';

class AttendaceHistoryTile extends StatelessWidget {
  final String date;
  final String attendanceStatus;
  final String dropDownDate;
  final String timeIn;
  final String timeOut;
  final String status;
  final String totalTime;
  final Function(String?)? onChanged;

  const AttendaceHistoryTile({
    super.key,
    required this.date,
    required this.attendanceStatus,
    required this.dropDownDate,
    required this.timeIn,
    required this.timeOut,
    required this.status,
    required this.totalTime,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    Color changeColor(String value) {
      switch (value) {
        case 'Present':
          return Colors.green;
        case 'Absent':
          return Colors.red;
        case 'Late':
          return Colors.orange;
        default:
          return Colors.black;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeViewModel.currentTheme.textColor),
                ),
                Text(
                  attendanceStatus,
                  style: TextStyle(
                    color: changeColor(attendanceStatus),
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            childrenPadding: EdgeInsets.only(bottom: 15, left: 15),
            children: [
              Row(
                children: [
                  Text(
                    'Date:',
                    style: TextStyle(
                        color: themeViewModel.currentTheme.themeColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dropDownDate,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Time In:',
                    style: TextStyle(
                        color: themeViewModel.currentTheme.themeColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    timeIn,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Time Out:',
                    style: TextStyle(
                        color: themeViewModel.currentTheme.themeColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    timeOut,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$status: ',
                    style: TextStyle(
                        color: themeViewModel.currentTheme.themeColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    totalTime,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
