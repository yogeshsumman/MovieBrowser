import 'package:flutter/material.dart';

// Purpose: Defines the app's visual theme, including colors, typography, and
// widget styles, to ensure a consistent UI across screens.
class AppTheme {
  static const Color backgroundColor = Color(0xFFF5F5F5); // Light grey
  static const Color textColor = Color(0xFF212121); // Dark grey

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: textColor),
        titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: textColor),
        titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: textColor),
        bodyLarge: TextStyle(fontSize: 14.0, color: textColor),
      ),
      cardTheme: const CardTheme(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 4.0,
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(fontSize: 16.0, color: textColor),
      ),
    );
  }
}