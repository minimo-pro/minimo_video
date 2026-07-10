import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/app_settings_service.dart';
import '../../../../services/thermal_service.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_snack_bar.dart';
import '../../../../widgets/hold_to_confirm_button.dart';
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 620;
              final topGap = compact ? 10.0 : 24.0;
              final previewScale = compact ? 1.34 : 1.72;
              final afterPreviewGap = compact ? 16.0 : 30.0;
              final progressGap = compact ? 16.0 : 28.0;
              final statusGap = compact ? 9.0 : 13.0;
              final listGap = compact ? 10.0 : 16.0;
              final warningGap = compact ? 10.0 : 14.0;
              final bottomGap = compact ? 12.0 : 24.0;

              return Column(
                children: [
                  SizedBox(height: topGap),
                  SelectedVideosPreview(
                    selectedCount: state.videos.length,
                    thumbnailPaths: state.thumbnailPaths,
                    scale: previewScale,
                  ),
                  SizedBox(height: afterPreviewGap),
                  _ProgressSizeComparison(state: state, compact: compact),
                  SizedBox(height: progressGap),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$percent%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: compact ? 16 : 18,
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
                      minHeight: compact ? 6 : 7,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      color: CompressionUiColors.red,
                    ),
                  ),
                  SizedBox(height: statusGap),
                  Text(
                    '${strings.videoProgress(state.processingIndex + 1, state.videos.length)} · ${_remainingTimeLabel(strings, state)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: compact ? 15 : 17,
                      height: 1.05,
                    ),
                  ),
                  SizedBox(height: listGap),
                  Flexible(
                    fit: FlexFit.loose,
                    child: VideoStatusList(state: state),
                  ),
                  if (defaultTargetPlatform == TargetPlatform.iOS) ...[
                    SizedBox(height: warningGap),
                    const _IosBackgroundWarning(),
                  ],
                  if (AppSettingsService.instance.showOverheatWarning &&
                      _showThermalWarning) ...[
                    SizedBox(height: warningGap),
                    const _OverheatWarning(),
                  ],
                  SizedBox(height: bottomGap),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        HoldToConfirmButton(
          label: strings.cancel,
          enabled: true,
          actionStyle: true,
          onTap: () => AppSnackBar.show(
            context,
            message: strings.holdToCancelCompression,
          ),
          onCompleted: () async {
            context.read<CompressBloc>().add(const CompressCancelled());
            AppSnackBar.show(
              context,
              message: strings.compressionCancelled,
              type: AppSnackBarType.success,
            );
          },
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

class _IosBackgroundWarning extends StatelessWidget {
  const _IosBackgroundWarning();

  @override
  Widget build(BuildContext context) =>
      _WarningBanner(message: S.of(context).iosBackgroundCompressionWarning);
}

class _OverheatWarning extends StatelessWidget {
  const _OverheatWarning();

  @override
  Widget build(BuildContext context) =>
      _WarningBanner(message: S.of(context).overheatWarning);
}

class _WarningBanner extends StatelessWidget {
  final String message;

  const _WarningBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final color = CompressionUiColors.red;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.18)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: SvgPicture.asset(
                  AppIcons.warning,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(color: color, fontSize: 14, height: 1.22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressSizeComparison extends StatelessWidget {
  final CompressState state;
  final bool compact;

  const _ProgressSizeComparison({required this.state, required this.compact});

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
                  fontSize: compact ? 23 : 28,
                  height: 1,
                ),
              ),
            ),
          ),
          SizedBox(width: compact ? 10 : 13),
          SizedBox(
            width: compact ? 24 : 29,
            height: compact ? 20 : 24,
            child: SvgPicture.asset(
              AppIcons.arrowForward,
              width: compact ? 24 : 29,
              height: compact ? 20 : 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: compact ? 10 : 13),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Utils.formatSize(estimatedSize).toLowerCase(),
                maxLines: 1,
                style: TextStyle(
                  color: CompressionUiColors.red,
                  fontSize: compact ? 23 : 28,
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
