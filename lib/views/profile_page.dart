import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/profile_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:flutter_attendance_system/widgets/custom_elevated_button.dart';
import 'package:flutter_attendance_system/widgets/profile_info_tile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({
    super.key,
    });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);  

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: themeViewModel.currentTheme.boxTextColor,
          ),
        ),
        backgroundColor: themeViewModel.currentTheme.themeColor,
      ),
      body: Stack(
        children: [
          Container(
            color: themeViewModel.currentTheme.pageBackgroundColor,
            child: Column(
              children: [
                Container(
                  color: themeViewModel.currentTheme.themeColor,
                  height: 100,
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themeViewModel
                            .currentTheme.boxTextColor, // Outline color
                        width: 4.0, // Outline width
                      ),
                      shape: BoxShape.circle, // Circular outline
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/profile.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: SizedBox(
                  height: 500,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: profileViewModel.profileInfoList.length,
                    itemBuilder: (context, index) {
                      return ProfileInfoTile(
                          title: profileViewModel.profileInfoList[index].title, 
                          icon: profileViewModel.profileInfoList[index].icon,
                          value: profileViewModel.profileInfoList[index].value,
                      );
                    }
                  ),
                ),
               
              ),
            ],
          ),
        ],
      ),
    );
  }
}
