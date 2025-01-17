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
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Attendance',
            style: TextStyle(
              color: Colors.white
            ),
          )
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'HISTORY'),
            Tab(text: 'CALENDAR'),
          ],
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: Text('History'),
          ),
          Center(
            child: Text('Calendar'),
          ),
        ],
      ),
    );
  }
}