import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/app_colors.dart';

class SelectedVideosPreview extends StatelessWidget {
  final int selectedCount;
  final List<String?> thumbnailPaths;

  const SelectedVideosPreview({
    super.key,
    required this.selectedCount,
    required this.thumbnailPaths,
  });

  @override
  Widget build(BuildContext context) {
    final positions = _positionsForCount(selectedCount.clamp(1, 3));

    return SizedBox(
      width: 124,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < positions.length; i++)
            Positioned(
              left: positions[i].dx,
              top: positions[i].dy,
              child: _VideoThumb(path: _thumbnailAt(i), width: 58, height: 46),
            ),
          if (selectedCount > 1)
            Positioned(
              right: -2,
              top: 10,
              child: _SelectedCountBadge(count: selectedCount),
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

  const _VideoThumb({
    required this.path,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: path == null
          ? Container(
              width: width,
              height: height,
              color: Colors.transparent,
              child: SvgPicture.asset(
                'assets/icons/video.svg',
                width: 21,
                height: 28,
              ),
            )
          : Image.file(
              File(path!),
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
    );
  }
}

class _SelectedCountBadge extends StatelessWidget {
  final int count;

  const _SelectedCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: CompressionUiColors.red,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: const TextStyle(
          color: CompressionUiColors.white,
          fontSize: 21,
          height: 1,
        ),
      ),
    );
  }
}
