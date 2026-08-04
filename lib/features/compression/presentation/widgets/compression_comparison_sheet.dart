import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/pressable.dart';
import '../../bloc/compress_state.dart';

const _sheetHorizontalPadding = 18.0;

class CompressionComparisonSheet extends StatefulWidget {
  final List<CompressedVideo> results;

  const CompressionComparisonSheet({super.key, required this.results});

  @override
  State<CompressionComparisonSheet> createState() =>
      _CompressionComparisonSheetState();
}

class _CompressionComparisonSheetState
    extends State<CompressionComparisonSheet> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final result = widget.results[_selectedIndex];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _sheetHorizontalPadding,
          10,
          _sheetHorizontalPadding,
          18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.compareVideos,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
                height: 1,
              ),
            ),
            if (widget.results.length > 1) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: OverflowBox(
                  minWidth: MediaQuery.sizeOf(context).width,
                  maxWidth: MediaQuery.sizeOf(context).width,
                  alignment: Alignment.center,
                  child: SizedBox.expand(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _sheetHorizontalPadding,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.results.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final selected = index == _selectedIndex;
                        return ChoiceChip(
                          selected: selected,
                          showCheckmark: false,
                          label: SizedBox(
                            width: 150,
                            child: Text(
                              widget.results[index].source.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: selected
                                ? CompressionUiColors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          selectedColor: CompressionUiColors.red,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          side: BorderSide(
                            color: selected
                                ? CompressionUiColors.red
                                : Theme.of(context).colorScheme.outline,
                          ),
                          onSelected: (_) =>
                              setState(() => _selectedIndex = index),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Flexible(
              child: _ComparisonPlayer(key: ValueKey(result), result: result),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonPlayer extends StatefulWidget {
  final CompressedVideo result;

  const _ComparisonPlayer({super.key, required this.result});

  @override
  State<_ComparisonPlayer> createState() => _ComparisonPlayerState();
}

class _ComparisonPlayerState extends State<_ComparisonPlayer> {
  VideoPlayerController? _originalController;
  VideoPlayerController? _compressedController;
  var _loading = true;
  var _loadId = 0;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _loadId++;
    _originalController?.dispose();
    _compressedController?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final loadId = ++_loadId;
    setState(() {
      _loading = true;
      _error = null;
    });

    final oldOriginalController = _originalController;
    final oldCompressedController = _compressedController;
    _originalController = null;
    _compressedController = null;
    await Future.wait([
      if (oldOriginalController != null) oldOriginalController.dispose(),
      if (oldCompressedController != null) oldCompressedController.dispose(),
    ]);
    if (!mounted || loadId != _loadId) return;

    final compressedPath = widget.result.result.outputPath;
    if (compressedPath == null) {
      setState(() {
        _loading = false;
        _error = StateError('missing video path');
      });
      return;
    }

    final originalController = VideoPlayerController.file(
      File(widget.result.source.path),
    );
    final compressedController = VideoPlayerController.file(
      File(compressedPath),
    );
    try {
      await Future.wait([
        originalController.initialize(),
        compressedController.initialize(),
      ]);
      if (!mounted || loadId != _loadId) {
        await originalController.dispose();
        await compressedController.dispose();
        return;
      }
      await Future.wait([
        originalController.setLooping(true),
        compressedController.setLooping(true),
        originalController.setVolume(0),
        compressedController.setVolume(0),
      ]);
      if (!mounted || loadId != _loadId) {
        await originalController.dispose();
        await compressedController.dispose();
        return;
      }
      setState(() {
        _originalController = originalController;
        _compressedController = compressedController;
        _loading = false;
      });
    } catch (error) {
      await originalController.dispose();
      await compressedController.dispose();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final originalSize =
        widget.result.result.originalSize ?? widget.result.source.size;
    final compressedSize = widget.result.result.outputSize ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Utils.formatSize(originalSize),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              AppIcons.arrowForward,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Utils.formatSize(compressedSize),
              style: const TextStyle(
                color: CompressionUiColors.green,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColoredBox(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _SplitPlayerBody(
                  originalController: _originalController,
                  compressedController: _compressedController,
                  loading: _loading,
                  error: _error,
                  originalLabel: strings.originalVideo,
                  compressedLabel: strings.compressedVideo,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_originalController != null && _compressedController != null)
          _PlayerControls(
            originalController: _originalController!,
            compressedController: _compressedController!,
          )
        else
          Text(
            strings.videoPreviewUnavailable,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}

class _SplitPlayerBody extends StatelessWidget {
  final VideoPlayerController? originalController;
  final VideoPlayerController? compressedController;
  final bool loading;
  final Object? error;
  final String originalLabel;
  final String compressedLabel;

  const _SplitPlayerBody({
    required this.originalController,
    required this.compressedController,
    required this.loading,
    required this.error,
    required this.originalLabel,
    required this.compressedLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: CompressionUiColors.white),
      );
    }
    if (error != null ||
        originalController == null ||
        compressedController == null) {
      return Center(
        child: Icon(
          Icons.videocam_off,
          color: CompressionUiColors.white.withValues(alpha: 0.78),
          size: 42,
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Row(
          children: [
            Expanded(
              child: _FittedVideo(
                controller: originalController!,
                alignment: Alignment.centerRight,
              ),
            ),
            Expanded(
              child: _FittedVideo(
                controller: compressedController!,
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
        Center(child: Container(width: 2, color: CompressionUiColors.white)),
        Positioned(left: 10, top: 10, child: _VideoLabel(text: originalLabel)),
        Positioned(
          right: 10,
          top: 10,
          child: _VideoLabel(text: compressedLabel),
        ),
      ],
    );
  }
}

class _VideoLabel extends StatelessWidget {
  final String text;

  const _VideoLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
            color: CompressionUiColors.white,
            fontSize: 13,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _FittedVideo extends StatelessWidget {
  final VideoPlayerController controller;
  final Alignment alignment;

  const _FittedVideo({required this.controller, required this.alignment});

  @override
  Widget build(BuildContext context) {
    final size = controller.value.size;

    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        alignment: alignment,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

class _PlayerControls extends StatefulWidget {
  final VideoPlayerController originalController;
  final VideoPlayerController compressedController;

  const _PlayerControls({
    required this.originalController,
    required this.compressedController,
  });

  @override
  State<_PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<_PlayerControls> {
  var _wasPlayingBeforeScrub = false;

  VideoPlayerController get originalController => widget.originalController;

  VideoPlayerController get compressedController => widget.compressedController;

  Future<void> _togglePlay(VideoPlayerValue value) async {
    if (value.isPlaying) {
      await Future.wait([
        originalController.pause(),
        compressedController.pause(),
      ]);
      return;
    }

    await originalController.seekTo(value.position);
    await Future.wait([originalController.play(), compressedController.play()]);
  }

  Future<void> _seek(Duration position) async {
    await Future.wait([
      originalController.seekTo(position),
      compressedController.seekTo(position),
    ]);
  }

  Future<void> _startScrub() async {
    _wasPlayingBeforeScrub = compressedController.value.isPlaying;
    if (_wasPlayingBeforeScrub) return;
    await Future.wait([originalController.play(), compressedController.play()]);
  }

  Future<void> _endScrub() async {
    if (_wasPlayingBeforeScrub) return;
    await Future.wait([
      originalController.pause(),
      compressedController.pause(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: compressedController,
      builder: (context, value, _) {
        final durationMs = value.duration.inMilliseconds;
        final positionMs = value.position.inMilliseconds.clamp(0, durationMs);

        return Row(
          children: [
            _PlayButton(
              isPlaying: value.isPlaying,
              onPressed: () => _togglePlay(value),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProgressBar(
                positionMs: positionMs,
                durationMs: durationMs,
                onSeek: (position) => _seek(Duration(milliseconds: position)),
                onScrubStart: _startScrub,
                onScrubEnd: _endScrub,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _PlayButton({required this.isPlaying, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Pressable(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 38,
          child: Center(
            child: SvgPicture.asset(
              isPlaying ? AppIcons.pause : AppIcons.play,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(theme.accentColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int positionMs;
  final int durationMs;
  final ValueChanged<int> onSeek;
  final VoidCallback onScrubStart;
  final VoidCallback onScrubEnd;

  const _ProgressBar({
    required this.positionMs,
    required this.durationMs,
    required this.onSeek,
    required this.onScrubStart,
    required this.onScrubEnd,
  });

  void _seekFromLocal(Offset localPosition, double width) {
    if (durationMs <= 0 || width <= 0) return;
    final progress = (localPosition.dx / width).clamp(0.0, 1.0);
    onSeek((durationMs * progress).round());
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final progress = durationMs <= 0
        ? 0.0
        : (positionMs / durationMs).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbLeft = width <= 10
            ? 0.0
            : (width * progress - 5).clamp(0.0, width - 10);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => _seekFromLocal(details.localPosition, width),
          onHorizontalDragStart: (_) => onScrubStart(),
          onHorizontalDragUpdate: (details) =>
              _seekFromLocal(details.localPosition, width),
          onHorizontalDragEnd: (_) => onScrubEnd(),
          onHorizontalDragCancel: onScrubEnd,
          child: SizedBox(
            height: 28,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.frameBorderColor.withValues(alpha: 0.32),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.accentColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                Positioned(
                  left: thumbLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 10),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
