import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';

class ConfimationDialogBox extends StatelessWidget {
  final String title;
  final String content;
  final Function onYes;
  final Function onNo;

  const ConfimationDialogBox({
    super.key, 
    required this.title,
    required this.content,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => onNo(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: themeViewModel.currentTheme.buttonColor),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
              ),
              child: Text(
                'No',
                style: TextStyle(
                  color: themeViewModel.currentTheme.buttonColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => onYes(),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeViewModel.currentTheme.buttonColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
              ),
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
