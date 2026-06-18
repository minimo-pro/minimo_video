import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/video_compressor_adapter.dart';
import '../data/video_file_adapter.dart';
import '../domain/compression_settings.dart';
import '../domain/picked_video.dart';
import 'compress_event.dart';
import 'compress_state.dart';

class CompressBloc extends Bloc<CompressEvent, CompressState> {
  final VideoFileAdapter _videoFileAdapter;
  final VideoCompressorAdapter _videoCompressorAdapter;

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

    final videos = List<PickedVideo>.of(state.videos);
    emit(
      state.copyWith(
        status: CompressStatus.processing,
        results: const [],
        processingIndex: 0,
        clearSaveNotification: true,
      ),
    );

    for (var i = 0; i < videos.length; i++) {
      emit(state.copyWith(processingIndex: i));

      final video = videos[i];
      final result = await _videoCompressorAdapter.compress(
        video.path,
        state.settings,
      );

      emit(
        state.copyWith(
          results: [
            ...state.results,
            CompressedVideo(source: video, result: result),
          ],
        ),
      );
    }

    emit(state.copyWith(status: CompressStatus.done));
  }

  Future<void> _onResultsSaved(
    CompressResultsSaved event,
    Emitter<CompressState> emit,
  ) async {
    final outputPaths = state.successfulOutputPaths;
    if (outputPaths.isEmpty) return;

    try {
      for (final outputPath in outputPaths) {
        await _videoFileAdapter.saveToGallery(outputPath);
      }
      emit(
        state.copyWith(
          savedVideoCount: outputPaths.length,
          clearSaveNotification: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(saveError: e, clearSaveNotification: true));
    }
  }

  void _onMessagesCleared(
    CompressMessagesCleared event,
    Emitter<CompressState> emit,
  ) {
    emit(state.copyWith(clearSaveNotification: true));
  }
}
