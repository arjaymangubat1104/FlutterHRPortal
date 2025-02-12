import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:flutter_attendance_system/widgets/filed_schdule_tile.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({
    super.key,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeViewModel.currentTheme.themeColor,
        title: Text(
          'Schedule',
          style: TextStyle(
            color: themeViewModel.currentTheme.boxTextColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeViewModel.currentTheme.boxTextColor,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Filed',
            ),
            Tab(
              text: 'Forms',
            ),
          ],
          dividerColor: themeViewModel.currentTheme.themeColor,
          indicatorColor: themeViewModel.currentTheme.boxTextColor,
          unselectedLabelColor: themeViewModel.currentTheme.boxTextColor,
          labelColor: themeViewModel.currentTheme.boxTextColor,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: themeViewModel.currentTheme.pageBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Filed Schedule',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return FilesSchduleTile(
                        date: '2021-09-01',
                        statusMessage: 'Pending',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Center(
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
        ],
      ),
    );
  }
}
