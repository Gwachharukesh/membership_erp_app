import 'package:flutter/material.dart';
import 'package:membership_erp_app/common/constants/shared_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemes {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF008A3F),
    scaffoldBackgroundColor: Color(0xFFEFF3ED),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black, // text & icons
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF008A3F),
      onPrimary: Colors.white,
      surface: Color(0xFFFDFDFD),
      onSurface: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF008A3F),
        foregroundColor: Colors.white,
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF95E0A5),
    scaffoldBackgroundColor: Color(0xFF181F1B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF181F1B),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF95E0A5),
      onPrimary: Colors.white,
      surface: Color(0xFF121212),

      onSurface: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF95E0A5),
        foregroundColor: Colors.white,
      ),
    ),
  );
}

class ThemeNotifier {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier(ThemeMode.light);

  static void toggleTheme() {
    themeModeNotifier.value =
        themeModeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save to local whenever theme changes
    _saveTheme(themeModeNotifier.value);
  }

  /// Save theme mode to local
  static Future<void> _saveTheme(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      SharedConstant.themeMode,
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  /// Load theme from local.
  /// If no theme is saved, default to light theme.
  static Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString(SharedConstant.themeMode);

    if (theme == 'dark') {
      themeModeNotifier.value = ThemeMode.dark;
    } else {
      themeModeNotifier.value = ThemeMode.light;
    }
  }
}
