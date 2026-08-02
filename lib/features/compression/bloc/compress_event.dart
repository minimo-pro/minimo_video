import '../domain/compression_settings.dart';
import '../domain/picked_video.dart';

abstract class CompressEvent {
  const CompressEvent();
}

class CompressSimpleQualityChanged extends CompressEvent {
  final SimpleCompressionQuality quality;

  const CompressSimpleQualityChanged(this.quality);
}

class CompressThumbnailsRequested extends CompressEvent {
  const CompressThumbnailsRequested();
}

class CompressEstimateRequested extends CompressEvent {
  const CompressEstimateRequested();
}

class CompressVideosAdded extends CompressEvent {
  final List<PickedVideo> videos;

  const CompressVideosAdded(this.videos);
}

class CompressResolutionChanged extends CompressEvent {
  final String? resolution;

  const CompressResolutionChanged(this.resolution);
}

class CompressSettingsChanged extends CompressEvent {
  final CompressionSettings settings;

  const CompressSettingsChanged(this.settings);
}

class CompressStarted extends CompressEvent {
  const CompressStarted();
}

class CompressProgressChanged extends CompressEvent {
  final int runId;
  final double progress;
  final double currentVideoProgress;
  final Duration elapsed;

  const CompressProgressChanged({
    required this.runId,
    required this.progress,
    required this.currentVideoProgress,
    required this.elapsed,
  });
}

class CompressCancelled extends CompressEvent {
  const CompressCancelled();
}

class CompressBackgrounded extends CompressEvent {
  const CompressBackgrounded();
}

class CompressForegroundResumed extends CompressEvent {
  const CompressForegroundResumed();
}

class CompressResultsSaved extends CompressEvent {
  final bool deleteOriginals;
  final Set<String>? deleteSourceIdentifiers;

  const CompressResultsSaved({
    required this.deleteOriginals,
    this.deleteSourceIdentifiers,
  });
}

class CompressMessagesCleared extends CompressEvent {
  const CompressMessagesCleared();
}
