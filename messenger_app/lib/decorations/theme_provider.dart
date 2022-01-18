import 'package:flutter/material.dart';

class ThemeProvider {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.black,
      primaryColorDark: Colors.grey[850],
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, foregroundColor: Colors.black));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.white,
      primaryColorDark: Colors.grey[400],
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, foregroundColor: Colors.white));
}
