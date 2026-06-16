import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Color(0xFF6C63FF);

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    fontFamily: 'Pangolin',
    useMaterial3: true,
  );

  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Pangolin',
    useMaterial3: true,
  );
}
