import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../theme/app_colors.dart';
import '../../domain/compression_settings.dart';

class SimpleQualityCard extends StatelessWidget {
  final bool selected;
  final SimpleCompressionQuality quality;
  final String title;
  final String subtitle;
  final ValueChanged<SimpleCompressionQuality> onSelected;

  const SimpleQualityCard({
    super.key,
    required this.selected,
    required this.quality,
    required this.title,
    required this.subtitle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(quality),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        height: 69,
        padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
        decoration: BoxDecoration(
          color: selected
              ? CompressionUiColors.red
              : CompressionUiColors.lightGrey,
          borderRadius: BorderRadius.circular(13),
          border: selected ? null : Border.all(color: CompressionUiColors.grey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected
                          ? CompressionUiColors.white
                          : CompressionUiColors.dark,
                      fontSize: 30,
                      height: 0.85,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? CompressionUiColors.white
                          : CompressionUiColors.dark,
                      fontSize: 15,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              SvgPicture.asset(
                AppIcons.check,
                colorFilter: ColorFilter.mode(
                  CompressionUiColors.white,
                  BlendMode.srcIn,
                ),
                width: 28,
                height: 23,
              ),
          ],
        ),
      ),
    );
  }
}
