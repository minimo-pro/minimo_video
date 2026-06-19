import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_action_button.dart';
import '../../bloc/compress_bloc.dart';
import '../../bloc/compress_event.dart';
import '../../bloc/compress_state.dart';
import '../utils/compression_estimate.dart';
import 'selected_videos_preview.dart';

class CompressionProgressView extends StatelessWidget {
  final CompressState state;

  const CompressionProgressView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final progress = state.progress.clamp(0.0, 1.0);
    final percent = (progress * 100).round();

    return Column(
      children: [
        const Spacer(flex: 3),
        SelectedVideosPreview(
          selectedCount: state.videos.length,
          thumbnailPaths: state.thumbnailPaths,
          scale: 1.72,
        ),
        const SizedBox(height: 30),
        _ProgressSizeComparison(state: state),
        const Spacer(flex: 2),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$percent%',
            style: const TextStyle(
              color: CompressionUiColors.dark,
              fontSize: 18,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: CompressionUiColors.lightGrey,
            color: CompressionUiColors.red,
          ),
        ),
        const SizedBox(height: 13),
        Text(
          _remainingTimeLabel(strings),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: CompressionUiColors.grey,
            fontSize: 17,
            height: 1,
          ),
        ),
        const Spacer(flex: 4),
        AppActionButton(
          width: double.infinity,
          label: strings.cancel,
          onPressed: () =>
              context.read<CompressBloc>().add(const CompressCancelled()),
        ),
      ],
    );
  }

  String _remainingTimeLabel(S strings) {
    if (state.progress < 0.02 || state.elapsed.inSeconds < 1) {
      return strings.estimatingTimeRemaining;
    }

    final totalMilliseconds =
        state.elapsed.inMilliseconds / state.progress.clamp(0.01, 1);
    final remaining = Duration(
      milliseconds: (totalMilliseconds - state.elapsed.inMilliseconds)
          .round()
          .clamp(0, 86400000)
          .toInt(),
    );

    if (remaining.inSeconds < 60) {
      return strings.secondsRemaining(remaining.inSeconds.clamp(1, 59));
    }
    return strings.minutesRemaining(
      (remaining.inSeconds / 60).ceil().clamp(1, 1440),
    );
  }
}

class _ProgressSizeComparison extends StatelessWidget {
  final CompressState state;

  const _ProgressSizeComparison({required this.state});

  @override
  Widget build(BuildContext context) {
    final estimatedSize = CompressionEstimate.compressedSize(
      originalSize: state.totalOriginalSize,
      settings: state.settings,
    );

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                Utils.formatSize(state.totalOriginalSize).toLowerCase(),
                maxLines: 1,
                style: const TextStyle(
                  color: CompressionUiColors.dark,
                  fontSize: 28,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          SizedBox(
            width: 29,
            height: 24,
            child: SvgPicture.asset(AppIcons.arrowRight, width: 29, height: 24),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Utils.formatSize(estimatedSize).toLowerCase(),
                maxLines: 1,
                style: const TextStyle(
                  color: CompressionUiColors.red,
                  fontSize: 28,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
