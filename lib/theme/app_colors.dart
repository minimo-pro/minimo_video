import 'package:flutter/material.dart';

abstract final class LightModeColors {
  static const background = Color(0xFFF1F2F6);
  static const text = Color(0xFF272727);
  static const secondaryText = Color(0xFFA8A8A8);
  static const accent = Color(0xFFFC3636);
  static const success = Color(0xFF059A25);
  static const onAccent = Color(0xFFFFFFFF);
  static const frameBackground = Color(0xFFD9D9D9);
  static const frameBorder = Color(0xFFA8A8A8);
}

abstract final class DarkModeColors {
  static const background = Color(0xFF121212);
  static const text = Color(0xFFE0E0E0);
  static const secondaryText = Color(0xFFA8A8A8);
  static const accent = LightModeColors.accent;
  static const onAccent = LightModeColors.onAccent;
  static const frameBackground = Color(0xFF3A3A3A);
  static const frameBorder = Color(0xFF636363);
  static const icon = text;
}

abstract final class CompressionUiColors {
  static const red = LightModeColors.accent;
  static const green = LightModeColors.success;
  static const white = LightModeColors.onAccent;
  static const grey = LightModeColors.secondaryText;
}
