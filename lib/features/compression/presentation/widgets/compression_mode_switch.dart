import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

enum CompressionOptionsMode { simple, advanced }

class CompressionModeSwitch extends StatelessWidget {
  final CompressionOptionsMode value;
  final ValueChanged<CompressionOptionsMode> onChanged;

  const CompressionModeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: CompressionUiColors.lightGrey,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: value == CompressionOptionsMode.simple
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: CompressionUiColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _ModeButton(
                label: 'simple options',
                mode: CompressionOptionsMode.simple,
                selected: value == CompressionOptionsMode.simple,
                onTap: onChanged,
              ),
              _ModeButton(
                label: 'advanced options',
                mode: CompressionOptionsMode.advanced,
                selected: value == CompressionOptionsMode.advanced,
                onTap: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final CompressionOptionsMode mode;
  final bool selected;
  final ValueChanged<CompressionOptionsMode> onTap;

  const _ModeButton({
    required this.label,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(mode),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              height: 1,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
