import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:flutter_attendance_system/views/notification_page.dart';
import 'package:flutter_attendance_system/views/home_page.dart';
import 'package:flutter_attendance_system/views/profile_page.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final List<Widget> _pages = [
      const HomePage(),
      const NotificationPage(),
      const ProfilePage()
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: themeViewModel.currentTheme.backgroundColor,
        backgroundColor: themeViewModel.currentTheme.themeColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
