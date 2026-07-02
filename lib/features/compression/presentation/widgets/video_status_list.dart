import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../theme/app_colors.dart';
import '../../bloc/compress_state.dart';

class VideoStatusList extends StatelessWidget {
  final CompressState state;

  const VideoStatusList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 168),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: state.videos.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final status = index < state.videoStatuses.length
              ? state.videoStatuses[index]
              : VideoCompressionStatus.waiting;

          return Row(
            children: [
              _StatusDot(status: status),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  state.videos[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CompressionUiColors.dark,
                    fontSize: 15,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _label(strings, status),
                style: TextStyle(
                  color: _color(status),
                  fontSize: 15,
                  height: 1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _label(S strings, VideoCompressionStatus status) {
    return switch (status) {
      VideoCompressionStatus.waiting => strings.waiting,
      VideoCompressionStatus.processing => strings.compressing,
      VideoCompressionStatus.compressed => strings.compressed,
      VideoCompressionStatus.skipped => strings.alreadyOptimized,
      VideoCompressionStatus.failed => strings.failed,
    };
  }
}

class _StatusDot extends StatelessWidget {
  final VideoCompressionStatus status;

  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
