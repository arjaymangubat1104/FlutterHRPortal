import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';

class ProfileInfoTile extends StatelessWidget{
  final String title;
  //final List<String> contentTile;
  final String imgPath;
  final Map<String, String>? value;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.imgPath,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: themeViewModel.currentTheme.backgroundColor,
          child: SingleChildScrollView(
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 10),
              leading: Image.asset(
                imgPath,
                height: 40,
                width: 40,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: themeViewModel.currentTheme.textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}