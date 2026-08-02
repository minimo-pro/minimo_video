import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/video_compressor_adapter.dart';
import '../data/video_file_adapter.dart';
import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';
import '../domain/picked_video.dart';
import '../../../services/app_settings_service.dart';
import '../../../services/screen_awake_service.dart';
import 'compress_event.dart';
import 'compress_state.dart';

class CompressBloc extends Bloc<CompressEvent, CompressState> {
  final VideoFileAdapter _videoFileAdapter;
  final VideoCompressorAdapter _videoCompressorAdapter;
  final AppSettingsService _appSettings;
  final ScreenAwakeService _screenAwakeService;
  bool _cancelRequested = false;
  bool _resumeAfterBackground = false;
  bool _screenAwakeEnabled = false;
  int _compressionRunId = 0;
  int _estimateRunId = 0;
  Timer? _estimateDebounce;

  CompressBloc({
    List<PickedVideo> initialVideos = const [],
    VideoFileAdapter? videoFileAdapter,
    VideoCompressorAdapter? videoCompressorAdapter,
    AppSettingsService? appSettings,
    ScreenAwakeService? screenAwakeService,
  }) : _videoFileAdapter = videoFileAdapter ?? VideoFileAdapter(),
       _videoCompressorAdapter =
           videoCompressorAdapter ?? VideoCompressorAdapter(),
       _appSettings = appSettings ?? AppSettingsService.instance,
       _screenAwakeService = screenAwakeService ?? ScreenAwakeService.instance,
       super(CompressState.initial(initialVideos)) {
    on<CompressThumbnailsRequested>(_onThumbnailsRequested);
    on<CompressEstimateRequested>(_onEstimateRequested);
    on<CompressVideosAdded>(_onVideosAdded);
    on<CompressSimpleQualityChanged>(_onSimpleQualityChanged);
    on<CompressResolutionChanged>(_onResolutionChanged);
    on<CompressSettingsChanged>(_onSettingsChanged);
    on<CompressStarted>(_onStarted);
    on<CompressProgressChanged>(_onProgressChanged);
    on<CompressCancelled>(_onCancelled);
    on<CompressBackgrounded>(_onBackgrounded);
    on<CompressForegroundResumed>(_onForegroundResumed);
    on<CompressResultsSaved>(_onResultsSaved);
    on<CompressMessagesCleared>(_onMessagesCleared);
    add(const CompressThumbnailsRequested());
    add(const CompressEstimateRequested());
  }

  void _requestEstimate() {
    _estimateRunId++;
    _estimateDebounce?.cancel();
    _estimateDebounce = Timer(
      const Duration(milliseconds: 100),
      () => add(const CompressEstimateRequested()),
    );
  }

  Future<void> _onEstimateRequested(
    CompressEstimateRequested event,
    Emitter<CompressState> emit,
  ) async {
    if (state.status != CompressStatus.ready) return;
    final runId = ++_estimateRunId;
    final settings = state.settings;
    final estimate = await _videoCompressorAdapter.estimateCompressedSize(
      state.videos.map((video) => video.path),
      settings,
    );
    if (runId != _estimateRunId) return;
    emit(state.copyWith(estimatedSize: estimate, clearEstimatedSize: true));
  }

  Future<void> _onThumbnailsRequested(
    CompressThumbnailsRequested event,
    Emitter<CompressState> emit,
  ) async {
    final count = state.videos.length < 3 ? state.videos.length : 3;

    for (var i = 0; i < count; i++) {
      if (state.status != CompressStatus.ready) return;
      if (i < state.thumbnailPaths.length && state.thumbnailPaths[i] != null) {
        continue;
      }
      final path = await _videoCompressorAdapter.createThumbnail(
        state.videos[i].path,
      );
      if (state.status != CompressStatus.ready ||
          i >= state.thumbnailPaths.length) {
        return;
      }
      final thumbnails = List<String?>.of(state.thumbnailPaths);
      thumbnails[i] = path;
      emit(state.copyWith(thumbnailPaths: thumbnails));
    }
  }

