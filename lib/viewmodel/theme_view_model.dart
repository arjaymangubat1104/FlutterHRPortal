import 'package:flutter/material.dart';
import '../models/theme_model.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeModel _currentTheme = ThemeManager.customTheme;

  ThemeModel get currentTheme => _currentTheme;

  void switchTheme(ThemeModel theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}