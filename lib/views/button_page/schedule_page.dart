import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget{
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: Center(
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
    );
  }
}