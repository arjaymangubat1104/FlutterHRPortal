import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/profile_view_model.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:flutter_attendance_system/widgets/loading_indicator.dart';

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
  bool _showSpinner = false;
  @override
  void initState() {
    super.initState();
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          _showSpinner = true;
        });
        await profileViewModel.getUserInformation();
      } finally {
        setState(() {
          _showSpinner = false;
        });
      }
    });
  }

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
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: themeViewModel.currentTheme.boxTextColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                            color: themeViewModel.currentTheme.boxTextColor,
                            fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
          backgroundColor: themeViewModel.currentTheme.themeColor,
          iconTheme:
              IconThemeData(color: themeViewModel.currentTheme.boxTextColor),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          profileViewModel.profileInfoList[0].value?.length,
                      itemBuilder: (context, index) {
                        return ProfileInfoTile(
                          title: profileViewModel.profileInfoList[0].value!.keys
                              .elementAt(index),
                          subtitle: profileViewModel
                              .profileInfoList[0].value!.values
                              .elementAt(index),
                        );
                      }),
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
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          profileViewModel.profileInfoList[1].value?.length,
                      itemBuilder: (context, index) {
                        return ProfileInfoTile(
                          title: profileViewModel.profileInfoList[1].value!.keys
                              .elementAt(index),
                          subtitle: profileViewModel
                              .profileInfoList[1].value!.values
                              .elementAt(index),
                        );
                      }),
                ],
              ),
            ),
            if (_showSpinner)
              ModalBarrier(
                color: Colors.black.withOpacity(0.5),
                dismissible: false,
              ),
            if (_showSpinner)
              Dialog.fullscreen(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CustomLoadingIndicator(),
                ),
              ),
          ],
        ));
  }
}
