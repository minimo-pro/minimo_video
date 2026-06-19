import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/video_compressor_adapter.dart';
import '../data/video_file_adapter.dart';
import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';
import '../domain/picked_video.dart';
import 'compress_event.dart';
import 'compress_state.dart';

class CompressBloc extends Bloc<CompressEvent, CompressState> {
  final VideoFileAdapter _videoFileAdapter;
  final VideoCompressorAdapter _videoCompressorAdapter;
  bool _cancelRequested = false;

  CompressBloc({
    List<PickedVideo> initialVideos = const [],
    VideoFileAdapter? videoFileAdapter,
    VideoCompressorAdapter? videoCompressorAdapter,
  }) : _videoFileAdapter = videoFileAdapter ?? VideoFileAdapter(),
       _videoCompressorAdapter =
           videoCompressorAdapter ?? VideoCompressorAdapter(),
       super(CompressState.initial(initialVideos)) {
    on<CompressThumbnailsRequested>(_onThumbnailsRequested);
    on<CompressSimpleQualityChanged>(_onSimpleQualityChanged);
    on<CompressCrfChanged>(_onCrfChanged);
    on<CompressPresetChanged>(_onPresetChanged);
    on<CompressResolutionChanged>(_onResolutionChanged);
    on<CompressStarted>(_onStarted);
    on<CompressProgressChanged>(_onProgressChanged);
    on<CompressCancelled>(_onCancelled);
    on<CompressResultsSaved>(_onResultsSaved);
    on<CompressMessagesCleared>(_onMessagesCleared);
    add(const CompressThumbnailsRequested());
  }

  Future<void> _onThumbnailsRequested(
    CompressThumbnailsRequested event,
    Emitter<CompressState> emit,
  ) async {
    final thumbnails = List<String?>.of(state.thumbnailPaths);
    final count = state.videos.length < 3 ? state.videos.length : 3;

    for (var i = 0; i < count; i++) {
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
            settings: state.settings.copyWith(
              crf: 22,
              preset: 'fast',
              resolution: null,
            ),
          ),
        );
      case SimpleCompressionQuality.medium:
        emit(
          state.copyWith(
            settings: state.settings.copyWith(
              crf: 28,
              preset: 'fast',
              resolution: '1280:720',
            ),
          ),
        );
      case SimpleCompressionQuality.low:
        emit(
          state.copyWith(
            settings: state.settings.copyWith(
              crf: 34,
              preset: 'fast',
              resolution: '854:480',
            ),
          ),
        );
    }
  }

  void _onCrfChanged(CompressCrfChanged event, Emitter<CompressState> emit) {
    emit(state.copyWith(settings: state.settings.copyWith(crf: event.crf)));
  }

  void _onPresetChanged(
    CompressPresetChanged event,
    Emitter<CompressState> emit,
  ) {
    emit(
      state.copyWith(settings: state.settings.copyWith(preset: event.preset)),
    );
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
  }

  Future<void> _onStarted(
    CompressStarted event,
    Emitter<CompressState> emit,
  ) async {
    if (state.videos.isEmpty) return;

    _cancelRequested = false;
    final stopwatch = Stopwatch()..start();
    final videos = List<PickedVideo>.of(state.videos);
    emit(
      state.copyWith(
        status: CompressStatus.processing,
        results: const [],
        processingIndex: 0,
        progress: 0,
        elapsed: Duration.zero,
        clearSaveNotification: true,
      ),
    );

    for (var i = 0; i < videos.length; i++) {
      emit(state.copyWith(processingIndex: i));

      final video = videos[i];
      late final CompressionResult result;
      try {
        result = await _videoCompressorAdapter.compress(
          video.path,
          state.settings,
          onProgress: (videoProgress) {
            if (_cancelRequested) return;
            final overallProgress = (i + videoProgress) / videos.length;
            add(
              CompressProgressChanged(
                progress: overallProgress.clamp(0, 1).toDouble(),
                elapsed: stopwatch.elapsed,
              ),
            );
          },
        );
      } catch (_) {
        if (_cancelRequested) return;
        rethrow;
      }

      if (_cancelRequested) return;

      emit(
        state.copyWith(
          results: [
            ...state.results,
            CompressedVideo(source: video, result: result),
          ],
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
    if (state.status != CompressStatus.processing || _cancelRequested) return;
    emit(state.copyWith(progress: event.progress, elapsed: event.elapsed));
  }

  Future<void> _onCancelled(
    CompressCancelled event,
    Emitter<CompressState> emit,
  ) async {
    if (state.status != CompressStatus.processing) return;
    _cancelRequested = true;
    await _videoCompressorAdapter.cancelCompression();
    emit(
      state.copyWith(
        status: CompressStatus.ready,
        results: const [],
        processingIndex: 0,
        progress: 0,
        elapsed: Duration.zero,
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
        await _videoFileAdapter.saveToGallery(outputPath);
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
        for (final item in state.successResults) {
          final outputPath = item.result.outputPath;
          if (outputPath == null || item.source.path == outputPath) continue;
          final deleted = await _videoFileAdapter.deleteFile(item.source.path);
          if (deleted) deletedOriginalCount++;
        }

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
}
