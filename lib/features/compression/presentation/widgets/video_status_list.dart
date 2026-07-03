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
        _StatusDot(status: status),
      ],
    );
  }
}

class _StatusDot extends StatefulWidget {
  final VideoCompressionStatus status;

  const _StatusDot({required this.status});

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
    lowerBound: 0.7,
    upperBound: 1,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimation();
  }

  @override
  void didUpdateWidget(_StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimation();
  }

  void _updateAnimation() {
    final shouldAnimate =
        widget.status == VideoCompressionStatus.processing &&
        !MediaQuery.disableAnimationsOf(context);
    if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!shouldAnimate) {
      _controller.stop();
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _color(widget.status),
          shape: BoxShape.circle,
        ),
        child: const SizedBox.square(dimension: 8),
      ),
    );
  }
}

Color _color(VideoCompressionStatus status) {
  return switch (status) {
    VideoCompressionStatus.waiting => CompressionUiColors.grey,
    VideoCompressionStatus.processing => CompressionUiColors.grey,
    VideoCompressionStatus.compressed => CompressionUiColors.green,
    VideoCompressionStatus.skipped => CompressionUiColors.grey,
    VideoCompressionStatus.failed => CompressionUiColors.red,
  };
}
