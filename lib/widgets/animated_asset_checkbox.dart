import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../theme/app_theme.dart';

class AnimatedAssetCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  const AnimatedAssetCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Semantics(
      checked: value,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: SizedBox.square(
          dimension: size,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: SvgPicture.asset(
                value ? AppIcons.checkboxFull : AppIcons.checkboxEmpty,
                key: ValueKey(value),
                width: size,
                height: size,
                colorFilter: ColorFilter.mode(theme.iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
