import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/profile_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:flutter_attendance_system/widgets/profile_info_tile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await profileViewModel.getUserInformation();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
              color: themeViewModel.currentTheme.boxTextColor,
              ),
        ),
        backgroundColor: themeViewModel.currentTheme.themeColor,
        iconTheme: IconThemeData(color: themeViewModel.currentTheme.boxTextColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    profileViewModel.profileInfoList[0].title,
                    style: TextStyle(
                      fontSize: 15,
                      color: themeViewModel.currentTheme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: profileViewModel.profileInfoList[0].value?.length,
              itemBuilder: (context, index){
                return ProfileInfoTile(
                  title: profileViewModel.profileInfoList[0].value!.keys.elementAt(index),
                  subtitle: profileViewModel.profileInfoList[0].value!.values.elementAt(index), 
                );
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    profileViewModel.profileInfoList[1].title,
                    style: TextStyle(
                      fontSize: 15,
                      color: themeViewModel.currentTheme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: profileViewModel.profileInfoList[1].value?.length,
              itemBuilder: (context, index){
                return ProfileInfoTile(
                  title: profileViewModel.profileInfoList[1].value!.keys.elementAt(index),
                  subtitle: profileViewModel.profileInfoList[1].value!.values.elementAt(index), 
                );
              }
            ),
            

          ],
        ),
      )
    );
  }
}
