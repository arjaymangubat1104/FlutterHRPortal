import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';

class ProfileInfoTile extends StatelessWidget{
  final String title;
  //final List<String> contentTile;
  final IconData icon;
  final Map<String, String>? value;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.icon,
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
            child: ExpansionTile(
              leading: Icon(
                icon,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: themeViewModel.currentTheme.textColor,
                ),
              ),
              childrenPadding: EdgeInsets.only(top: 0),
              children: value?.entries.map((entry) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: themeViewModel.currentTheme.textColor,
                      width: 1,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )).toList() ?? []
            ),
          ),
        ),
      ),
    );
  }
}