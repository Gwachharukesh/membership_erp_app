import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple theme notifier using ValueNotifier. Persists to SharedPreferences.
class ThemeNotifier {
  ThemeNotifier._();

  static const _prefKey = 'app_theme_mode';

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static Future<void> initTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'system';
    themeNotifier.value = _fromString(saved);
  }

  static Future<void> toggleTheme() async {
    final themeMode = themeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    themeNotifier.value = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _toString(themeMode));
  }

  static String _toString(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        _ => 'system',
      };

  static ThemeMode _fromString(String value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
