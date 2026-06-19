import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppOption<T> {
  final T value;
  final String label;
  final String? description;

  const AppOption({required this.value, required this.label, this.description});
}

class AppOptionPicker<T> extends StatelessWidget {
  final T value;
  final List<AppOption<T>> options;
  final ValueChanged<T> onChanged;

  const AppOptionPicker({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final selected = option.value == value;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(option.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: selected
                  ? CompressionUiColors.red
                  : CompressionUiColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? CompressionUiColors.red
                    : CompressionUiColors.grey,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.label,
                  style: TextStyle(
                    color: selected
                        ? CompressionUiColors.white
                        : CompressionUiColors.dark,
                    fontSize: 16,
                    height: 1,
                  ),
                ),
                if (option.description != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    option.description!,
                    style: TextStyle(
                      color: selected
                          ? CompressionUiColors.white.withValues(alpha: 0.82)
                          : CompressionUiColors.grey,
                      fontSize: 12,
                      height: 1.1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
