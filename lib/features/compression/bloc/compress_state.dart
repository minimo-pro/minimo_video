import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';
import '../domain/picked_video.dart';

enum CompressStatus { ready, processing, done }

class CompressedVideo {
  final PickedVideo source;
  final CompressionResult result;

  const CompressedVideo({required this.source, required this.result});
}

class CompressState {
  final CompressStatus status;
  final List<PickedVideo> videos;
  final List<String?> thumbnailPaths;
  final List<CompressedVideo> results;
  final int processingIndex;
  final double progress;
  final Duration elapsed;
  final CompressionSettings settings;
  final bool isSaving;
  final int? savedVideoCount;
  final int? deletedOriginalCount;
  final Object? saveError;
  final Object? deleteError;
  final Object? compressionError;

  const CompressState({
    required this.status,
    required this.videos,
    required this.thumbnailPaths,
    required this.results,
    required this.processingIndex,
    required this.progress,
    required this.elapsed,
    required this.settings,
    required this.isSaving,
    this.savedVideoCount,
    this.deletedOriginalCount,
    this.saveError,
    this.deleteError,
    this.compressionError,
  });

  factory CompressState.initial(List<PickedVideo> videos) {
    return CompressState(
      status: CompressStatus.ready,
      videos: List.unmodifiable(videos),
      thumbnailPaths: List.unmodifiable(
        List<String?>.filled(videos.length, null),
      ),
      results: const [],
      processingIndex: 0,
      progress: 0,
      elapsed: Duration.zero,
      settings: CompressionSettings(),
      isSaving: false,
    );
  }

  bool get showSettings => videos.isNotEmpty && status == CompressStatus.ready;

  int get totalOriginalSize {
    return videos.fold<int>(0, (sum, video) => sum + video.size);
  }

  List<CompressedVideo> get successResults {
    return results.where((item) => item.result.success).toList();
  }

  int get resultsOriginalSize {
    return successResults.fold<int>(
      0,
      (sum, item) =>
          sum +
          ((item.result.originalSize ?? 0) > 0
              ? item.result.originalSize!
              : item.source.size),
    );
  }

  int get compressedSize {
    return successResults.fold<int>(
      0,
      (sum, item) => sum + (item.result.outputSize ?? 0),
    );
  }

  List<String> get successfulOutputPaths {
    return successResults
        .map((item) => item.result.outputPath)
        .whereType<String>()
        .toList();
  }

  CompressState copyWith({
    CompressStatus? status,
    List<PickedVideo>? videos,
    List<String?>? thumbnailPaths,
    List<CompressedVideo>? results,
    int? processingIndex,
    double? progress,
    Duration? elapsed,
    CompressionSettings? settings,
    bool? isSaving,
    int? savedVideoCount,
    int? deletedOriginalCount,
    Object? saveError,
    Object? deleteError,
    Object? compressionError,
    bool clearSaveNotification = false,
    bool clearCompressionError = false,
  }) {
    return CompressState(
      status: status ?? this.status,
      videos: videos == null ? this.videos : List.unmodifiable(videos),
      thumbnailPaths: thumbnailPaths == null
          ? this.thumbnailPaths
          : List.unmodifiable(thumbnailPaths),
      results: results == null ? this.results : List.unmodifiable(results),
      processingIndex: processingIndex ?? this.processingIndex,
      progress: progress ?? this.progress,
      elapsed: elapsed ?? this.elapsed,
      settings: settings ?? this.settings,
      isSaving: isSaving ?? this.isSaving,
      savedVideoCount: clearSaveNotification
          ? savedVideoCount
          : savedVideoCount ?? this.savedVideoCount,
      deletedOriginalCount: clearSaveNotification
          ? deletedOriginalCount
          : deletedOriginalCount ?? this.deletedOriginalCount,
      saveError: clearSaveNotification
          ? saveError
          : saveError ?? this.saveError,
      deleteError: clearSaveNotification
          ? deleteError
          : deleteError ?? this.deleteError,
      compressionError: clearCompressionError
          ? compressionError
          : compressionError ?? this.compressionError,
    );
  }
}
