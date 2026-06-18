import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  final Brightness brightness;

  const AppTheme({this.brightness = Brightness.light});

  static const _seedColor = Color(0xFF6C63FF);

  static ThemeData get light => _theme(Brightness.light);

  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Pangolin',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? colorScheme.surface
          : LightModeColors.background,
      dividerColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark
            ? colorScheme.surface
            : LightModeColors.background,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: brightness,
          systemNavigationBarColor: isDark
              ? colorScheme.surface
              : LightModeColors.background,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
    );
  }

  static AppTheme of(BuildContext context) {
    return AppTheme(brightness: Theme.of(context).brightness);
  }

  bool get isDarkTheme => brightness == Brightness.dark;

  Color get backgroundColor => isDarkTheme
      ? ThemeData.dark().colorScheme.surface
      : LightModeColors.background;

  Color get textColor =>
      isDarkTheme ? DarkModeColors.icon : LightModeColors.text;

  Color get secondaryTextColor => LightModeColors.secondaryText;

  Color get accentColor => LightModeColors.accent;

  Color get onAccentColor => LightModeColors.onAccent;

  Color get frameBackgroundColor => isDarkTheme
      ? DarkModeColors.frameBackground
      : LightModeColors.frameBackground;

  Color get frameBorderColor =>
      isDarkTheme ? DarkModeColors.frameBorder : LightModeColors.frameBorder;

  Color get iconColor =>
      isDarkTheme ? DarkModeColors.icon : LightModeColors.text;
}
