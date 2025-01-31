import 'package:flutter/material.dart';

class BasicInfo extends StatelessWidget{

  const BasicInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: John Doe'),
            Text('Age: 25'),
          ],
        ),
      ),
    );
  }
}