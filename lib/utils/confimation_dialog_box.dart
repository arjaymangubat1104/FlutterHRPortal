import 'package:flutter/material.dart';

class ConfimationDialogBox extends StatelessWidget{
  final String title;
  final String content;
  final Function onYes;
  final Function onNo;

  const ConfimationDialogBox({
    required this.title,
    required this.content,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => onNo(),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => onYes(),
          child: Text('Yes'),
        ),
      ],
    );
  }
}