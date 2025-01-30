import 'package:flutter/material.dart';

class ThemeModel {
  final Color themeColor;
  final Color textColor;
  final Color boxTextColor;
  final Color backgroundColor;
  final Color pageBackgroundColor;
  final Color buttonColor;

  ThemeModel({
    required this.themeColor,
    required this.textColor,
    required this.boxTextColor,
    required this.backgroundColor,
    required this.pageBackgroundColor,
    required this.buttonColor,
  });
}

class ThemeManager {
  static final ThemeModel lightTheme = ThemeModel(
    themeColor: Colors.deepOrange,
    textColor: Colors.black,
    boxTextColor: Colors.white,
    backgroundColor: Colors.white,
    pageBackgroundColor: Colors.grey[100]!,
    buttonColor: Colors.deepOrange,
  );

  static final ThemeModel darkTheme = ThemeModel(
    themeColor: Colors.black,
    textColor: Colors.white,
    boxTextColor: Colors.black,
    backgroundColor: Colors.grey[900]!,
    pageBackgroundColor: Colors.grey,
    buttonColor: Colors.grey[800]!,
  );

  static final ThemeModel customTheme = ThemeModel(
    themeColor: Colors.teal,
    textColor: Colors.black,
    boxTextColor: Colors.white,
    backgroundColor: Colors.white,
    pageBackgroundColor: Color.fromARGB(255, 224, 219, 219),
    buttonColor: Colors.teal,
  );
}