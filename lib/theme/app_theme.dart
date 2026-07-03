import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  final Brightness brightness;

  const AppTheme({this.brightness = Brightness.light});

  static ThemeData get light => _theme(Brightness.light);

  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: DarkModeColors.accent,
            onPrimary: DarkModeColors.onAccent,
            secondary: DarkModeColors.accent,
            onSecondary: DarkModeColors.onAccent,
            surface: DarkModeColors.background,
            onSurface: DarkModeColors.text,
            surfaceContainerHighest: DarkModeColors.frameBackground,
            onSurfaceVariant: DarkModeColors.secondaryText,
            outline: DarkModeColors.frameBorder,
          )
        : const ColorScheme.light(
            primary: LightModeColors.accent,
            onPrimary: LightModeColors.onAccent,
            secondary: LightModeColors.accent,
            onSecondary: LightModeColors.onAccent,
            surface: LightModeColors.background,
            onSurface: LightModeColors.text,
            surfaceContainerHighest: LightModeColors.frameBackground,
            onSurfaceVariant: LightModeColors.secondaryText,
            outline: LightModeColors.frameBorder,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Pangolin',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: brightness,
          systemNavigationBarColor: colorScheme.surface,
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

  Color get backgroundColor =>
      isDarkTheme ? DarkModeColors.background : LightModeColors.background;

  Color get textColor =>
      isDarkTheme ? DarkModeColors.text : LightModeColors.text;

  Color get secondaryTextColor => isDarkTheme
      ? DarkModeColors.secondaryText
      : LightModeColors.secondaryText;

  Color get accentColor =>
      isDarkTheme ? DarkModeColors.accent : LightModeColors.accent;

  Color get onAccentColor =>
      isDarkTheme ? DarkModeColors.onAccent : LightModeColors.onAccent;

  Color get frameBackgroundColor => isDarkTheme
      ? DarkModeColors.frameBackground
      : LightModeColors.frameBackground;

  Color get frameBorderColor =>
      isDarkTheme ? DarkModeColors.frameBorder : LightModeColors.frameBorder;

  Color get iconColor =>
      isDarkTheme ? DarkModeColors.icon : LightModeColors.text;
}
