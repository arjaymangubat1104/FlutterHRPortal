import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/models/attendance_model.dart';
import 'package:flutter_attendance_system/utils/attendace_history_tile.dart';
import 'package:flutter_attendance_system/utils/loading_indicator.dart';
import 'package:flutter_attendance_system/viewmodel/attendance_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodel/theme_view_model.dart';

class AttendancePage extends StatefulWidget {
  final AttendanceViewModel attendanceViewModel;
  final TimeDateViewModel timeDateViewModel;
  const AttendancePage(
      {super.key,
      required this.attendanceViewModel,
      required this.timeDateViewModel});

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
  int _selectedCutoff = 15;
  int selectedMonth = DateTime.now().month;
  List<UserAttendanceModel> attendanceListByYearAndMonth = [];
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _monthTabController = TabController(length: _months.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _updateAttendaceListByYearAndMonth();
    });
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
      attendanceListByYearAndMonth = await widget.attendanceViewModel
          .fetchAllUserAttendanceByYearAndMonth(
              _selectedYear, selectedMonth, _selectedCutoff);
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
                                        '0',
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
                                        '0',
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
                                  Column(
                                    children: [
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.orange),
                                      ),
                                      Text(
                                        'Late',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
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
                            attendanceStatus: 'Present',
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
                          );
                        },
                      ),
                    ],
                  ))
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
                child: ClipRRect(
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
                                  '0',
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
                                  '0',
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
                            Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.orange),
                                ),
                                Text(
                                  'Late',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (_showSpinner)
                Container(
                  color: Colors.black.withOpacity(0.5),
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
