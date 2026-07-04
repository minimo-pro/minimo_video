import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/faded_scroll_view.dart';
import '../../bloc/compress_state.dart';

class VideoStatusList extends StatelessWidget {
  final CompressState state;

  const VideoStatusList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: FadedScrollView(
          fadeExtent: 0.12,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              for (var index = 0; index < state.videos.length; index++) ...[
                if (index > 0) const SizedBox(height: 10),
                _VideoStatusRow(state: state, index: index),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoStatusRow extends StatelessWidget {
  final CompressState state;
  final int index;

  const _VideoStatusRow({required this.state, required this.index});

  @override
  Widget build(BuildContext context) {
    final status = index < state.videoStatuses.length
        ? state.videoStatuses[index]
        : VideoCompressionStatus.waiting;

    return Row(
      children: [
        Expanded(
          child: Text(
            state.videos[index].name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _StatusIndicator(status: status, progress: state.currentVideoProgress),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final VideoCompressionStatus status;
  final double progress;

  const _StatusIndicator({required this.status, required this.progress});

  @override
  Widget build(BuildContext context) {
    if (status == VideoCompressionStatus.processing) {
      return SizedBox(
        key: const ValueKey('video-status-processing'),
        width: 34,
        child: Text(
          '${(progress * 100).round()}%',
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: CompressionUiColors.red,
            fontSize: 13,
            height: 1,
          ),
        ),
      );
    }

    return DecoratedBox(
      key: ValueKey('video-status-${status.name}'),
      decoration: BoxDecoration(color: _color(status), shape: BoxShape.circle),
      child: const SizedBox.square(dimension: 8),
    );
  }
}

Color _color(VideoCompressionStatus status) {
  return switch (status) {
    VideoCompressionStatus.waiting => CompressionUiColors.grey,
    VideoCompressionStatus.processing => CompressionUiColors.red,
    VideoCompressionStatus.compressed => CompressionUiColors.green,
    VideoCompressionStatus.skipped => CompressionUiColors.grey,
    VideoCompressionStatus.failed => CompressionUiColors.red,
  };
}
