import 'package:flutter/material.dart';

class ThemeService {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, foregroundColor: Colors.black));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, foregroundColor: Colors.white));
}
