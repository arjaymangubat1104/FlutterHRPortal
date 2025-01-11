import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final Color? textColor;

  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(color ?? Theme.of(context).primaryColor),
      ),
    );
  }
}