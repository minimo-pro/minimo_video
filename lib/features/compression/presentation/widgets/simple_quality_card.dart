import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/pressable.dart';
import '../../domain/compression_settings.dart';

class SimpleQualityCard extends StatelessWidget {
  final bool selected;
  final SimpleCompressionQuality quality;
  final String title;
  final String subtitle;
  final ValueChanged<SimpleCompressionQuality> onSelected;
  final bool compact;

  const SimpleQualityCard({
    super.key,
    required this.selected,
    required this.quality,
    required this.title,
    required this.subtitle,
    required this.onSelected,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      child: GestureDetector(
        onTap: () => onSelected(quality),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          height: compact ? 58 : 69,
          padding: EdgeInsets.fromLTRB(
            10,
            compact ? 7 : 8,
            14,
            compact ? 7 : 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? CompressionUiColors.red
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(13),
            border: selected
                ? null
                : Border.all(color: Theme.of(context).colorScheme.outline),
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
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: compact ? 25 : 30,
                        height: 0.85,
                      ),
                    ),
                    SizedBox(height: compact ? 6 : 8),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected
                            ? CompressionUiColors.white
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: compact ? 13 : 15,
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
      ),
    );
  }
}
