import 'package:flutter/material.dart';

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
    // cardColor: Color(0x8076BF4E),
    cardColor: Color(0xFF008A3F),
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
    cardColor: Color(0x3349A96C),
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
