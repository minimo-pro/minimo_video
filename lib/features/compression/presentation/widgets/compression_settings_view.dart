import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_option_picker.dart';
import '../../../../widgets/app_settings_section.dart';
import '../../../../widgets/faded_scroll_view.dart';
import '../../../../widgets/minimo_loader.dart';
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
  final VoidCallback? onAddVideos;
  final bool isImporting;
  final (int, int)? importProgress;

  const CompressionSettingsView({
    super.key,
    required this.state,
    required this.onAddVideos,
    this.isImporting = false,
    this.importProgress,
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
  static const _bitrates = <int?>[null, 1, 2, 4, 6, 8];
  static const _frameRates = <int?>[null, 60, 30, 24, 15];

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
    final initialImport = widget.isImporting && state.videos.isEmpty;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 640;
              final summaryMinHeight = compact ? 185.0 : 200.0;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: _onScroll,
                    child: FadedScrollView(
                      fadeExtent: 0.08,
                      padding: EdgeInsets.symmetric(vertical: compact ? 4 : 6),
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: summaryMinHeight,
                            ),
                            child: initialImport
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        MinimoLoader(
                                          size: 42,
                                          semanticsLabel: S
                                              .of(context)
                                              .loadingVideos,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          S.of(context).loadingManyVideosHint,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SelectedVideosSummary(
                                    sizeRowKey: _sizeRowKey,
                                    selectedCount: state.videos.length,
                                    thumbnailPaths: state.thumbnailPaths,
                                    originalSize: state.totalOriginalSize,
                                    estimatedSize: estimatedSize,
                                    savingsPercent: savingsPercent,
                                    compact: compact,
                                  ),
                          ),
                          SizedBox(height: compact ? 14 : 22),
                          CompressionModeSwitch(
                            value: _mode,
                            onChanged: (value) => setState(() => _mode = value),
                          ),
                          SizedBox(height: compact ? 14 : 24),
                          SpringTabContent(
                            value: _mode,
                            child: _mode == CompressionOptionsMode.simple
                                ? _SimpleCompressionOptions(
                                    state: state,
                                    compact: compact,
                                  )
                                : _AdvancedCompressionOptions(
                                    state: state,
                                    compact: compact,
                                  ),
                          ),
                          if (_mode == CompressionOptionsMode.advanced)
                            const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                  if (!initialImport)
                    Positioned(
                      top: -55,
                      left: 55,
                      right: 8,
                      height: 47,
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
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        CompressionBottomActions(
          onAdd: widget.onAddVideos,
          isImporting: widget.isImporting,
          importProgress: widget.importProgress,
          onCompress: widget.isImporting || savingsPercent == 0
              ? null
              : () => context.read<CompressBloc>().add(const CompressStarted()),
        ),
      ],
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
    final strings = S.of(context);

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
            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: savingsPercent == 0
                        ? Text(
                            strings.noSavingsHint,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: CompressionUiColors.red,
                              fontSize: 13,
                              height: 1.15,
                            ),
                          )
                        : RollingCounterText(
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
  final bool compact;

  const _SimpleCompressionOptions({required this.state, required this.compact});

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
            fontSize: compact ? 24 : 29,
            height: 1,
          ),
        ),
        SizedBox(height: compact ? 17 : 31),
        SimpleQualityCard(
          selected: selectedQuality == SimpleCompressionQuality.high,
          quality: SimpleCompressionQuality.high,
          title: strings.high,
          subtitle: strings.bitrateReducedDescription,
          onSelected: _onSelected(context),
          compact: compact,
        ),
        SizedBox(height: compact ? 12 : 21),
        SimpleQualityCard(
          selected: selectedQuality == SimpleCompressionQuality.medium,
          quality: SimpleCompressionQuality.medium,
          title: strings.medium,
          subtitle: strings.resolutionReducedHdDescription,
          onSelected: _onSelected(context),
          compact: compact,
        ),
        SizedBox(height: compact ? 12 : 21),
        SimpleQualityCard(
          selected: selectedQuality == SimpleCompressionQuality.low,
          quality: SimpleCompressionQuality.low,
          title: strings.low,
          subtitle: strings.resolutionReducedSdDescription,
          onSelected: _onSelected(context),
          compact: compact,
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
  final bool compact;

  const _AdvancedCompressionOptions({
    required this.state,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final settings = state.settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(height: compact ? 18 : 28),
        AppSettingsSection(
          title: strings.videoBitrate,
          description: strings.videoBitrateDescription,
          child: AppOptionPicker<int?>(
            value: settings.videoBitrateMbps,
            options: _CompressionSettingsViewState._bitrates
                .map(
                  (bitrate) => AppOption(
                    value: bitrate,
                    label: bitrate == null
                        ? strings.automatic
                        : '$bitrate Mbps',
                  ),
                )
                .toList(),
            onChanged: (value) => _changeSettings(
              context,
              settings.copyWith(videoBitrateMbps: value),
            ),
          ),
        ),
        SizedBox(height: compact ? 18 : 28),
        AppSettingsSection(
          title: strings.frameRate,
          description: strings.frameRateDescription,
          child: AppOptionPicker<int?>(
            value: settings.frameRate,
            options: _CompressionSettingsViewState._frameRates
                .map(
                  (fps) => AppOption(
                    value: fps,
                    label: fps == null ? strings.original : '$fps FPS',
                  ),
                )
                .toList(),
            onChanged: (value) =>
                _changeSettings(context, settings.copyWith(frameRate: value)),
          ),
        ),
        SizedBox(height: compact ? 18 : 28),
        AppSettingsSection(
          title: strings.codec,
          description: strings.codecDescription,
          child: AppOptionPicker<CompressionCodec>(
            value: settings.codec,
            options: const [
              AppOption(value: CompressionCodec.h264, label: 'H.264'),
              AppOption(value: CompressionCodec.hevc, label: 'HEVC'),
            ],
            onChanged: (value) =>
                _changeSettings(context, settings.copyWith(codec: value)),
          ),
        ),
        SizedBox(height: compact ? 18 : 28),
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
              AppOption(
                value: CompressionAudioMode.remove,
                label: strings.noAudio,
              ),
            ],
            onChanged: (value) =>
                _changeSettings(context, settings.copyWith(audioMode: value)),
          ),
        ),
      ],
    );
  }

  void _changeSettings(BuildContext context, CompressionSettings settings) {
    context.read<CompressBloc>().add(CompressSettingsChanged(settings));
  }
}
