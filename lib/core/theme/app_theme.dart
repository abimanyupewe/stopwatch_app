import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF2F5F8);
  static const Color primaryText = Colors.black87;
  static const Color accent = Color(0xFFE3EDF7);
  static const Color shadowLight = Colors.white;
  static const Color shadowDark = Color(
    0xFFA6B0C3,
  ); // Slightly darker for neumorphic shadow

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: accent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        surface: background,
        onSurface: primaryText,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: primaryText,
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: primaryText, fontSize: 16),
      ),
    );
  }
}
