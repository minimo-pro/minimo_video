import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/app_settings_service.dart';
import '../../../../services/thermal_service.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_action_button.dart';
import '../../bloc/compress_bloc.dart';
import '../../bloc/compress_event.dart';
import '../../bloc/compress_state.dart';
import '../utils/compression_estimate.dart';
import 'selected_videos_preview.dart';
import 'video_status_list.dart';

class CompressionProgressView extends StatefulWidget {
  final CompressState state;

  const CompressionProgressView({super.key, required this.state});

  @override
  State<CompressionProgressView> createState() =>
      _CompressionProgressViewState();
}

class _CompressionProgressViewState extends State<CompressionProgressView> {
  Timer? _thermalTimer;
  var _showThermalWarning = false;

  @override
  void initState() {
    super.initState();
    _checkThermalState();
    _thermalTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkThermalState(),
    );
  }

  @override
  void dispose() {
    _thermalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final state = widget.state;
    final progress = state.displayProgress;
    final percent = (progress * 100).round();

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 24),
              SelectedVideosPreview(
                selectedCount: state.videos.length,
                thumbnailPaths: state.thumbnailPaths,
                scale: 1.72,
              ),
              const SizedBox(height: 30),
              _ProgressSizeComparison(state: state),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  key: ValueKey(state.compressionRunId),
                  value: progress,
                  minHeight: 7,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  color: CompressionUiColors.red,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                '${strings.videoProgress(state.processingIndex + 1, state.videos.length)} · ${_remainingTimeLabel(strings, state)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 17,
                  height: 1,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                fit: FlexFit.loose,
                child: VideoStatusList(state: state),
              ),
              if (AppSettingsService.instance.showOverheatWarning &&
                  _showThermalWarning) ...[
                const SizedBox(height: 14),
                const _OverheatWarning(),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppActionButton(
          width: double.infinity,
          label: strings.cancel,
          onPressed: () =>
              context.read<CompressBloc>().add(const CompressCancelled()),
        ),
      ],
    );
  }

  String _remainingTimeLabel(S strings, CompressState state) {
    final progress = state.displayProgress;
    if (progress < 0.02 || state.elapsed.inSeconds < 1) {
      return strings.estimatingTimeRemaining;
    }

    final totalMilliseconds = state.elapsed.inMilliseconds / progress;
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

  Future<void> _checkThermalState() async {
    if (!AppSettingsService.instance.showOverheatWarning) return;
    final state = await ThermalService.currentState();
    if (!mounted) return;
    final shouldWarn = ThermalService.shouldWarn(state);
    if (shouldWarn == _showThermalWarning) return;
    setState(() => _showThermalWarning = shouldWarn);
  }
}

class _OverheatWarning extends StatelessWidget {
  const _OverheatWarning();

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: CompressionUiColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          strings.overheatWarning,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: CompressionUiColors.red,
            fontSize: 14,
            height: 1.15,
          ),
        ),
      ),
    );
  }
}

class _ProgressSizeComparison extends StatelessWidget {
  final CompressState state;

  const _ProgressSizeComparison({required this.state});

  @override
  Widget build(BuildContext context) {
    final estimatedSize =
        state.estimatedSize ??
        CompressionEstimate.compressedSize(
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
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
            child: SvgPicture.asset(
              AppIcons.arrowForward,
              width: 29,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
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
