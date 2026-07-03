import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_option_picker.dart';
import '../../../../widgets/app_setting_toggle.dart';
import '../../../../widgets/app_settings_section.dart';
import '../../../../widgets/crf_slider.dart';
import '../../../../widgets/faded_scroll_view.dart';
import '../../../../widgets/rolling_counter_text.dart';
import '../../../../widgets/spring_tab_content.dart';
import '../../bloc/compress_bloc.dart';
import '../../bloc/compress_event.dart';
import '../../bloc/compress_state.dart';
import '../../domain/compression_settings.dart';
import '../utils/compression_estimate.dart';
import '../utils/compression_labels.dart';
import 'compression_bottom_actions.dart';
import 'compression_mode_switch.dart';
import 'selected_videos_summary.dart';
import 'simple_quality_card.dart';

class CompressionSettingsView extends StatefulWidget {
  final CompressState state;
  final VoidCallback onBack;

  const CompressionSettingsView({
    super.key,
    required this.state,
    required this.onBack,
  });

  @override
  State<CompressionSettingsView> createState() =>
      _CompressionSettingsViewState();
}

class _CompressionSettingsViewState extends State<CompressionSettingsView> {
  static const _resolutions = <String?>[
    null,
    '1920:1080',
    '1280:720',
    '854:480',
    '640:360',
  ];

