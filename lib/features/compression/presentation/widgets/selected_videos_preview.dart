import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../theme/app_colors.dart';

class SelectedVideosPreview extends StatelessWidget {
  final int selectedCount;
  final List<String?> thumbnailPaths;
  final double scale;

  const SelectedVideosPreview({
    super.key,
    required this.selectedCount,
    required this.thumbnailPaths,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    final positions = _positionsForCount(selectedCount.clamp(1, 3));

    return SizedBox(
      width: 124 * scale,
      height: 92 * scale,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < positions.length; i++)
            Positioned(
              left: positions[i].dx * scale,
              top: positions[i].dy * scale,
              child: _VideoThumb(
                path: _thumbnailAt(i),
                width: 58 * scale,
                height: 46 * scale,
                borderRadius: 9 * scale,
              ),
            ),
          if (selectedCount > 1)
            Positioned(
              left: (positions.last.dx + 43) * scale,
              top: (positions.last.dy - 24).clamp(0, double.infinity) * scale,
              child: _SelectedCountBadge(count: selectedCount, scale: scale),
            ),
        ],
      ),
    );
  }

  List<Offset> _positionsForCount(int count) {
    switch (count) {
      case 1:
        return const [Offset(33, 23)];
      case 2:
        return const [Offset(26, 26), Offset(54, 12)];
      default:
        return const [Offset(16, 22), Offset(52, 6), Offset(70, 34)];
    }
  }

  String? _thumbnailAt(int index) {
    if (index >= thumbnailPaths.length) return null;
    return thumbnailPaths[index];
  }
}

class _VideoThumb extends StatelessWidget {
  final String? path;
  final double width;
  final double height;
  final double borderRadius;

  const _VideoThumb({
    required this.path,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 8 * (width / 58),
            offset: Offset(0, 3 * (width / 58)),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.light
                  ? CompressionUiColors.white
                  : Theme.of(context).colorScheme.outline,
              width: 2 * (width / 58),
            ),
          ),
          child: path == null
              ? SizedBox(
                  width: width,
                  height: height,
                  child: SvgPicture.asset(
                    AppIcons.video,
                    width: 21,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : Image.file(
                  File(path!),
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class _SelectedCountBadge extends StatelessWidget {
  final int count;
  final double scale;

  const _SelectedCountBadge({required this.count, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34 * scale,
      height: 34 * scale,
      decoration: BoxDecoration(
        color: CompressionUiColors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 7 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: TextStyle(
          color: CompressionUiColors.white,
          fontSize: 21 * scale,
          height: 1,
        ),
      ),
    );
  }
}
