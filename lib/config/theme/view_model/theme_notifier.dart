import 'package:flutter/material.dart';

import '../repository/theme_repository.dart';

class ThemeNotifier extends ChangeNotifier {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static final ThemeRepository _repo = SharedPrefsThemeStorage();

  static Future<void> initTheme() async {
    final savedTheme = await _repo.loadTheme();
    themeNotifier.value = savedTheme;
  }

  static Future<void> toggleTheme() async {
    final themeMode = themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    themeNotifier.value = themeMode;

    await _repo.saveTheme(themeMode);
  }
}
