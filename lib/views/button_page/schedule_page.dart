import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theviewModel = Provider.of<ThemeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theviewModel.currentTheme.themeColor,
        title: Text(
          'Schedule',
          style: TextStyle(
            color: theviewModel.currentTheme.boxTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: theviewModel.currentTheme.boxTextColor),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('View News'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Add News'),
            ),
          ],
        ),
      ),
    );
  }
}
