import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';

class ProfileInfoTile extends StatelessWidget{
  final String title;
  final String subtitle;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: themeViewModel.currentTheme.textColor,
              width: 0.5,
            ),
          )
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 10),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: themeViewModel.currentTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}