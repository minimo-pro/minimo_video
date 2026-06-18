import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../router/app_router.gr.dart';
import '../../../services/utils.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/crf_slider.dart';
import '../../../widgets/minimo_loader.dart';
import '../../../widgets/size_row.dart';
import '../bloc/compress_bloc.dart';
import '../bloc/compress_event.dart';
import '../bloc/compress_state.dart';
import '../domain/compression_settings.dart';
import '../domain/picked_video.dart';
import 'utils/compression_labels.dart';
import 'widgets/compression_bottom_actions.dart';
import 'widgets/compression_mode_switch.dart';
import 'widgets/selected_videos_summary.dart';
import 'widgets/simple_quality_card.dart';

@RoutePage()
class CompressScreen extends StatelessWidget {
  final List<PickedVideo> initialVideos;

  const CompressScreen({super.key, this.initialVideos = const []});

  @override
  Widget build(BuildContext context) {
    if (initialVideos.isEmpty) {
      return const _StartRedirect();
    }

    return BlocProvider(
      create: (_) => CompressBloc(initialVideos: initialVideos),
      child: const _CompressView(),
    );
  }
}

class _StartRedirect extends StatefulWidget {
  const _StartRedirect();

  @override
  State<_StartRedirect> createState() => _StartRedirectState();
}

class _StartRedirectState extends State<_StartRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.router.replaceAll([const StartRoute()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MinimoLoader(semanticsLabel: S.of(context).loadingVideos),
      ),
    );
  }
}

class _CompressView extends StatefulWidget {
  const _CompressView();

  @override
  State<_CompressView> createState() => _CompressViewState();
}

class _CompressViewState extends State<_CompressView> {
  CompressionOptionsMode _mode = CompressionOptionsMode.simple;

