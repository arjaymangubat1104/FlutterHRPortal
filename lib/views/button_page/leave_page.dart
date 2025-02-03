import 'package:flutter/material.dart';

class LeavePage extends StatelessWidget{
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Request Leave'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Cancel Leave'),
            ),
          ],
        ),
      ),
    );
  }
}