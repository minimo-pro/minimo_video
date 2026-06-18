import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import 'selected_videos_preview.dart';

class SelectedVideosSummary extends StatelessWidget {
  final int selectedCount;
  final List<String?> thumbnailPaths;
  final int originalSize;
  final int estimatedSize;
  final int savingsPercent;

  const SelectedVideosSummary({
    super.key,
    required this.selectedCount,
    required this.thumbnailPaths,
    required this.originalSize,
    required this.estimatedSize,
    required this.savingsPercent,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Utils.formatSize(originalSize).toLowerCase(),
              style: const TextStyle(
                color: CompressionUiColors.dark,
                fontSize: 28,
                height: 1,
              ),
            ),
            const SizedBox(width: 13),
            SvgPicture.asset(AppIcons.arrowRight, width: 29, height: 24),
            const SizedBox(width: 13),
            Text(
              Utils.formatSize(estimatedSize).toLowerCase(),
              style: const TextStyle(
                color: CompressionUiColors.red,
                fontSize: 28,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          '$savingsPercent%',
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
