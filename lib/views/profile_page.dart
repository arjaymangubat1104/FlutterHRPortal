import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/auth_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/profile_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
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
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: themeViewModel.currentTheme.boxTextColor,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: themeViewModel.currentTheme.boxTextColor,
            ),
            onPressed: () async {
              await authViewModel.logout(context);
              // setState(() {
              //   _showSpinner = true;
              // });
              // try {
                
              // } finally {
              //   setState(() {
              //     _showSpinner = false;
              //   });
              // }
            },
          ),
        ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themeViewModel
                            .currentTheme.boxTextColor, // Outline color
                        width: 2.0, // Outline width
                      ),
                      shape: BoxShape.circle, // Circular outline
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/profile.png',
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        '${authViewModel.userModel?.firstName ?? ''} ${authViewModel.userModel?.lastName ?? ''}',
                        style: TextStyle(
                          color: themeViewModel.currentTheme.boxTextColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        authViewModel.userModel?.email ?? '',
                        style: TextStyle(
                          color: themeViewModel.currentTheme.boxTextColor,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: profileViewModel.profileInfoList.length,
                  itemBuilder: (context, index) {
                    return ProfileInfoTile(
                        title: profileViewModel.profileInfoList[index].title, 
                        imgPath: profileViewModel.profileInfoList[index].imgPath,
                        value: profileViewModel.profileInfoList[index].value,
                    );
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
