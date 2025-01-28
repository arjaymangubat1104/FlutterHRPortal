import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/attendance_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/auth_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/profile_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/schedule_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/time_date_view_model.dart';
import 'package:flutter_attendance_system/views/notification_page.dart';
import 'package:flutter_attendance_system/views/home_page.dart';
import 'package:flutter_attendance_system/views/intro_page.dart';
import 'package:flutter_attendance_system/views/leave_page.dart';
import 'package:flutter_attendance_system/views/login_page.dart';
import 'package:flutter_attendance_system/views/schedule_page.dart';
import 'package:flutter_attendance_system/views/ovetime_page.dart';
import 'package:flutter_attendance_system/views/payslip_page.dart';
import 'package:flutter_attendance_system/views/profile_page.dart';
import 'package:flutter_attendance_system/views/register_page.dart';
import 'package:flutter_attendance_system/views/team_page.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyC5iImd33g5q9u-TEQfd6ctpFVgMfjcLYQ',
          appId: '1:973475796713:ios:93711787d1aeec4e670278',
          messagingSenderId: '973475796713',
          projectId: 'flutterattendance-13ad7'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => TimeDateViewModel()),
        ChangeNotifierProvider(
          create: (context) => AttendanceViewModel(
            authViewModel: Provider.of<AuthViewModel>(context, listen: false),
            timeDateViewModel:
                Provider.of<TimeDateViewModel>(context, listen: false)
          ),
        ),
        ChangeNotifierProvider(create: (context) => ThemeViewModel()),
        ChangeNotifierProvider(create: (context) => ScheduleViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        // Add other providers here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase MVVM',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
          '/intro': (context) => IntroPage(),
          '/notification': (context) => NotificationPage(),
          '/profile': (context) => ProfilePage(),
          //'/attendance': (context) => AttendancePage(),
          '/overtime': (context) => OverTimePage(),
          '/payslip': (context) => PayslipPage(),
          '/leave': (context) => LeavePage(),
          '/team': (context) => TeamPage(),
          '/schedule': (context) => SchedulePage(),
        },
      ),
    );
  }
}
