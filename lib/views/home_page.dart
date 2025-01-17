import 'package:animated_analog_clock/animated_analog_clock.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/utils/confimation_dialog_box.dart';
import 'package:flutter_attendance_system/utils/prompt_dialog_box.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:flutter_attendance_system/views/attendance_page.dart';
import 'package:provider/provider.dart';
import '../viewmodel/attendance_view_model.dart';
import '../viewmodel/auth_view_model.dart';
import '../viewmodel/theme_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final userModel = authViewModel.userModel;
    final timeDateViewModel = Provider.of<TimeDateViewModel>(context);
    final attendanceViewModel = Provider.of<AttendanceViewModel>(context);
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await attendanceViewModel.fetchUserAttendance(DateTime.now());
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeViewModel.currentTheme.themeColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Flutter HR Portal',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeViewModel.currentTheme.boxTextColor
                ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              setState(() {
                _showSpinner = true;
              });
              try {
                await authViewModel.logout(context);
              } finally {
                setState(() {
                  _showSpinner = false;
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: themeViewModel.currentTheme.pageBackgroundColor, // Set the background color of the body
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Welcome back'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    userModel?.displayName ?? 'User',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ' - ${userModel?.uid ?? 'uid'}',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              AnimatedAnalogClock(
                                location: 'Asia/Manila',
                                dialType: DialType.numbers,
                                size: 125,
                                // Gradient Background if you want
                                backgroundColor: Colors.lightBlue,
                                hourHandColor: Colors.black,
                                minuteHandColor: Colors.black,
                                secondHandColor: Colors.red,
                                centerDotColor: Colors.amber,
                                hourDashColor: Colors.lightBlue,
                                minuteDashColor: Colors.blueAccent,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    timeDateViewModel.formattedDateTime,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              IgnorePointer(
                                child: DatePicker(
                                  timeDateViewModel.mondayOfCurrentWeek,
                                  initialSelectedDate: DateTime.now(),
                                  selectionColor: Colors.red,
                                  selectedTextColor: Colors.white,
                                  monthTextStyle: TextStyle(fontSize: 10),
                                  dayTextStyle: TextStyle(fontSize: 10),
                                  dateTextStyle: TextStyle(fontSize: 15),
                                  width: 45,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    attendanceViewModel.statusMessage(),
                                    style: TextStyle(
                                        fontSize: 12, 
                                        color: themeViewModel.currentTheme.textColor
                                      ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder:
                                                (context) =>
                                                    ConfimationDialogBox(
                                                      title: 'Confirm Time In',
                                                      content:
                                                          'Are you sure you want to time in?',
                                                      onYes: () async {
                                                        setState(() {
                                                          _showSpinner = true;
                                                        });
                                                        try {
                                                          await attendanceViewModel
                                                              .timeIn();
                                                          await attendanceViewModel
                                                              .fetchUserAttendance(
                                                                  timeDateViewModel
                                                                      .dateTime);
                                                          Navigator.pop(
                                                              context);
                                                        } finally {
                                                          setState(() {
                                                            _showSpinner =
                                                                false;
                                                          });
                                                        }
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                attendanceViewModel
                                                                        .isSuccessInOut
                                                                    ? PromptDialogBox(
                                                                        icon: Icons
                                                                            .check_circle,
                                                                        title:
                                                                            'Time In Successful',
                                                                        content:
                                                                            'You have successfully time in',
                                                                        buttonText:
                                                                            'OK',
                                                                        isSuccess:
                                                                            attendanceViewModel.isSuccessInOut,
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                      )
                                                                    : PromptDialogBox(
                                                                        icon: Icons
                                                                            .error_outline,
                                                                        title:
                                                                            'Time In Failed',
                                                                        content:
                                                                            attendanceViewModel.errorMessage ??
                                                                                'You have failed to time in',
                                                                        buttonText:
                                                                            'OK',
                                                                        isSuccess:
                                                                            attendanceViewModel.isSuccessInOut,
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                      ));
                                                      },
                                                      onNo: () => Navigator.pop(
                                                          context),
                                                    ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        'TIME IN',
                                        style: TextStyle(color: themeViewModel.currentTheme.boxTextColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 150,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder:
                                                (context) =>
                                                    ConfimationDialogBox(
                                                      title: 'Confirm Time Out',
                                                      content:
                                                          'Are you sure you want to time out?',
                                                      onYes: () async {
                                                        await attendanceViewModel
                                                            .timeOut();
                                                        await attendanceViewModel
                                                            .fetchUserAttendance(
                                                                timeDateViewModel
                                                                    .dateTime);
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                attendanceViewModel
                                                                        .isSuccessInOut
                                                                    ? PromptDialogBox(
                                                                        icon: Icons
                                                                            .check_circle,
                                                                        title:
                                                                            'Time Out Successful',
                                                                        content:
                                                                            'You have successfully time out',
                                                                        buttonText:
                                                                            'OK',
                                                                        isSuccess:
                                                                            attendanceViewModel.isSuccessInOut,
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                      )
                                                                    : PromptDialogBox(
                                                                        icon: Icons
                                                                            .error_outline,
                                                                        title:
                                                                            'Time Out Failed',
                                                                        content:
                                                                            attendanceViewModel.errorMessage ??
                                                                                'You have failed to time out',
                                                                        buttonText:
                                                                            'OK',
                                                                        isSuccess:
                                                                            attendanceViewModel.isSuccessInOut,
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                      ));
                                                      },
                                                      onNo: () => Navigator.pop(
                                                          context),
                                                    ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        'TIME OUT',
                                        style: TextStyle(color: themeViewModel.currentTheme.boxTextColor),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Image.asset(
                              'lib/assets/profile.png',
                              width: 100,
                              height: 100,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: themeViewModel.currentTheme.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => 
                                        AttendancePage(attendanceViewModel: attendanceViewModel, timeDateViewModel: timeDateViewModel),
                                    )
                                  ),
                                child: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.doc_chart,
                                      size: 75,
                                      color: themeViewModel.currentTheme.themeColor,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'ATTENDANCE',
                                      style: TextStyle(
                                        fontSize: 13, 
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/leave'),
                                child: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.calendar,
                                      size: 75,
                                      color: themeViewModel.currentTheme.themeColor,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'LEAVE',
                                      style: TextStyle(
                                        fontSize: 13, 
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/overtime'),
                                child: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.clock,
                                      size: 75,
                                      color: themeViewModel.currentTheme.themeColor,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'OVERTIME',
                                      style: TextStyle(
                                        fontSize: 13, 
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/payslip'),
                                child: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.money_dollar,
                                      size: 75,
                                      color: themeViewModel.currentTheme.themeColor,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'PAYSLIP',
                                      style: TextStyle(
                                        fontSize: 13, 
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/team'),
                                child: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.group,
                                      size: 75,
                                      color: themeViewModel.currentTheme.themeColor,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'TEAM',
                                      style: TextStyle(
                                        fontSize: 13, 
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/schedule'),
                                child: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.calendar_circle,
                                      size: 75,
                                      color: themeViewModel.currentTheme.themeColor,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'SCHEDULE',
                                        style: TextStyle(
                                        fontSize: 13, 
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
