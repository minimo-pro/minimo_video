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
  final bool compact;

  const SelectedVideosSummary({
    super.key,
    required this.selectedCount,
    required this.thumbnailPaths,
    required this.originalSize,
    required this.estimatedSize,
    required this.savingsPercent,
    this.sizeRowKey,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Column(
      children: [
        SelectedVideosPreview(
          selectedCount: selectedCount,
          thumbnailPaths: thumbnailPaths,
          scale: compact ? 0.82 : 1,
        ),
        SizedBox(height: compact ? 0 : 4),
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
                        fontSize: compact ? 23 : 28,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: compact ? 10 : 13),
              SizedBox(
                width: compact ? 24 : 29,
                height: compact ? 20 : 24,
                child: SvgPicture.asset(
                  AppIcons.arrowForward,
                  width: compact ? 24 : 29,
                  height: compact ? 20 : 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: compact ? 10 : 13),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RollingCounterText(
                      value: estimatedSize,
                      formatter: (value) =>
                          Utils.formatSize(value.toInt()).toLowerCase(),
                      style: TextStyle(
                        color: CompressionUiColors.red,
                        fontSize: compact ? 23 : 28,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 10 : 18),
        if (savingsPercent == 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              strings.noSavingsHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CompressionUiColors.red,
                fontSize: compact ? 16 : 18,
                height: 1.2,
              ),
            ),
          )
        else ...[
          RollingCounterText(
            value: savingsPercent,
            formatter: (value) => '${value.toInt()}%',
            style: TextStyle(
              color: CompressionUiColors.red,
              fontSize: compact ? 22 : 27,
              height: 0.9,
            ),
          ),
          Text(
            strings.smaller,
            style: TextStyle(
              color: CompressionUiColors.red,
              fontSize: compact ? 16 : 19,
              height: 1.15,
            ),
          ),
        ],
      ],
    );
  }
}
