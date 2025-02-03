import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget{
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('View Team'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Add Team Member'),
            ),
          ],
        ),
      ),
    );
  }
}