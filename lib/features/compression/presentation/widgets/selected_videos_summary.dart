import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/rolling_counter_text.dart';
import 'selected_videos_preview.dart';

class SelectedVideosSummary extends StatelessWidget {
  final int selectedCount;
  final List<String?> thumbnailPaths;
  final int originalSize;
  final int estimatedSize;
  final int savingsPercent;
  final Key? sizeRowKey;

  const SelectedVideosSummary({
    super.key,
    required this.selectedCount,
    required this.thumbnailPaths,
    required this.originalSize,
    required this.estimatedSize,
    required this.savingsPercent,
    this.sizeRowKey,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Column(
      children: [
        SelectedVideosPreview(
          selectedCount: selectedCount,
          thumbnailPaths: thumbnailPaths,
        ),
        const SizedBox(height: 4),
        SizedBox(
          key: sizeRowKey,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Utils.formatSize(originalSize).toLowerCase(),
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 28,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              SizedBox(
                width: 29,
                height: 24,
                child: SvgPicture.asset(
                  AppIcons.arrowForward,
                  width: 29,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RollingCounterText(
                      value: estimatedSize,
                      formatter: (value) =>
                          Utils.formatSize(value.toInt()).toLowerCase(),
                      style: const TextStyle(
                        color: CompressionUiColors.red,
                        fontSize: 28,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        RollingCounterText(
          value: savingsPercent,
          formatter: (value) => '${value.toInt()}%',
          style: const TextStyle(
            color: CompressionUiColors.red,
            fontSize: 27,
            height: 0.9,
          ),
        ),
        Text(
          strings.smaller,
          style: const TextStyle(
            color: CompressionUiColors.red,
            fontSize: 19,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}
