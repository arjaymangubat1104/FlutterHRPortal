import 'package:flutter/material.dart';

class PayslipPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payslip'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('View Payslip'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your code here
              },
              child: Text('Download Payslip'),
            ),
          ],
        ),
      ),
    );
  }
}