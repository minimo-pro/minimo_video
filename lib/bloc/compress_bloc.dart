import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/compression_service.dart';
import '../services/file_service.dart';
import 'compress_event.dart';
import 'compress_state.dart';

class CompressBloc extends Bloc<CompressEvent, CompressState> {
  final FileService _fileService;
  final CompressionService _compressionService;

  CompressBloc({
    List<PickedVideo> initialVideos = const [],
    FileService? fileService,
    CompressionService? compressionService,
  }) : _fileService = fileService ?? FileService(),
       _compressionService = compressionService ?? CompressionService(),
       super(CompressState.initial(initialVideos)) {
    on<CompressCrfChanged>(_onCrfChanged);
    on<CompressPresetChanged>(_onPresetChanged);
    on<CompressResolutionChanged>(_onResolutionChanged);
    on<CompressStarted>(_onStarted);
    on<CompressResultsSaved>(_onResultsSaved);
    on<CompressMessagesCleared>(_onMessagesCleared);
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
        clearSaveMessage: true,
        clearErrorMessage: true,
      ),
    );

    for (var i = 0; i < videos.length; i++) {
      emit(state.copyWith(processingIndex: i));

      final video = videos[i];
      final outputPath = FileService.tempOutputPath;
      final command = state.settings.buildCommand(video.path, outputPath);
      final result = await _compressionService.execute(command, outputPath);

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
        await _fileService.saveToGallery(outputPath);
      }
      emit(
        state.copyWith(
          saveMessage: 'Saved ${outputPaths.length} video(s) to gallery',
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to save: $e',
          clearSaveMessage: true,
        ),
      );
    }
  }

  void _onMessagesCleared(
    CompressMessagesCleared event,
    Emitter<CompressState> emit,
  ) {
    emit(state.copyWith(clearSaveMessage: true, clearErrorMessage: true));
  }
}
