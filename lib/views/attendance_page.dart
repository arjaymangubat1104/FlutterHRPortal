import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/utils/attendace_history_tile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodel/theme_view_model.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with TickerProviderStateMixin {
  late TabController _tabController, _monthTabController;
  final List<String> _months = List.generate(
      12, (index) => DateFormat.MMM().format(DateTime(0, index + 1)));
  final List<int> _years =
      List.generate(10, (index) => DateTime.now().year - index);
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _monthTabController = TabController(length: _months.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _monthTabController.dispose();
    super.dispose();
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
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value!;
                              });
                            },
                          ),
                          Expanded(
                            child: TabBar(
                              controller: _monthTabController,
                              isScrollable: true,
                              tabs: _months
                                  .map((month) => Tab(text: month))
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
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return AttendaceHistoryTile(
                            date: '13 August 2021',
                            attendanceStatus: 'Present',
                            dropDownDate: 'Tuesday, 13 August 2021',
                            timeIn: '08:00 AM',
                            timeOut: '05:00 PM',
                            status: 'On Time',
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