  void _onVideosAdded(CompressVideosAdded event, Emitter<CompressState> emit) {
    if (state.status != CompressStatus.ready || event.videos.isEmpty) return;

    final identities = state.videos.map(_videoIdentity).toSet();
    final addedVideos = <PickedVideo>[];
    for (final video in event.videos) {
      if (identities.add(_videoIdentity(video))) {
        addedVideos.add(video);
      }
    }
    if (addedVideos.isEmpty) return;

    emit(
      state.copyWith(
        videos: [...state.videos, ...addedVideos],
        thumbnailPaths: [
          ...state.thumbnailPaths,
          ...List<String?>.filled(addedVideos.length, null),
        ],
        videoStatuses: [
          ...state.videoStatuses,
          ...List<VideoCompressionStatus>.filled(
            addedVideos.length,
            VideoCompressionStatus.waiting,
          ),
        ],
        clearEstimatedSize: true,
      ),
    );
    add(const CompressThumbnailsRequested());
    _requestEstimate();
  }

  String _videoIdentity(PickedVideo video) {
    final sourceIdentifier = video.sourceIdentifier;
    if (sourceIdentifier != null && sourceIdentifier.isNotEmpty) {
      return 'source:$sourceIdentifier';
    }
    return 'file:${video.name}\u0000${video.size}';
  }

  void _onSimpleQualityChanged(
    CompressSimpleQualityChanged event,
    Emitter<CompressState> emit,
  ) {
    switch (event.quality) {
      case SimpleCompressionQuality.high:
        emit(
          state.copyWith(
            settings: const CompressionSettings(crf: 22, resolution: null),
            clearEstimatedSize: true,
          ),
        );
      case SimpleCompressionQuality.medium:
        emit(
          state.copyWith(
            settings: const CompressionSettings(
              crf: 28,
              resolution: '1280:720',
            ),
            clearEstimatedSize: true,
          ),
        );
      case SimpleCompressionQuality.low:
        emit(
          state.copyWith(
            settings: const CompressionSettings(crf: 34, resolution: '854:480'),
            clearEstimatedSize: true,
          ),
        );
    }
    _requestEstimate();
  }

