import 'package:flutter/material.dart';

class Global {
  // Use NotoSans
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    fontFamily: 'Noto Sans SC',
    brightness: Brightness.light,
  );
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Noto Sans SC',
    brightness: Brightness.dark,
  );
}
