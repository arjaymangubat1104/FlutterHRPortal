import 'package:flutter/material.dart';

class OverTimePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overtime'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Request Overtime'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Cancel Overtime'),
            ),
          ],
        ),
      ),
    );
  }
}