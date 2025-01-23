import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/viewmodel/attendance_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../viewmodel/theme_view_model.dart';

class CalendarTile extends StatefulWidget {
  final DateTime? focusedDay;
  final DateTime? firstDay;
  final DateTime? lastDay;
  final Function(DateTime)? onDaySelected;

  const CalendarTile({
    super.key,
    this.focusedDay,
    this.firstDay,
    this.lastDay,
    this.onDaySelected,
  });

  @override
  State<CalendarTile> createState() => _CalendarTileState();
}

class _CalendarTileState extends State<CalendarTile> {
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  List<UserAttendanceModel> attendanceList = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  void _loadAttendanceData() async {
    final attendanceViewModel =
        Provider.of<AttendanceViewModel>(context, listen: false);
    final year = today.year;
    final month = today.month;

    attendanceList = await attendanceViewModel
        .fetchAllUserAttendanceByYearAndMonth(year: year, month: month);
    setState(() {});
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      today = focusedDay;
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final events = attendanceList.where((attendance) {
      return isSameDay(DateTime.parse(attendance.attendanceDate ?? ''), day);
    }).toList();

    if (events.isEmpty && day.month == today.month && day.year == today.year) {
      final attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: false);
      final userId = attendanceViewModel.authViewModel.userModel?.uid ?? '';
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
      attendanceList.add(absentAttendance);
      events.add(absentAttendance);

      // Optionally, you can save this to Firestore if needed
      //attendanceViewModel.saveAttendance(absentAttendance);
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: themeViewModel.currentTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) {
              return isSameDay(day, selectedDay);
            },
            focusedDay: widget.focusedDay ?? today,
            firstDay: widget.firstDay ?? DateTime.utc(2010, 10, 16),
            lastDay: widget.lastDay ?? DateTime.utc(2030, 3, 14),
            onDaySelected: onDaySelected,
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              // selectedDecoration: BoxDecoration(
              //   color: themeViewModel.currentTheme.primaryColor, // Change this to your desired color
              //   shape: BoxShape.circle,
              // ),
              // todayDecoration: BoxDecoration(
              //   color: themeViewModel.currentTheme.accentColor, // Change this to your desired color
              //   shape: BoxShape.circle,
              // ),
              markerDecoration: BoxDecoration(
                color: Colors.blue, // Default color for events
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return SizedBox();
                List<Widget> markers = events.map((event) {
                  Color markerColor;
                  if ((event as UserAttendanceModel).attendanceStatus == 'Present') {
                    markerColor = Colors.green;
                  } else if (event.attendanceStatus == 'Late/Undertime') {
                    markerColor = Colors.orange;
                  } else if (event.attendanceStatus == 'Absent') {
                    markerColor = Colors.red;
                  } else {
                    markerColor = Colors.grey;
                  }
                  return Container(
                    width: 12,
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.rectangle,
                    ),
                  );
                }).toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: markers,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
