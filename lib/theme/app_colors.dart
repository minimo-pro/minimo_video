import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color frameBackground;
  final Color frameBorder;
  final Color icon;

  const AppColors({
    required this.frameBackground,
    required this.frameBorder,
    required this.icon,
  });

  static const light = AppColors(
    frameBackground: Color(0xFFD9D9D9),
    frameBorder: Color(0xFFA8A8A8),
    icon: Color(0xFF272727),
  );

  static const dark = AppColors(
    frameBackground: Color(0xFF3A3A3A),
    frameBorder: Color(0xFF636363),
    icon: Color(0xFFE0E0E0),
  );

  @override
  AppColors copyWith({
    Color? frameBackground,
    Color? frameBorder,
    Color? icon,
  }) {
    return AppColors(
      frameBackground: frameBackground ?? this.frameBackground,
      frameBorder: frameBorder ?? this.frameBorder,
      icon: icon ?? this.icon,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      frameBackground: Color.lerp(frameBackground, other.frameBackground, t)!,
      frameBorder: Color.lerp(frameBorder, other.frameBorder, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
    );
  }
}
