import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import 'pressable.dart';

enum AppActionButtonVariant { filled, outlined, text }

class AppActionButton extends StatelessWidget {
  final String? label;
  final String? icon;
  final VoidCallback? onPressed;
  final AppActionButtonVariant variant;
  final double height;
  final double? width;
  final double fontSize;
  final double iconWidth;
  final double iconHeight;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? side;
  final BorderRadius borderRadius;

  const AppActionButton({
    super.key,
    this.label,
    this.icon,
    required this.onPressed,
    this.variant = AppActionButtonVariant.outlined,
    this.height = 47,
    this.width,
    this.fontSize = 25,
    this.iconWidth = 22,
    this.iconHeight = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.backgroundColor,
    this.foregroundColor,
    this.side,
    this.borderRadius = const BorderRadius.all(Radius.circular(13)),
  }) : assert(label != null || icon != null);

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == AppActionButtonVariant.filled;
    final foreground =
        foregroundColor ??
        (isFilled
            ? CompressionUiColors.white
            : Theme.of(context).colorScheme.onSurface);
    final background =
        backgroundColor ??
        (isFilled
            ? CompressionUiColors.red
            : variant == AppActionButtonVariant.outlined
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Colors.transparent);
    final shape = RoundedRectangleBorder(borderRadius: borderRadius);
    final baseStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      padding: WidgetStatePropertyAll(padding),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Theme.of(context).colorScheme.surfaceContainerHighest;
        }
        return background;
      }),
      foregroundColor: WidgetStatePropertyAll(foreground),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(shape),
      side: variant == AppActionButtonVariant.outlined
          ? WidgetStatePropertyAll(
              side ?? BorderSide(color: Theme.of(context).colorScheme.outline),
            )
          : null,
    );

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          SvgPicture.asset(
            icon!,
            width: iconWidth,
            height: iconHeight,
            colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
          ),
        if (icon != null && label != null) const SizedBox(width: 10),
        if (label != null)
          Flexible(
            child: Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize, height: 1),
            ),
          ),
      ],
    );

    final button = switch (variant) {
      AppActionButtonVariant.filled => FilledButton(
        onPressed: onPressed,
        style: baseStyle,
        child: child,
      ),
      AppActionButtonVariant.outlined => OutlinedButton(
        onPressed: onPressed,
        style: baseStyle,
        child: child,
      ),
      AppActionButtonVariant.text => TextButton(
        onPressed: onPressed,
        style: baseStyle,
        child: child,
      ),
    };

    return Pressable(
      enabled: onPressed != null,
      child: SizedBox(width: width, height: height, child: button),
    );
  }
}
