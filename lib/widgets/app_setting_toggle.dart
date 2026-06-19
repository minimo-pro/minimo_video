import 'package:flutter/material.dart';

import 'animated_asset_checkbox.dart';
import '../theme/app_colors.dart';

class AppSettingToggle extends StatelessWidget {
  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSettingToggle({
    super.key,
    required this.title,
    this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CompressionUiColors.dark,
                      fontSize: 17,
                      height: 1,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      description!,
                      style: const TextStyle(
                        color: CompressionUiColors.grey,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            IgnorePointer(
              child: AnimatedAssetCheckbox(
                value: value,
                onChanged: (_) {},
                size: 29,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
