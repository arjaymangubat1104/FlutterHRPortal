import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/viewmodel/attendance_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarTile extends StatefulWidget {
  final DateTime? focusedDay;
  final DateTime? firstDay;
  final DateTime? lastDay;
  final Function(DateTime)? onDaySelectedCallback;
  final List<Object?> Function(DateTime) events;

  const CalendarTile({
    super.key,
    this.focusedDay,
    this.firstDay,
    this.lastDay,
    this.onDaySelectedCallback,
    required this.events,
  });

  @override
  State<CalendarTile> createState() => _CalendarTileState();
}

class _CalendarTileState extends State<CalendarTile> {
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  

  @override
  void initState() {
    super.initState();

  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      //today = focusedDay;
    });
    if (widget.onDaySelectedCallback != null) {
      widget.onDaySelectedCallback!(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TableCalendar(
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeViewModel.currentTheme.themeColor

            ),
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
          eventLoader: (day) => widget.events(day),
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            weekdayStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            weekendTextStyle: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            defaultTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
              shape: BoxShape.rectangle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return SizedBox();
              List<Widget> markers = events.map((event) {
                Color markerColor;
                if ((event as UserAttendanceModel).attendanceStatus ==
                    'Present') {
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
    );
  }
}
