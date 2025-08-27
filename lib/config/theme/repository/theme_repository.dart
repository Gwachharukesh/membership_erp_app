import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/shared_constant.dart';

abstract class ThemeRepository {
  Future<void> saveTheme(ThemeMode themeMode);
  Future<ThemeMode> loadTheme();
}

class SharedPrefsThemeStorage extends ThemeRepository {
  @override
  Future<ThemeMode> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(SharedConstant.themeMode);

    switch (value) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedConstant.themeMode, themeMode.toString());
  }
}