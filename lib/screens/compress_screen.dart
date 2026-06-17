import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/compress_bloc.dart';
import '../bloc/compress_event.dart';
import '../bloc/compress_state.dart';
import '../router/app_router.gr.dart';
import '../services/file_service.dart';
import '../services/utils.dart';
import '../widgets/crf_slider.dart';
import '../widgets/size_row.dart';

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
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _CompressView extends StatelessWidget {
  const _CompressView();

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
        final message = state.saveMessage ?? state.errorMessage;
        if (message == null) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        context.read<CompressBloc>().add(const CompressMessagesCleared());
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('minimo (video)'),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.showSettings)
                    ..._buildSettingsUI(context, theme, state),
                  if (state.status == CompressStatus.processing)
                    ..._buildProgressUI(theme, state),
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
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 44,
                  color: Colors.green.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                state.selectionTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                Utils.formatSize(state.totalOriginalSize),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (state.videos.length > 1) ...[
                const SizedBox(height: 12),
                _buildVideoList(theme, state.videos),
              ],
              const SizedBox(height: 24),
              _sectionHeader('Quality', theme),
              const SizedBox(height: 8),
              CrfSlider(
                value: state.settings.crf,
                onChanged: (value) =>
                    context.read<CompressBloc>().add(CompressCrfChanged(value)),
              ),
              const SizedBox(height: 20),
              _sectionHeader('Speed', theme),
              const SizedBox(height: 8),
              _buildChipRow(
                _presets,
                state.settings.preset,
                (value) => context.read<CompressBloc>().add(
                  CompressPresetChanged(value),
                ),
              ),
              const SizedBox(height: 20),
              _sectionHeader('Resolution', theme),
              const SizedBox(height: 8),
              _buildResolutionChips(context, state),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () =>
                    context.read<CompressBloc>().add(const CompressStarted()),
                icon: const Icon(Icons.compress_rounded),
                label: Text(
                  'Compress ${state.videos.length} Video${state.videos.length == 1 ? '' : 's'}',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(240, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => _goToStart(context),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Choose other videos'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVideoList(ThemeData theme, List<PickedVideo> videos) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 140),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: videos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final video = videos[index];
          return Row(
            children: [
              const Icon(Icons.movie_rounded, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  video.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                Utils.formatSize(video.size),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChipRow(
    List<String> items,
    String selected,
    ValueChanged<String> onChanged,
  ) {
    return Row(
      children: items.map((item) {
        final isSelected = selected == item;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(_presetLabel(item)),
            selected: isSelected,
            onSelected: (_) => onChanged(item),
          ),
        );
      }).toList(),
    );
  }

  String _presetLabel(String p) {
    switch (p) {
      case 'ultrafast':
        return 'Ultra Fast';
      case 'fast':
        return 'Fast';
      case 'medium':
        return 'Medium';
      case 'slow':
        return 'Slow';
      default:
        return p;
    }
  }

  Widget _buildResolutionChips(BuildContext context, CompressState state) {
    return Row(
      children: _resolutions.map((resolution) {
        final isSelected = state.settings.resolution == resolution;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(_resolutionLabel(resolution)),
            selected: isSelected,
            onSelected: (_) => context.read<CompressBloc>().add(
              CompressResolutionChanged(resolution),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _resolutionLabel(String? resolution) {
    if (resolution == null) return 'Original';
    switch (resolution) {
      case '1920:1080':
        return '1080p';
      case '1280:720':
        return '720p';
      case '854:480':
        return '480p';
      default:
        return resolution;
    }
  }

  List<Widget> _buildProgressUI(ThemeData theme, CompressState state) {
    return [
      const SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(strokeWidth: 8),
      ),
      const SizedBox(height: 32),
      Text(
        'Compressing...',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Video ${state.processingIndex + 1} of ${state.videos.length}',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ];
  }

  List<Widget> _buildResultUI(
    BuildContext context,
    ThemeData theme,
    CompressState state,
  ) {
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
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 44,
                  color: Colors.green.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                successResults.length == state.results.length
                    ? 'Compression Complete!'
                    : '${successResults.length} of ${state.results.length} Videos Compressed',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                Utils.formatSize(compressedSize),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              if (state.results.isNotEmpty) ...[
                SizeRow(
                  label: 'Original',
                  size: originalSize,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                SizeRow(
                  label: 'Compressed',
                  size: compressedSize,
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_down,
                        color: Colors.green.shade600,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '-$savings%',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Settings: ${state.settings.qualityLabel.toLowerCase()} quality, ${state.settings.presetLabel.toLowerCase()}, ${state.settings.resolutionLabel.toLowerCase()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (state.results.length > 1) ...[
                const SizedBox(height: 16),
                _buildResultList(theme, state.results),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: successResults.isEmpty
                    ? null
                    : () => context.read<CompressBloc>().add(
                        const CompressResultsSaved(),
                      ),
                icon: const Icon(Icons.save_alt_rounded),
                label: Text(
                  'Save ${successResults.length} Video${successResults.length == 1 ? '' : 's'}',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(240, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => _goToStart(context),
                icon: const Icon(Icons.compress_rounded),
                label: const Text('Compress other videos'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildResultList(ThemeData theme, List<CompressedVideo> results) {
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
                    ? Colors.green
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
                    ? 'Failed'
                    : Utils.formatSize(compressedSize),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
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
