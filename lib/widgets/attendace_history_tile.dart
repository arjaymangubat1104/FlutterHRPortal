import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline_list.dart';
import '../viewmodel/attendance_view_model.dart';
import '../viewmodel/theme_view_model.dart';

class AttendaceHistoryTile extends StatelessWidget {
  final String date;
  final String attendanceStatus;
  final String dropDownDate;
  final String timeIn;
  final String timeOut;
  final String status;
  final String totalTime;
  final String lateTime;
  final String underTime;
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
    required this.lateTime,
    required this.underTime,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);

    var checkIcon = Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        child: Icon(Icons.check, color: Colors.white, size: 12));
    var emptyIcon = Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey));

    Color changeColor(String value) {
      switch (value) {
        case 'Present':
          return Colors.green;
        case 'Absent':
          return Colors.red;
        case 'Late/Undertime':
          return Colors.orange;
        default:
          return Colors.grey; // Default color
      }
    }

    Map<String, int> totalTimeComponents =
        attendanceViewModel.getDurationComponents(totalTime);
    Map<String, int> lateHoursComponents =
        attendanceViewModel.getDurationComponents(lateTime);
    Map<String, int> underTimeComponents =
        attendanceViewModel.getDurationComponents(underTime);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: themeViewModel.currentTheme.backgroundColor,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeViewModel.currentTheme.textColor,
                      fontSize: 12),
                ),
                Text(
                  attendanceStatus,
                  style: TextStyle(
                      color: changeColor(attendanceStatus),
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                )
              ],
            ),
            childrenPadding: EdgeInsets.only(bottom: 10, left: 15),
            children: [
              Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                          color: themeViewModel.currentTheme.textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Timeline.builder(
                  physics: NeverScrollableScrollPhysics(),
                  context: context,
                  markerCount: 2,
                  properties: TimelineProperties(
                      iconAlignment: MarkerIconAlignment.top,
                      iconSize: 16,
                      timelinePosition: TimelinePosition.start),
                  markerBuilder: (context, index) => Marker(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Column(
                        children: [
                          Text(
                            index == 0
                                ? 'In'
                                : timeOut == ''
                                    ? ''
                                    : 'Out',
                            style: TextStyle(
                                color: index == 0 ? Colors.green : Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            index == 0 ? timeIn : timeOut,
                            style: TextStyle(
                                color: themeViewModel.currentTheme.textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    icon: index >= 1 && timeOut == '' ? emptyIcon : checkIcon,
                    position: MarkerPosition.left,
                  ),
                ),
              ]),
              if (timeOut != '') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Working Hours',
                          style: TextStyle(
                            color: themeViewModel.currentTheme.themeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: themeViewModel.currentTheme.themeColor,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              totalTime == ''
                                  ? ''
                                  : '${totalTimeComponents['hours']} h ${totalTimeComponents['minutes']} m',
                              style: TextStyle(
                                  color: themeViewModel.currentTheme.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
