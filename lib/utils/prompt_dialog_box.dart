import 'package:flutter/material.dart';

class PromptDialogBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final String buttonText;
  final bool isSuccess;
  final Function onPressed;

  const PromptDialogBox({
    super.key, 
    required this.icon,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.isSuccess,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Icon(
            icon,
            color: isSuccess ? Colors.green : Colors.red,
            size: 75,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => onPressed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}