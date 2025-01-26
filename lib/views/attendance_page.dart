import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/utils/attendace_history_tile.dart';
import 'package:flutter_attendance_system/utils/calendar_tile.dart';
import 'package:flutter_attendance_system/utils/loading_indicator.dart';
import 'package:flutter_attendance_system/viewmodel/attendance_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/auth_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/schedule_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../viewmodel/theme_view_model.dart';

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
  final List<int> _cutoffs = [
    15,
    30,
  ];
  final List<int> _years =
      List.generate(10, (index) => DateTime.now().year - index);
  int _selectedYear = DateTime.now().year;
  int _selectedCutoff = DateTime.now().day < 15 ? 15 : 30;
  int selectedMonth = DateTime.now().month;
  List<UserAttendanceModel> attendanceListByYearAndMonth = [];
  List<UserAttendanceModel> attendanceListCalendar = [];
  List<UserAttendanceModel> activityAttendanceListCalendar = [];

  int presentCounter = 0;
  int presentCounterCalendar = 0;
  int lateUndertimeCounter = 0;
  int lateUndertimeCounterCalendar = 0;
  int absentCounter = 0;
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  List<String> scheduleDays = [];

  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _monthTabController = TabController(length: _months.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _updateAttendaceListByYearAndMonth();
      attendanceListCalendar = await widget.attendanceViewModel
          .fetchAllUserAttendanceByYearAndMonth(
              year: today.year, month: today.month);
      activityAttendanceListCalendar = await widget.attendanceViewModel
          .fetchAllUserAttendanceByYearAndMonth(
              year: today.year, month: today.month);
      _addNoLoggedAcivity();
      
    });
    _getScheduleDays();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _monthTabController.dispose();
    super.dispose();
  }

  //create a method that returns index of the user model attendance date in attendancelistCalendar
  int _getAttendanceIndex(DateTime date) {
    for (int i = 0; i < activityAttendanceListCalendar.length; i++) {
      if (DateFormat('yyyy-MM-dd').format(date) ==
          activityAttendanceListCalendar[i].attendanceDate) {
        return i;
      }
    }
    return -1;
  }

  void _updateAttendaceListByYearAndMonth() async {
    try {
      setState(() {
        _showSpinner = true;
      });
      attendanceListByYearAndMonth = await widget.attendanceViewModel
          .fetchAllUserAttendanceByYearAndMonth(
              year: _selectedYear,
              month: selectedMonth,
              cutoffs: _selectedCutoff);
      presentCounter = await widget.attendanceViewModel.countPresents(
          year: _selectedYear, month: selectedMonth, cutoffs: _selectedCutoff);
      lateUndertimeCounter = await widget.attendanceViewModel
          .countLateOrUndertime(
              year: _selectedYear,
              month: selectedMonth,
              cutoffs: _selectedCutoff);
      absentCounter =
          await widget.attendanceViewModel.countDaysWithNoLoggedAttendance();
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

  void _getScheduleDays() async {
    final scheduelViewModel =
        Provider.of<ScheduleViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    scheduleDays = await scheduelViewModel
        .getUserSchedule(authViewModel.userModel?.uid ?? '');
  }
  
  void _addNoLoggedAcivity(){
    //get first day of the month
    final firstDayOfMonth = DateTime(today.year, today.month, 1).day;
    // get last day of the month
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 0).day;
    for (var i = firstDayOfMonth; i <= lastDayOfMonth; i++) {
      final date = DateTime(today.year, today.month, i);
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final hasAttendance = activityAttendanceListCalendar.any((attendance) =>
          attendance.attendanceDate == formattedDate);
      if (!hasAttendance) {
        activityAttendanceListCalendar.add(UserAttendanceModel(
          id: '',
          userId: widget.attendanceViewModel.authViewModel.userModel?.uid ?? '',
          userName: '', // You may want to fetch the user's name if needed
          attendanceStatus: 'No Logged Activity',
          attendanceDate: formattedDate,
          timeIn: '',
          timeOut: '',
        ));
      }
    }

  }
  


  List<dynamic> _getEventsForDay(DateTime day) {
    (context);
    final events = attendanceListCalendar.where((attendance) {
      return isSameDay(DateTime.parse(attendance.attendanceDate ?? ''), day);
    }).toList();

    if (scheduleDays.contains(DateFormat('EEEE').format(day)) &&
        day.isBefore(today)) {
      if (events.isEmpty &&
            day.month == today.month &&
            day.year == today.year) {
          final userId =
              widget.attendanceViewModel.authViewModel.userModel?.uid ?? '';
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
          attendanceListCalendar.add(absentAttendance);
          events.add(absentAttendance);

          // Optionally, you can save this to Firestore if needed
          //attendanceViewModel.saveAttendance(absentAttendance);
        }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeViewModel.currentTheme.themeColor,
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
      body: TabBarView(
        controller: _tabController,
        children: [
          Stack(
            children: [
              Container(
                color: themeViewModel.currentTheme.pageBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      color: themeViewModel.currentTheme.themeColor,
                      height: 100,
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DropdownButton<int>(
                            value: _selectedYear,
                            dropdownColor:
                                themeViewModel.currentTheme.themeColor,
                            iconEnabledColor:
                                themeViewModel.currentTheme.boxTextColor,
                            items: _years.map((year) {
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text(
                                  year.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: themeViewModel
                                        .currentTheme.boxTextColor,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              _selectedYear = value!;
                              _updateAttendaceListByYearAndMonth();
                            },
                          ),
                          const SizedBox(width: 20),
                          DropdownButton<int>(
                            value: _selectedCutoff,
                            dropdownColor:
                                themeViewModel.currentTheme.themeColor,
                            iconEnabledColor:
                                themeViewModel.currentTheme.boxTextColor,
                            items: _cutoffs.map((cutoffs) {
                              return DropdownMenuItem<int>(
                                value: cutoffs,
                                child: Text(
                                  cutoffs.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: themeViewModel
                                        .currentTheme.boxTextColor,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              _selectedCutoff = value!;
                              _updateAttendaceListByYearAndMonth();
                            },
                          ),
                          Expanded(
                            child: TabBar(
                              controller: _monthTabController,
                              isScrollable: true,
                              tabs: _months
                                  .map((month) =>
                                      Tab(text: DateFormat.MMM().format(month)))
                                  .toList(),
                              dividerColor:
                                  themeViewModel.currentTheme.themeColor,
                              indicatorColor:
                                  themeViewModel.currentTheme.boxTextColor,
                              unselectedLabelColor:
                                  themeViewModel.currentTheme.boxTextColor,
                              labelColor:
                                  themeViewModel.currentTheme.boxTextColor,
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              onTap: (index) async {
                                selectedMonth = index + 1;
                                _updateAttendaceListByYearAndMonth();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        presentCounter.toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        'Present',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        lateUndertimeCounter.toString(),
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.orange),
                                      ),
                                      Text(
                                        'Late/Undertime',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  // Column(
                                  //   children: [
                                  //     Text(
                                  //       '0',
                                  //       style: TextStyle(
                                  //           fontSize: 30, color: Colors.red),
                                  //     ),
                                  //     Text(
                                  //       'Absent',
                                  //       style: TextStyle(
                                  //           fontSize: 15,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.grey[600]),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: attendanceListByYearAndMonth.length,
                        itemBuilder: (context, index) {
                          return AttendaceHistoryTile(
                            date: attendanceListByYearAndMonth[index]
                                .attendanceDate
                                .toString(),
                            attendanceStatus:
                                attendanceListByYearAndMonth[index]
                                    .attendanceStatus
                                    .toString(),
                            dropDownDate: widget.timeDateViewModel
                                .formatDateString(
                                    attendanceListByYearAndMonth[index]
                                        .attendanceDate
                                        .toString()),
                            timeIn: attendanceListByYearAndMonth[index]
                                .timeIn
                                .toString(),
                            timeOut: attendanceListByYearAndMonth[index]
                                .timeOut
                                .toString(),
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
                    ],
                  )),
              if (_showSpinner)
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5),
                  dismissible: false,
                ),
              if (_showSpinner)
                Dialog.fullscreen(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CustomLoadingIndicator(),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              Container(
                color: themeViewModel.currentTheme.pageBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      color: themeViewModel.currentTheme.themeColor,
                      height: 50,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      presentCounterCalendar.toString(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Present',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      lateUndertimeCounterCalendar.toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.orange),
                                    ),
                                    Text(
                                      'Late/Undertime',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      absentCounter.toString(),
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.red),
                                    ),
                                    Text(
                                      'Absent',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CalendarTile(
                      events: _getEventsForDay,
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
                                  Text(_getAttendanceIndex(selectedDay) == -1 ? '' : DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse(activityAttendanceListCalendar[_getAttendanceIndex(selectedDay)].attendanceDate!)),
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
                                  Text(_getAttendanceIndex(selectedDay) == -1 ? '' : activityAttendanceListCalendar[_getAttendanceIndex(selectedDay)].timeIn ?? '',
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
                                  Text(_getAttendanceIndex(selectedDay) == - 1 ? '' : activityAttendanceListCalendar[_getAttendanceIndex(selectedDay)].timeOut ?? '',
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
              if (_showSpinner)
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5),
                  dismissible: false,
                ),
              if (_showSpinner)
                Dialog.fullscreen(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CustomLoadingIndicator(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
