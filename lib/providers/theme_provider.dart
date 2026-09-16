import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _themeKey = 'theme_dark_mode';

  late Box _box;
  bool _isDarkMode = false;

  ThemeProvider() {
    _box = Hive.box(_boxName);
    _isDarkMode = _box.get(_themeKey, defaultValue: false);
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _box.put(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
