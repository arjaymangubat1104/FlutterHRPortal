import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/views/button_page/attendance_page.dart';
import 'package:flutter_attendance_system/widgets/confimation_dialog_box.dart';
import 'package:flutter_attendance_system/widgets/prompt_dialog_box.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
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
        backgroundColor: themeViewModel.currentTheme.themeColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Flutter HR Portal',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeViewModel.currentTheme.boxTextColor),
            ),
          ],
        ),
        iconTheme:
            IconThemeData(color: themeViewModel.currentTheme.boxTextColor),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
            icon: Icon(
              Icons.notifications,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: themeViewModel.currentTheme.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: themeViewModel.currentTheme.themeColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themeViewModel
                            .currentTheme.boxTextColor, // Outline color
                        width: 2.0, // Outline width
                      ),
                      shape: BoxShape.circle, // Circular outline
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/profile.png',
                        height: 65,
                        width: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${userModel?.firstName ?? ''} ${userModel?.lastName ?? ''}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: themeViewModel.currentTheme.boxTextColor),
                  ),
                  Text(
                    userModel?.email ?? 'email',
                    style: TextStyle(
                        fontSize: 10,
                        color: themeViewModel.currentTheme.boxTextColor),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                color: themeViewModel.currentTheme.themeColor,
              ),
              title: Text(
                'My Profile',
                style: TextStyle(
                    fontSize: 15, color: themeViewModel.currentTheme.textColor),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.work_outline,
                color: themeViewModel.currentTheme.themeColor,
              ),
              title: Text(
                'Employment Details',
                style: TextStyle(
                    fontSize: 15, color: themeViewModel.currentTheme.textColor),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/theme');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.lock_outline,
                color: themeViewModel.currentTheme.themeColor,
              ),
              title: Text(
                'Change Password',
                style: TextStyle(
                    fontSize: 15, color: themeViewModel.currentTheme.textColor),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: themeViewModel.currentTheme.themeColor,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 15, color: themeViewModel.currentTheme.textColor),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => ConfimationDialogBox(
                          title: 'Confirm Logout',
                          content: 'Are you sure you want to logout?',
                          onYes: () async {
                            await authViewModel.logout(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          onNo: () => Navigator.pop(context),
                        ));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: themeViewModel.currentTheme
                .pageBackgroundColor, // Set the background color of the body
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
            top: 0,
            bottom: 0,
            child: LayoutBuilder(builder: (context, constrains) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constrains.maxHeight,
                  ),
                  child: IntrinsicHeight(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('Welcome back'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            userModel?.userName ?? 'User',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ' - ${userModel?.uid ?? 'uid'}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(children: [
                                        Icon(
                                          Icons.punch_clock,
                                          color: themeViewModel
                                              .currentTheme.themeColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          timeDateViewModel.formattedDateTime,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: themeViewModel
                                                .currentTheme.themeColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: themeViewModel
                                                .currentTheme.themeColor,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            timeDateViewModel.formattedDate,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: themeViewModel
                                                  .currentTheme.themeColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      //const SizedBox(height: 10),
                                      // AnimatedAnalogClock(
                                      //   location: 'Asia/Manila',
                                      //   dialType: DialType.numbers,
                                      //   size: 125,
                                      //   // Gradient Background if you want
                                      //   backgroundColor: Colors.lightBlue,
                                      //   hourHandColor: Colors.black,
                                      //   minuteHandColor: Colors.black,
                                      //   secondHandColor: Colors.red,
                                      //   centerDotColor: Colors.amber,
                                      //   hourDashColor: Colors.lightBlue,
                                      //   minuteDashColor: Colors.blueAccent,
                                      // ),
                                      // const SizedBox(height: 10),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: [
                                      //     Text(
                                      //       timeDateViewModel.formattedDateTime,
                                      //       style: TextStyle(
                                      //         fontSize: 20,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            attendanceViewModel.statusMessage(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: themeViewModel
                                                    .currentTheme.textColor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 20,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        ConfimationDialogBox(
                                                          title:
                                                              'Confirm Time Out',
                                                          content:
                                                              'Are you sure you want to time out?',
                                                          onYes: () async {
                                                            await attendanceViewModel
                                                                .timeOut();
                                                            await attendanceViewModel
                                                                .fetchUserAttendance(
                                                                    timeDateViewModel
                                                                        .dateTime);
                                                            Navigator.pop(
                                                                // ignore: use_build_context_synchronously
                                                                context);
                                                            showDialog(
                                                                // ignore: use_build_context_synchronously
                                                                context:
                                                                    context,
                                                                builder: (context) =>
                                                                    attendanceViewModel
                                                                            .isSuccessInOut
                                                                        ? PromptDialogBox(
                                                                            icon:
                                                                                Icons.check_circle,
                                                                            title:
                                                                                'Time Out Successful',
                                                                            content:
                                                                                'You have successfully time out',
                                                                            buttonText:
                                                                                'OK',
                                                                            isSuccess:
                                                                                attendanceViewModel.isSuccessInOut,
                                                                            onPressed: () =>
                                                                                Navigator.pop(context),
                                                                          )
                                                                        : PromptDialogBox(
                                                                            icon:
                                                                                Icons.error_outline,
                                                                            title:
                                                                                'Time Out Failed',
                                                                            content:
                                                                                attendanceViewModel.errorMessage ?? 'You have failed to time out',
                                                                            buttonText:
                                                                                'OK',
                                                                            isSuccess:
                                                                                attendanceViewModel.isSuccessInOut,
                                                                            onPressed: () =>
                                                                                Navigator.pop(context),
                                                                          ));
                                                          },
                                                          onNo: () =>
                                                              Navigator.pop(
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
                                                _showSpinner
                                                    ? 'Loading...'
                                                    : 'TIME OUT',
                                                style: TextStyle(
                                                    color: themeViewModel
                                                        .currentTheme
                                                        .boxTextColor),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        ConfimationDialogBox(
                                                          title:
                                                              'Confirm Time In',
                                                          content:
                                                              'Are you sure you want to time in?',
                                                          onYes: () async {
                                                            setState(() {
                                                              _showSpinner =
                                                                  true;
                                                            });
                                                            try {
                                                              await attendanceViewModel
                                                                  .timeIn();
                                                              await attendanceViewModel
                                                                  .fetchUserAttendance(
                                                                      timeDateViewModel
                                                                          .dateTime);
                                                              Navigator.pop(
                                                                  // ignore: use_build_context_synchronously
                                                                  context);
                                                            } finally {
                                                              setState(() {
                                                                _showSpinner =
                                                                    false;
                                                              });
                                                            }
                                                            showDialog(
                                                                // ignore: use_build_context_synchronously
                                                                context:
                                                                    context,
                                                                builder: (context) =>
                                                                    attendanceViewModel
                                                                            .isSuccessInOut
                                                                        ? PromptDialogBox(
                                                                            icon:
                                                                                Icons.check_circle,
                                                                            title:
                                                                                'Time In Successful',
                                                                            content:
                                                                                'You have successfully time in',
                                                                            buttonText:
                                                                                'OK',
                                                                            isSuccess:
                                                                                attendanceViewModel.isSuccessInOut,
                                                                            onPressed: () =>
                                                                                Navigator.pop(context),
                                                                          )
                                                                        : PromptDialogBox(
                                                                            icon:
                                                                                Icons.error_outline,
                                                                            title:
                                                                                'Time In Failed',
                                                                            content:
                                                                                attendanceViewModel.errorMessage ?? 'You have failed to time in',
                                                                            buttonText:
                                                                                'OK',
                                                                            isSuccess:
                                                                                attendanceViewModel.isSuccessInOut,
                                                                            onPressed: () =>
                                                                                Navigator.pop(context),
                                                                          ));
                                                          },
                                                          onNo: () =>
                                                              Navigator.pop(
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
                                                _showSpinner
                                                    ? 'Loading...'
                                                    : 'TIME IN',
                                                style: TextStyle(
                                                    color: themeViewModel
                                                        .currentTheme
                                                        .boxTextColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AttendancePage(
                                                      attendanceViewModel:
                                                          attendanceViewModel,
                                                      timeDateViewModel:
                                                          timeDateViewModel),
                                            )),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/attendance.png',
                                              height: 75,
                                              width: 75,
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
                                            Image.asset(
                                              'lib/assets/leave.png',
                                              height: 75,
                                              width: 75,
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
                                            Image.asset(
                                              'lib/assets/overtime.png',
                                              height: 75,
                                              width: 75,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, '/payslip'),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/payslip.png',
                                              height: 75,
                                              width: 75,
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
                                            Image.asset(
                                              'lib/assets/team.png',
                                              height: 75,
                                              width: 75,
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
                                            Image.asset(
                                              'lib/assets/schedule.png',
                                              height: 75,
                                              width: 75,
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
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
