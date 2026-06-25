import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_option_picker.dart';
import '../../../../widgets/app_setting_toggle.dart';
import '../../../../widgets/app_settings_section.dart';
import '../../../../widgets/crf_slider.dart';
import '../../../../widgets/faded_scroll_view.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Column(
      children: [
        Expanded(
          child: FadedScrollView(
            fadeExtent: 0.08,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                SelectedVideosSummary(
                  selectedCount: state.videos.length,
                  thumbnailPaths: state.thumbnailPaths,
                  originalSize: state.totalOriginalSize,
                  estimatedSize: CompressionEstimate.compressedSize(
                    originalSize: state.totalOriginalSize,
                    settings: state.settings,
                  ),
                  savingsPercent: CompressionEstimate.savingsPercent(
                    originalSize: state.totalOriginalSize,
                    settings: state.settings,
                  ),
                ),
                const SizedBox(height: 22),
                CompressionModeSwitch(
                  value: _mode,
                  onChanged: (value) => setState(() => _mode = value),
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
        const SizedBox(height: 12),
        CompressionBottomActions(
          onBack: widget.onBack,
          onCompress: () =>
              context.read<CompressBloc>().add(const CompressStarted()),
        ),
      ],
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
          style: const TextStyle(
            color: CompressionUiColors.dark,
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
