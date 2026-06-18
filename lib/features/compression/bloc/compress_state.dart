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
  final CompressionSettings settings;
  final int? savedVideoCount;
  final Object? saveError;

  const CompressState({
    required this.status,
    required this.videos,
    required this.thumbnailPaths,
    required this.results,
    required this.processingIndex,
    required this.settings,
    this.savedVideoCount,
    this.saveError,
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
      settings: CompressionSettings(),
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
    return results.fold<int>(0, (sum, item) => sum + item.source.size);
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
    CompressionSettings? settings,
    int? savedVideoCount,
    Object? saveError,
    bool clearSaveNotification = false,
  }) {
    return CompressState(
      status: status ?? this.status,
      videos: videos == null ? this.videos : List.unmodifiable(videos),
      thumbnailPaths: thumbnailPaths == null
          ? this.thumbnailPaths
          : List.unmodifiable(thumbnailPaths),
      results: results == null ? this.results : List.unmodifiable(results),
      processingIndex: processingIndex ?? this.processingIndex,
      settings: settings ?? this.settings,
      savedVideoCount: clearSaveNotification
          ? savedVideoCount
          : savedVideoCount ?? this.savedVideoCount,
      saveError: clearSaveNotification
          ? saveError
          : saveError ?? this.saveError,
    );
  }
}
