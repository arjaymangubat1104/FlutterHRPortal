import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/widgets/attendace_history_tile.dart';
import 'package:flutter_attendance_system/widgets/attendance_counter_tile.dart';
import 'package:flutter_attendance_system/widgets/calendar_tile.dart';
import 'package:flutter_attendance_system/viewmodel/attendance_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../viewmodel/theme_view_model.dart';

class AttendancePage extends StatefulWidget {
  final AttendanceViewModel attendanceViewModel;
  final TimeDateViewModel timeDateViewModel;
  const AttendancePage({
    super.key,
    required this.attendanceViewModel,
    required this.timeDateViewModel,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with TickerProviderStateMixin {
  late TabController _tabController, _monthTabController;

  final List<DateTime> _months =
      List.generate(12, (index) => DateTime(0, index + 1));
  int _selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  // List<UserAttendanceModel> attendanceListByYearAndMonth = [
  //   UserAttendanceModel(
  //     id: '1',
  //     userId: 'user1',
  //     userName: 'John Doe',
  //     attendanceDate: '2025-01-30',
  //     attendanceStatus: 'Present',
  //     timeIn: '08:00:00',
  //     timeOut: '',
  //     totalTime: '09:00:00',
  //     lateTime: '00:00:00',
  //     underTime: '00:00:00',
  //   ),
  //   UserAttendanceModel(
  //     id: '2',
  //     userId: 'user2',
  //     userName: 'Jane Smith',
  //     attendanceDate: '2025-01-30',
  //     attendanceStatus: 'Late/Undertime',
  //     timeIn: '08:00:00',
  //     timeOut: '17:00:00',
  //     totalTime: '09:00:00',
  //     lateTime: '00:30:00',
  //     underTime: '00:00:00',
  //   ),
  //   UserAttendanceModel(
  //     id: '3',
  //     userId: 'user3',
  //     userName: 'Alice Johnson',
  //     attendanceDate: '2025-01-30',
  //     attendanceStatus: 'Absent',
  //     timeIn: '08:00:00',
  //     timeOut: '17:00:00',
  //     totalTime: '09:00:00',
  //     lateTime: '00:00:00',
  //     underTime: '00:00:00',
  //   ),
  // ];
  List<UserAttendanceModel> attendanceListByYearAndMonth = [];
  int presentCounterCalendar = 0;
  int lateUndertimeCounterCalendar = 0;
  int absentCounter = 0;
  int incompleteCounter = 0;
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();

  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _monthTabController = TabController(length: _months.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _updateAttendaceListByYearAndMonth();
      widget.attendanceViewModel.attendanceListCalendar =
          await widget.attendanceViewModel.fetchAllUserAttendanceByYearAndMonth(
              year: today.year, month: today.month);
      widget.attendanceViewModel.activityAttendanceListCalendar =
          await widget.attendanceViewModel.fetchAllUserAttendanceByYearAndMonth(
              year: today.year, month: today.month);
      widget.attendanceViewModel.addNoLoggedAcivity();
    });
    widget.attendanceViewModel.getScheduleDays();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _monthTabController.dispose();
    super.dispose();
  }

  void _updateAttendaceListByYearAndMonth() async {
    try {
      setState(() {
        _showSpinner = true;
      });
      attendanceListByYearAndMonth =
          await widget.attendanceViewModel.fetchAllUserAttendanceByYearAndMonth(
        year: _selectedYear,
      );
      incompleteCounter = await widget.attendanceViewModel
          .countIncompleteAttendance(DateTime(today.year, today.month));
      presentCounterCalendar = await widget.attendanceViewModel
          .countPresents(year: today.year, month: today.month);
      lateUndertimeCounterCalendar = await widget.attendanceViewModel
          .countLateOrUndertime(year: today.year, month: today.month);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final timeDateViewModel = Provider.of<TimeDateViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeViewModel.currentTheme.themeColor,
          iconTheme:
              IconThemeData(color: themeViewModel.currentTheme.boxTextColor),
          title: Center(
              child: Text(
            'Attendance',
            style: TextStyle(color: Colors.white),
          )),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'HISTORY'),
              Tab(text: 'CALENDAR'),
            ],
            dividerColor: themeViewModel.currentTheme.themeColor,
            indicatorColor: themeViewModel.currentTheme.boxTextColor,
            unselectedLabelColor: themeViewModel.currentTheme.boxTextColor,
            labelColor: themeViewModel.currentTheme.boxTextColor,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            // onTap: (index) async {
            //   _updateAttendaceListByYearAndMonth();
            //     attendanceListByYearAndMonth = await widget.attendanceViewModel
            //         .fetchAllUserAttendanceByYearAndMonth(
            //             year: today.year, month: today.month);
            // },
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          Container(
            color: themeViewModel.currentTheme.pageBackgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: attendanceListByYearAndMonth.length,
                      itemBuilder: (context, index) {
                        return AttendaceHistoryTile(
                          date: widget.timeDateViewModel.formatDateString(
                              attendanceListByYearAndMonth[index]
                                  .attendanceDate
                                  .toString()),
                          attendanceStatus: attendanceListByYearAndMonth[index]
                              .attendanceStatus
                              .toString(),
                          dropDownDate: widget.timeDateViewModel
                              .formatDateString(
                                  attendanceListByYearAndMonth[index]
                                      .attendanceDate
                                      .toString()),
                          timeIn: widget.timeDateViewModel
                              .convertTimeto12hrFormat(
                                  attendanceListByYearAndMonth[index]
                                      .timeIn
                                      .toString()),
                          timeOut: widget.timeDateViewModel
                              .convertTimeto12hrFormat(
                                  attendanceListByYearAndMonth[index]
                                      .timeOut
                                      .toString()),
                          status: attendanceListByYearAndMonth[index]
                              .attendanceStatus
                              .toString(),
                          totalTime:
                              attendanceListByYearAndMonth[index].totalTime ??
                                  '',
                          lateTime:
                              attendanceListByYearAndMonth[index].lateTime ??
                                  '',
                          underTime:
                              attendanceListByYearAndMonth[index].underTime ??
                                  '',
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: themeViewModel.currentTheme.pageBackgroundColor,
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AttendanceCounterTile(
                          fontColor: Colors.green,
                          color: Colors.green[100]!,
                          counter: presentCounterCalendar.toString(),
                          status: 'Present',
                        ),
                      ),
                      Expanded(
                        child: AttendanceCounterTile(
                          fontColor: Colors.orange,
                          color: Colors.orange[100]!,
                          counter: lateUndertimeCounterCalendar.toString(),
                          status: 'Late/Undertime',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AttendanceCounterTile(
                          fontColor: Colors.red,
                          color: Colors.red[100]!,
                          counter: absentCounter.toString(),
                          status: 'Absent',
                        ),
                      ),
                      Expanded(
                        child: AttendanceCounterTile(
                          fontColor: Colors.grey,
                          color: Colors.grey[100]!,
                          counter: incompleteCounter.toString(),
                          status: 'Incomplete',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CalendarTile(
                    events: widget.attendanceViewModel.getEventsForDay(context),
                    onDaySelectedCallback: (DateTime day) async {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Activity',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: themeViewModel.currentTheme.textColor),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: themeViewModel.currentTheme.themeColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: themeViewModel
                                          .currentTheme.boxTextColor),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    widget.attendanceViewModel
                                                .getAttendanceIndex(
                                                    selectedDay) ==
                                            -1
                                        ? ''
                                        : DateFormat('EEEE, d MMMM yyyy')
                                            .format(DateTime.parse(widget
                                                .attendanceViewModel
                                                .activityAttendanceListCalendar[
                                                    widget.attendanceViewModel
                                                        .getAttendanceIndex(
                                                            selectedDay)]
                                                .attendanceDate!)),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: themeViewModel
                                            .currentTheme.boxTextColor))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Time in: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: themeViewModel
                                          .currentTheme.boxTextColor),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    widget.attendanceViewModel
                                                .getAttendanceIndex(
                                                    selectedDay) ==
                                            -1
                                        ? ''
                                        : timeDateViewModel
                                            .convertTimeto12hrFormat(widget
                                                .attendanceViewModel
                                                .activityAttendanceListCalendar[
                                                    widget.attendanceViewModel
                                                        .getAttendanceIndex(
                                                            selectedDay)]
                                                .timeIn
                                                .toString()),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: themeViewModel
                                            .currentTheme.boxTextColor))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Time out: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: themeViewModel
                                          .currentTheme.boxTextColor),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    widget.attendanceViewModel
                                                .getAttendanceIndex(
                                                    selectedDay) ==
                                            -1
                                        ? ''
                                        : timeDateViewModel
                                            .convertTimeto12hrFormat(widget
                                                .attendanceViewModel
                                                .activityAttendanceListCalendar[
                                                    widget.attendanceViewModel
                                                        .getAttendanceIndex(
                                                            selectedDay)]
                                                .timeOut
                                                .toString()),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: themeViewModel
                                            .currentTheme.boxTextColor))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}