  CompressionOptionsMode _mode = CompressionOptionsMode.simple;
  final _sizeRowKey = GlobalKey();
  bool _showPinnedSummary = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePinnedSummary());
  }

  @override
  void didUpdateWidget(covariant CompressionSettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePinnedSummary());
  }

  bool _onScroll(ScrollNotification notification) {
    _updatePinnedSummary();
    return false;
  }

  void _updatePinnedSummary() {
    final viewBox = context.findRenderObject() as RenderBox?;
    final rowBox = _sizeRowKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewBox == null || rowBox == null || !rowBox.attached) return;

    final viewTop = viewBox.localToGlobal(Offset.zero).dy;
    final rowBottom = rowBox.localToGlobal(Offset(0, rowBox.size.height)).dy;
    final show = rowBottom <= viewTop + 4;
    if (show == _showPinnedSummary || !mounted) return;
    setState(() => _showPinnedSummary = show);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final estimatedSize =
        state.estimatedSize ??
        CompressionEstimate.compressedSize(
          originalSize: state.totalOriginalSize,
          settings: state.settings,
        );
    final savingsPercent = state.totalOriginalSize == 0
        ? 0
        : ((1 - estimatedSize / state.totalOriginalSize) * 100)
              .clamp(0, 99)
              .round();

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: FadedScrollView(
                  fadeExtent: 0.08,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      SelectedVideosSummary(
                        sizeRowKey: _sizeRowKey,
                        selectedCount: state.videos.length,
                        thumbnailPaths: state.thumbnailPaths,
                        originalSize: state.totalOriginalSize,
                        estimatedSize: estimatedSize,
                        savingsPercent: savingsPercent,
                      ),
                      const SizedBox(height: 22),
                      CompressionModeSwitch(
                        value: _mode,
                        onChanged: (value) =>
                            _changeMode(context, state.settings, value),
                      ),
                      const SizedBox(height: 24),
                      SpringTabContent(
                        value: _mode,
                        child: _mode == CompressionOptionsMode.simple
                            ? _SimpleCompressionOptions(state: state)
                            : _AdvancedCompressionOptions(state: state),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 4,
                left: 8,
                right: 8,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _showPinnedSummary ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    child: AnimatedSlide(
                      offset: _showPinnedSummary
                          ? Offset.zero
                          : const Offset(0, -0.35),
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      child: AnimatedScale(
                        scale: _showPinnedSummary ? 1 : 0.96,
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        child: _PinnedSizeSummary(
                          originalSize: state.totalOriginalSize,
                          estimatedSize: estimatedSize,
                          savingsPercent: savingsPercent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CompressionBottomActions(
          onBack: widget.onBack,
          onCompress: () =>
              context.read<CompressBloc>().add(const CompressStarted()),
        ),
      ],
    );
  }

  void _changeMode(
    BuildContext context,
    CompressionSettings settings,
    CompressionOptionsMode value,
  ) {
    setState(() => _mode = value);
    if (value != CompressionOptionsMode.advanced) return;
    context.read<CompressBloc>().add(
      CompressSettingsChanged(settings.copyWith(resolution: null)),
    );
  }
}

class _PinnedSizeSummary extends StatelessWidget {
  final int originalSize;
  final int estimatedSize;
  final int savingsPercent;

  const _PinnedSizeSummary({
    required this.originalSize,
    required this.estimatedSize,
    required this.savingsPercent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Utils.formatSize(originalSize).toLowerCase(),
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 20,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SvgPicture.asset(
                              AppIcons.arrowForward,
                              width: 20,
                              height: 17,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.onSurface,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          RollingCounterText(
                            value: estimatedSize,
                            formatter: (value) =>
                                Utils.formatSize(value.toInt()).toLowerCase(),
                            style: const TextStyle(
                              color: CompressionUiColors.red,
                              fontSize: 20,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: CompressionUiColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    child: RollingCounterText(
                      value: savingsPercent,
                      formatter: (value) => '${value.toInt()}%',
                      style: const TextStyle(
                        color: CompressionUiColors.red,
                        fontSize: 17,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleCompressionOptions extends StatelessWidget {
  final CompressState state;

  const _SimpleCompressionOptions({required this.state});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final selectedQuality = state.settings.simpleQuality;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.quality,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 29,
            height: 1,
          ),
        ),
        const SizedBox(height: 31),
        SimpleQualityCard(
          selected: selectedQuality == SimpleCompressionQuality.high,
          quality: SimpleCompressionQuality.high,
          title: strings.high,
          subtitle: strings.bitrateReducedDescription,
          onSelected: _onSelected(context),
        ),
        const SizedBox(height: 21),
        SimpleQualityCard(
          selected: selectedQuality == SimpleCompressionQuality.medium,
          quality: SimpleCompressionQuality.medium,
          title: strings.medium,
          subtitle: strings.resolutionReducedHdDescription,
          onSelected: _onSelected(context),
        ),
        const SizedBox(height: 21),
        SimpleQualityCard(
          selected: selectedQuality == SimpleCompressionQuality.low,
          quality: SimpleCompressionQuality.low,
          title: strings.low,
          subtitle: strings.resolutionReducedSdDescription,
          onSelected: _onSelected(context),
        ),
      ],
    );
  }

  ValueChanged<SimpleCompressionQuality> _onSelected(BuildContext context) {
    return (quality) =>
        context.read<CompressBloc>().add(CompressSimpleQualityChanged(quality));
  }
}

class _AdvancedCompressionOptions extends StatelessWidget {
  final CompressState state;

  const _AdvancedCompressionOptions({required this.state});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final settings = state.settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSettingsSection(
          title: strings.quality,
          description: strings.qualityDescription,
          child: CrfSlider(
            value: settings.crf,
            onChanged: (value) =>
                context.read<CompressBloc>().add(CompressCrfChanged(value)),
          ),
        ),
        const SizedBox(height: 28),
        AppSettingsSection(
          title: strings.speed,
          description: strings.speedDescription,
          child: AppOptionPicker<String>(
            value: settings.preset,
            options: [
              AppOption(value: 'ultrafast', label: strings.ultraFast),
              AppOption(value: 'fast', label: strings.fast),
              AppOption(value: 'medium', label: strings.medium),
              AppOption(value: 'slow', label: strings.slow),
              AppOption(value: 'veryslow', label: strings.verySlow),
            ],
            onChanged: (value) =>
                context.read<CompressBloc>().add(CompressPresetChanged(value)),
          ),
        ),
        const SizedBox(height: 28),
        AppSettingsSection(
          title: strings.resolution,
          description: strings.resolutionDescription,
          child: AppOptionPicker<String?>(
            value: settings.resolution,
            options: _CompressionSettingsViewState._resolutions
                .map(
                  (resolution) => AppOption(
                    value: resolution,
                    label: CompressionLabels.resolution(resolution, strings),
                  ),
                )
                .toList(),
            onChanged: (value) => context.read<CompressBloc>().add(
              CompressResolutionChanged(value),
            ),
          ),
        ),
        const SizedBox(height: 28),
        AppSettingsSection(
          title: strings.frameRate,
          description: strings.frameRateDescription,
          child: AppOptionPicker<double?>(
            value: settings.frameRate,
            options: [
              AppOption(value: null, label: strings.original),
              const AppOption(value: 24, label: '24 fps'),
              const AppOption(value: 30, label: '30 fps'),
              const AppOption(value: 60, label: '60 fps'),
            ],
            onChanged: (value) =>
                _changeSettings(context, settings.copyWith(frameRate: value)),
          ),
        ),
        const SizedBox(height: 28),
        AppSettingsSection(
          title: strings.videoCodec,
          description: strings.videoCodecDescription,
          child: AppOptionPicker<CompressionVideoCodec>(
            value: settings.videoCodec,
            options: [
              AppOption(
                value: CompressionVideoCodec.h264,
                label: 'H.264',
                description: strings.mostCompatible,
              ),
              AppOption(
                value: CompressionVideoCodec.h265,
                label: 'H.265',
                description: strings.smallerNewerDevices,
              ),
            ],
            onChanged: (value) =>
                _changeSettings(context, settings.copyWith(videoCodec: value)),
          ),
        ),
        const SizedBox(height: 28),
        AppSettingsSection(
          title: strings.audio,
          description: strings.audioDescription,
          child: AppOptionPicker<CompressionAudioMode>(
            value: settings.audioMode,
            options: [
              AppOption(
                value: CompressionAudioMode.stereo,
                label: strings.stereo,
              ),
              AppOption(value: CompressionAudioMode.mono, label: strings.mono),
              AppOption(
                value: CompressionAudioMode.remove,
                label: strings.noAudio,
              ),
            ],
            onChanged: (value) =>
                _changeSettings(context, settings.copyWith(audioMode: value)),
          ),
        ),
        const SizedBox(height: 28),
        AppSettingsSection(
          title: strings.additionalOptions,
          child: Column(
            children: [
              AppSettingToggle(
                title: strings.twoPassEncoding,
                description: strings.twoPassEncodingDescription,
                value: settings.twoPassEncoding,
                onChanged: (value) => _changeSettings(
                  context,
                  settings.copyWith(twoPassEncoding: value),
                ),
              ),
              AppSettingToggle(
                title: strings.noiseReduction,
                description: strings.noiseReductionDescription,
                value: settings.noiseReduction,
                onChanged: (value) => _changeSettings(
                  context,
                  settings.copyWith(noiseReduction: value),
                ),
              ),
              AppSettingToggle(
                title: strings.optimizeForStreaming,
                description: strings.optimizeForStreamingDescription,
                value: settings.optimizeForStreaming,
                onChanged: (value) => _changeSettings(
                  context,
                  settings.copyWith(optimizeForStreaming: value),
                ),
              ),
              AppSettingToggle(
                title: strings.hardwareAcceleration,
                description: strings.hardwareAccelerationDescription,
                value: settings.hardwareAcceleration,
                onChanged: (value) => _changeSettings(
                  context,
                  settings.copyWith(hardwareAcceleration: value),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _changeSettings(BuildContext context, CompressionSettings settings) {
    context.read<CompressBloc>().add(CompressSettingsChanged(settings));
  }
}
