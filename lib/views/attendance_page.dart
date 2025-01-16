import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget{
  const AttendancePage({
    super.key
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Attendance'
          )
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Time In'),
            Tab(text: 'Time Out'),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Time In'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Time Out'),
            ),
          ],
        ),
      ),
    );
  }
}