  static const _presets = ['ultrafast', 'fast', 'medium', 'slow'];
  static const _resolutions = <String?>[
    null,
    '1920:1080',
    '1280:720',
    '854:480',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<CompressBloc, CompressState>(
      listener: (context, state) {
        final strings = S.of(context);
        final message = state.savedVideoCount != null
            ? strings.savedVideosToGallery(state.savedVideoCount!)
            : state.saveError != null
            ? strings.failedToSave(state.saveError.toString())
            : null;
        if (message == null) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        context.read<CompressBloc>().add(const CompressMessagesCleared());
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CompressionUiColors.page,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
              child: Column(
                children: [
                  if (state.showSettings)
                    ..._buildSettingsUI(context, theme, state),
                  if (state.status == CompressStatus.processing)
                    ..._buildProgressUI(context, state),
                  if (state.status == CompressStatus.done)
                    ..._buildResultUI(context, theme, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSettingsUI(
    BuildContext context,
    ThemeData theme,
    CompressState state,
  ) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectedVideosSummary(
                selectedCount: state.videos.length,
                thumbnailPaths: state.thumbnailPaths,
                originalSize: state.totalOriginalSize,
                estimatedSize: _estimatedCompressedSize(state),
                savingsPercent: _estimatedSavingsPercent(state),
              ),
              const SizedBox(height: 22),
              CompressionModeSwitch(
                value: _mode,
                onChanged: (value) => setState(() => _mode = value),
              ),
              const SizedBox(height: 24),
              if (_mode == CompressionOptionsMode.simple)
                _buildSimpleOptions(context, state)
              else
                _buildAdvancedOptions(context, theme, state),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      CompressionBottomActions(
        onBack: () => _goToStart(context),
        onCompress: () =>
            context.read<CompressBloc>().add(const CompressStarted()),
      ),
    ];
  }

  Widget _buildSimpleOptions(BuildContext context, CompressState state) {
    final strings = S.of(context);

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
          selected:
              state.settings.simpleQuality == SimpleCompressionQuality.high,
          quality: SimpleCompressionQuality.high,
          title: strings.high,
          subtitle: strings.bitrateReducedDescription,
          onSelected: _selectSimpleQuality(context),
        ),
        const SizedBox(height: 21),
        SimpleQualityCard(
          selected:
              state.settings.simpleQuality == SimpleCompressionQuality.medium,
          quality: SimpleCompressionQuality.medium,
          title: strings.medium,
          subtitle: strings.resolutionReducedHdDescription,
          onSelected: _selectSimpleQuality(context),
        ),
        const SizedBox(height: 21),
        SimpleQualityCard(
          selected:
              state.settings.simpleQuality == SimpleCompressionQuality.low,
          quality: SimpleCompressionQuality.low,
          title: strings.low,
          subtitle: strings.resolutionReducedSdDescription,
          onSelected: _selectSimpleQuality(context),
        ),
      ],
    );
  }

  ValueChanged<SimpleCompressionQuality> _selectSimpleQuality(
    BuildContext context,
  ) {
    return (quality) =>
        context.read<CompressBloc>().add(CompressSimpleQualityChanged(quality));
  }

  Widget _buildAdvancedOptions(
    BuildContext context,
    ThemeData theme,
    CompressState state,
  ) {
    final strings = S.of(context);

    return Column(
      children: [
        _sectionHeader(strings.quality, theme),
        const SizedBox(height: 8),
        CrfSlider(
          value: state.settings.crf,
          onChanged: (value) =>
              context.read<CompressBloc>().add(CompressCrfChanged(value)),
        ),
        const SizedBox(height: 20),
        _sectionHeader(strings.speed, theme),
        const SizedBox(height: 8),
        _buildChipRow(
          _presets,
          state.settings.preset,
          strings,
          (value) =>
              context.read<CompressBloc>().add(CompressPresetChanged(value)),
        ),
        const SizedBox(height: 20),
        _sectionHeader(strings.resolution, theme),
        const SizedBox(height: 8),
        _buildResolutionChips(context, state),
      ],
    );
  }

  int _estimatedCompressedSize(CompressState state) {
    final ratio = switch (state.settings.simpleQuality) {
      SimpleCompressionQuality.high => 0.8,
      SimpleCompressionQuality.medium => 0.55,
      SimpleCompressionQuality.low => 0.35,
    };
    return (state.totalOriginalSize * ratio).round();
  }

  int _estimatedSavingsPercent(CompressState state) {
    if (state.totalOriginalSize == 0) return 0;
    final estimated = _estimatedCompressedSize(state);
    return ((1 - estimated / state.totalOriginalSize) * 100)
        .clamp(0, 99)
        .round();
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: CompressionUiColors.dark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChipRow(
    List<String> items,
    String selected,
    S strings,
    ValueChanged<String> onChanged,
  ) {
    return Row(
      children: items.map((item) {
        final isSelected = selected == item;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(CompressionLabels.preset(item, strings)),
            selected: isSelected,
            onSelected: (_) => onChanged(item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResolutionChips(BuildContext context, CompressState state) {
    final strings = S.of(context);

    return Row(
      children: _resolutions.map((resolution) {
        final isSelected = state.settings.resolution == resolution;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(CompressionLabels.resolution(resolution, strings)),
            selected: isSelected,
            onSelected: (_) => context.read<CompressBloc>().add(
              CompressResolutionChanged(resolution),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildProgressUI(BuildContext context, CompressState state) {
    final strings = S.of(context);

    return [
      Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MinimoLoader(size: 72, semanticsLabel: strings.compressing),
              const SizedBox(height: 32),
              Text(
                strings.compressing,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CompressionUiColors.dark,
                  fontSize: 29,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                strings.videoProgress(
                  state.processingIndex + 1,
                  state.videos.length,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CompressionUiColors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildResultUI(
    BuildContext context,
    ThemeData theme,
    CompressState state,
  ) {
    final strings = S.of(context);
    final successResults = state.successResults;
    final originalSize = state.resultsOriginalSize;
    final compressedSize = state.compressedSize;
    final savings = originalSize > 0 && compressedSize > 0
        ? Utils.savingsPercent(originalSize, compressedSize)
        : '0';

    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.check_circle,
                size: 76,
                color: CompressionUiColors.red,
              ),
              const SizedBox(height: 24),
              Text(
                successResults.length == state.results.length
                    ? strings.compressionComplete
                    : strings.videosCompressed(
                        successResults.length,
                        state.results.length,
                      ),
                style: const TextStyle(
                  color: CompressionUiColors.dark,
                  fontSize: 29,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                Utils.formatSize(compressedSize).toLowerCase(),
                style: const TextStyle(
                  color: CompressionUiColors.red,
                  fontSize: 34,
                  height: 1,
                ),
              ),
              const SizedBox(height: 24),
              if (state.results.isNotEmpty) ...[
                SizeRow(
                  label: strings.original,
                  size: originalSize,
                  color: Colors.grey,
                  isOriginal: true,
                ),
                const SizedBox(height: 8),
                SizeRow(
                  label: strings.compressed,
                  size: compressedSize,
                  color: Colors.red,
                  isOriginal: false,
                ),
                const SizedBox(height: 8),
                Text(
                  '-$savings%',
                  style: const TextStyle(
                    color: CompressionUiColors.red,
                    fontSize: 24,
                  ),
                ),
              ],
              if (state.results.length > 1) ...[
                const SizedBox(height: 16),
                _buildResultList(theme, state.results, strings),
              ],
            ],
          ),
        ),
      ),
      FilledButton(
        onPressed: successResults.isEmpty
            ? null
            : () => context.read<CompressBloc>().add(
                const CompressResultsSaved(),
              ),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(47),
          backgroundColor: CompressionUiColors.red,
          foregroundColor: CompressionUiColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          strings.saveVideos(successResults.length),
          style: const TextStyle(fontSize: 25, height: 1),
        ),
      ),
      const SizedBox(height: 12),
      TextButton(
        onPressed: () => _goToStart(context),
        child: Text(strings.compressOtherVideos),
      ),
    ];
  }

  Widget _buildResultList(
    ThemeData theme,
    List<CompressedVideo> results,
    S strings,
  ) {
    return Column(
      children: results.map((item) {
        final compressedSize = item.result.outputSize;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                item.result.success
                    ? Icons.check_circle_rounded
                    : Icons.error_rounded,
                size: 18,
                color: item.result.success
                    ? CompressionUiColors.red
                    : theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.source.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                compressedSize == null
                    ? strings.failed
                    : Utils.formatSize(compressedSize),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: CompressionUiColors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _goToStart(BuildContext context) {
    context.router.replaceAll([const StartRoute()]);
  }
}