  void _onResolutionChanged(
    CompressResolutionChanged event,
    Emitter<CompressState> emit,
  ) {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(resolution: event.resolution),
        clearEstimatedSize: true,
      ),
    );
    _requestEstimate();
  }

  void _onSettingsChanged(
    CompressSettingsChanged event,
    Emitter<CompressState> emit,
  ) {
    emit(state.copyWith(settings: event.settings, clearEstimatedSize: true));
    _requestEstimate();
  }

  @override
  Future<void> close() async {
    _estimateDebounce?.cancel();
    await _setScreenAwake(false);
    return super.close();
  }

  Future<void> _onStarted(CompressStarted event, Emitter<CompressState> emit) =>
      _runCompression(emit);

  Future<void> _runCompression(
    Emitter<CompressState> emit, {
    int startIndex = 0,
  }) async {
    if (state.videos.isEmpty) return;

    _estimateDebounce?.cancel();
    _estimateRunId++;
    _cancelRequested = false;
    _resumeAfterBackground = false;
    final runId = ++_compressionRunId;
    final previousElapsed = startIndex == 0 ? Duration.zero : state.elapsed;
    final stopwatch = Stopwatch()..start();
    Duration elapsed() => previousElapsed + stopwatch.elapsed;
    final videos = List<PickedVideo>.of(state.videos);
    final totalWeight = videos.fold<int>(
      0,
      (sum, video) => sum + (video.size > 0 ? video.size : 1),
    );
    var completedWeight = videos
        .take(startIndex)
        .fold<int>(0, (sum, video) => sum + (video.size > 0 ? video.size : 1));
    var videoStatuses =
        startIndex == 0
              ? List<VideoCompressionStatus>.filled(
                  videos.length,
                  VideoCompressionStatus.waiting,
                )
              : List<VideoCompressionStatus>.of(state.videoStatuses)
          ..[startIndex] = VideoCompressionStatus.waiting;
    final previousResults = startIndex == 0
        ? const <CompressedVideo>[]
        : state.results;
    emit(
      state.copyWith(
        status: CompressStatus.processing,
        results: previousResults,
        videoStatuses: videoStatuses,
        compressionRunId: runId,
        processingIndex: startIndex,
        progress: completedWeight / totalWeight,
        currentVideoProgress: 0,
        elapsed: previousElapsed,
        clearSaveNotification: true,
        clearCompressionError: true,
      ),
    );

    await _setScreenAwake(_appSettings.preventScreenSleep);
    try {
      for (var i = startIndex; i < videos.length; i++) {
        emit(
          state.copyWith(
            processingIndex: i,
            progress: completedWeight / totalWeight,
            currentVideoProgress: 0,
            elapsed: elapsed(),
            videoStatuses: videoStatuses = _videoStatusesWith(
              videoStatuses,
              i,
              VideoCompressionStatus.processing,
            ),
          ),
        );

        final video = videos[i];
        final weightBeforeVideo = completedWeight;
        late final CompressionResult result;
        var videoStatus = VideoCompressionStatus.compressed;
        try {
          result = await _videoCompressorAdapter.compress(
            video.path,
            video.name,
            state.settings,
            addKompressoPrefix: _appSettings.addKompressoPrefix,
            onProgress: (videoProgress) {
              if (_cancelRequested || runId != _compressionRunId) return;
              final videoWeight = video.size > 0 ? video.size : 1;
              final overallProgress =
                  (weightBeforeVideo + videoWeight * videoProgress) /
                  totalWeight;
              add(
                CompressProgressChanged(
                  runId: runId,
                  progress: overallProgress.clamp(0, 1).toDouble(),
                  currentVideoProgress: videoProgress.clamp(0, 1).toDouble(),
                  elapsed: elapsed(),
                ),
              );
            },
          );
        } catch (error) {
          if (_cancelRequested || runId != _compressionRunId) return;
          result = const CompressionResult(success: false);
          videoStatus = VideoCompressionStatus.failed;
          emit(state.copyWith(compressionError: error));
        }

        if (_cancelRequested || runId != _compressionRunId) return;
        if (videoStatus == VideoCompressionStatus.compressed &&
            !result.success) {
          videoStatus = VideoCompressionStatus.skipped;
        }
        completedWeight += video.size > 0 ? video.size : 1;

        emit(
          state.copyWith(
            results: [
              ...state.results,
              CompressedVideo(source: video, result: result),
            ],
            videoStatuses: videoStatuses = _videoStatusesWith(
              videoStatuses,
              i,
              videoStatus,
            ),
            progress: (completedWeight / totalWeight).clamp(0, 1).toDouble(),
            elapsed: elapsed(),
          ),
        );
      }

      emit(
        state.copyWith(
          status: CompressStatus.done,
          progress: 1,
          elapsed: elapsed(),
        ),
      );
    } finally {
      stopwatch.stop();
      await _setScreenAwake(false);
    }
  }

  Future<void> _onForegroundResumed(
    CompressForegroundResumed event,
    Emitter<CompressState> emit,
  ) async {
    if (state.status != CompressStatus.processing) return;
    final startIndex = state.processingIndex;
    if (!_resumeAfterBackground) {
      _cancelRequested = true;
      _compressionRunId++;
      await _videoCompressorAdapter.cancelCompression();
    }
    _cancelRequested = false;
    _resumeAfterBackground = false;
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed || state.status != CompressStatus.processing) return;
    await _runCompression(emit, startIndex: startIndex);
  }

  Future<void> _onBackgrounded(
    CompressBackgrounded event,
    Emitter<CompressState> emit,
  ) async {
    if (state.status != CompressStatus.processing || _resumeAfterBackground) {
      return;
    }
    _resumeAfterBackground = true;
    _cancelRequested = true;
    _compressionRunId++;
    await _videoCompressorAdapter.cancelCompression();
    await _setScreenAwake(false);
  }

  void _onProgressChanged(
    CompressProgressChanged event,
    Emitter<CompressState> emit,
  ) {
    if (event.runId != _compressionRunId) return;
    if (state.status != CompressStatus.processing || _cancelRequested) return;
    if (event.progress < state.progress) return;
    emit(
      state.copyWith(
        progress: event.progress,
        currentVideoProgress: event.currentVideoProgress,
        elapsed: event.elapsed,
      ),
    );
  }

  Future<void> _onCancelled(
    CompressCancelled event,
    Emitter<CompressState> emit,
  ) async {
    if (state.status != CompressStatus.processing) return;
    _cancelRequested = true;
    _compressionRunId++;
    await _videoCompressorAdapter.cancelCompression();
    await _setScreenAwake(false);
    emit(
      state.copyWith(
        status: CompressStatus.ready,
        results: const [],
        videoStatuses: List<VideoCompressionStatus>.filled(
          state.videos.length,
          VideoCompressionStatus.waiting,
        ),
        processingIndex: 0,
        progress: 0,
        currentVideoProgress: 0,
        elapsed: Duration.zero,
        clearCompressionError: true,
      ),
    );
  }

  Future<void> _onResultsSaved(
    CompressResultsSaved event,
    Emitter<CompressState> emit,
  ) async {
    if (state.isSaving) return;
    final outputPaths = state.successfulOutputPaths;
    if (outputPaths.isEmpty) return;

    emit(state.copyWith(isSaving: true, clearSaveNotification: true));

    try {
      for (final outputPath in outputPaths) {
        await _videoFileAdapter.saveToGallery(
          outputPath,
          album: _appSettings.saveVideosToAlbum
              ? AppSettingsService.albumName
              : null,
        );
      }

      if (!event.deleteOriginals) {
        emit(
          state.copyWith(
            savedVideoCount: outputPaths.length,
            deletedOriginalCount: 0,
            isSaving: false,
            clearSaveNotification: true,
          ),
        );
        return;
      }

      var deletedOriginalCount = 0;
      try {
        final identifiers =
            event.deleteSourceIdentifiers ??
            state.successResults
                .where((item) => item.source.path != item.result.outputPath)
                .where((item) => item.source.canDeleteOriginal)
                .map((item) => item.source.sourceIdentifier)
                .whereType<String>()
                .toSet();
        if (identifiers.isEmpty) {
          throw StateError(
            'original videos cannot be deleted by this provider',
          );
        }
        deletedOriginalCount = await _videoFileAdapter.deleteOriginals(
          identifiers,
        );

        emit(
          state.copyWith(
            savedVideoCount: outputPaths.length,
            deletedOriginalCount: deletedOriginalCount,
            isSaving: false,
            clearSaveNotification: true,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            savedVideoCount: outputPaths.length,
            deletedOriginalCount: deletedOriginalCount,
            deleteError: error,
            isSaving: false,
            clearSaveNotification: true,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          saveError: e,
          isSaving: false,
          clearSaveNotification: true,
        ),
      );
    }
  }

  void _onMessagesCleared(
    CompressMessagesCleared event,
    Emitter<CompressState> emit,
  ) {
    emit(state.copyWith(clearSaveNotification: true));
  }

  List<VideoCompressionStatus> _videoStatusesWith(
    List<VideoCompressionStatus> statuses,
    int index,
    VideoCompressionStatus status,
  ) {
    final next = List<VideoCompressionStatus>.of(statuses);
    if (index >= 0 && index < next.length) next[index] = status;
    return next;
  }

  Future<void> _setScreenAwake(bool enabled) async {
    if (enabled == _screenAwakeEnabled) return;
    _screenAwakeEnabled = enabled;
    try {
      await _screenAwakeService.setEnabled(enabled);
    } catch (_) {
      _screenAwakeEnabled = !enabled;
    }
  }
}
