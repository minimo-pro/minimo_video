import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/video_compressor_adapter.dart';
import '../data/video_file_adapter.dart';
import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';
import '../domain/picked_video.dart';
import '../../../services/app_settings_service.dart';
import 'compress_event.dart';
import 'compress_state.dart';

class CompressBloc extends Bloc<CompressEvent, CompressState> {
  final VideoFileAdapter _videoFileAdapter;
  final VideoCompressorAdapter _videoCompressorAdapter;
  final AppSettingsService _appSettings;
  bool _cancelRequested = false;
  int _compressionRunId = 0;
  int _estimateRunId = 0;
  Timer? _estimateDebounce;

  CompressBloc({
    List<PickedVideo> initialVideos = const [],
    VideoFileAdapter? videoFileAdapter,
    VideoCompressorAdapter? videoCompressorAdapter,
    AppSettingsService? appSettings,
  }) : _videoFileAdapter = videoFileAdapter ?? VideoFileAdapter(),
       _videoCompressorAdapter =
           videoCompressorAdapter ?? VideoCompressorAdapter(),
       _appSettings = appSettings ?? AppSettingsService.instance,
       super(CompressState.initial(initialVideos)) {
    on<CompressThumbnailsRequested>(_onThumbnailsRequested);
    on<CompressEstimateRequested>(_onEstimateRequested);
    on<CompressSimpleQualityChanged>(_onSimpleQualityChanged);
    on<CompressResolutionChanged>(_onResolutionChanged);
    on<CompressSettingsChanged>(_onSettingsChanged);
    on<CompressStarted>(_onStarted);
    on<CompressProgressChanged>(_onProgressChanged);
    on<CompressCancelled>(_onCancelled);
    on<CompressResultsSaved>(_onResultsSaved);
    on<CompressMessagesCleared>(_onMessagesCleared);
    add(const CompressThumbnailsRequested());
    add(const CompressEstimateRequested());
  }

  void _requestEstimate() {
    _estimateRunId++;
    _estimateDebounce?.cancel();
    _estimateDebounce = Timer(
      const Duration(milliseconds: 200),
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
    final thumbnails = List<String?>.of(state.thumbnailPaths);
    final count = state.videos.length < 3 ? state.videos.length : 3;

    for (var i = 0; i < count; i++) {
      if (state.status != CompressStatus.ready) return;
      final path = await _videoCompressorAdapter.createThumbnail(
        state.videos[i].path,
      );
      thumbnails[i] = path;
      emit(state.copyWith(thumbnailPaths: thumbnails));
    }
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
          ),
        );
      case SimpleCompressionQuality.medium:
        emit(
          state.copyWith(
            settings: const CompressionSettings(
              crf: 28,
              resolution: '1280:720',
            ),
          ),
        );
      case SimpleCompressionQuality.low:
        emit(
          state.copyWith(
            settings: const CompressionSettings(crf: 34, resolution: '854:480'),
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
      ),
    );
    _requestEstimate();
  }

  void _onSettingsChanged(
    CompressSettingsChanged event,
    Emitter<CompressState> emit,
  ) {
    emit(state.copyWith(settings: event.settings));
    _requestEstimate();
  }

  @override
  Future<void> close() {
    _estimateDebounce?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    CompressStarted event,
    Emitter<CompressState> emit,
  ) async {
    if (state.videos.isEmpty) return;

    _estimateDebounce?.cancel();
    _estimateRunId++;
    _cancelRequested = false;
    final runId = ++_compressionRunId;
    final stopwatch = Stopwatch()..start();
    final videos = List<PickedVideo>.of(state.videos);
    final totalWeight = videos.fold<int>(
      0,
      (sum, video) => sum + (video.size > 0 ? video.size : 1),
    );
    var completedWeight = 0;
    var videoStatuses = List<VideoCompressionStatus>.filled(
      videos.length,
      VideoCompressionStatus.waiting,
    );
    emit(
      state.copyWith(
        status: CompressStatus.processing,
        results: const [],
        videoStatuses: videoStatuses,
        compressionRunId: runId,
        processingIndex: 0,
        progress: 0,
        currentVideoProgress: 0,
        elapsed: Duration.zero,
        clearSaveNotification: true,
        clearCompressionError: true,
      ),
    );

    for (var i = 0; i < videos.length; i++) {
      emit(
        state.copyWith(
          processingIndex: i,
          progress: completedWeight / totalWeight,
          currentVideoProgress: 0,
          elapsed: stopwatch.elapsed,
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
            if (_cancelRequested) return;
            final videoWeight = video.size > 0 ? video.size : 1;
            final overallProgress =
                (weightBeforeVideo + videoWeight * videoProgress) / totalWeight;
            add(
              CompressProgressChanged(
                runId: runId,
                progress: overallProgress.clamp(0, 1).toDouble(),
                currentVideoProgress: videoProgress.clamp(0, 1).toDouble(),
                elapsed: stopwatch.elapsed,
              ),
            );
          },
        );
      } catch (error) {
        if (_cancelRequested) return;
        result = const CompressionResult(success: false);
        videoStatus = VideoCompressionStatus.failed;
        emit(state.copyWith(compressionError: error));
      }

      if (_cancelRequested) return;
      if (videoStatus == VideoCompressionStatus.compressed && !result.success) {
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
          elapsed: stopwatch.elapsed,
        ),
      );
    }

    stopwatch.stop();
    emit(
      state.copyWith(
        status: CompressStatus.done,
        progress: 1,
        elapsed: stopwatch.elapsed,
      ),
    );
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
        final identifiers = state.successResults
            .where((item) => item.source.path != item.result.outputPath)
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
}
