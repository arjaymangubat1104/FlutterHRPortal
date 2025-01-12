import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'viewmodel/auth_view_model.dart';
import 'viewmodel/time_date_view_model.dart';
import 'views/files_page.dart';
import 'views/home_page.dart';
import 'views/intro_page.dart';
import 'views/login_page.dart';
import 'views/profile_page.dart';
import 'views/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyC5iImd33g5q9u-TEQfd6ctpFVgMfjcLYQ', 
      appId: '1:973475796713:ios:93711787d1aeec4e670278', 
      messagingSenderId: '973475796713', 
      projectId: 'flutterattendance-13ad7'
    )
  );
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
          '/files': (context) => FilesPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}
