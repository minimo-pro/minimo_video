import '../domain/compression_settings.dart';

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

class CompressCrfChanged extends CompressEvent {
  final double crf;

  const CompressCrfChanged(this.crf);
}

class CompressPresetChanged extends CompressEvent {
  final String preset;

  const CompressPresetChanged(this.preset);
}

class CompressResolutionChanged extends CompressEvent {
  final String? resolution;

  const CompressResolutionChanged(this.resolution);
}

class CompressStarted extends CompressEvent {
  const CompressStarted();
}

class CompressProgressChanged extends CompressEvent {
  final double progress;
  final Duration elapsed;

  const CompressProgressChanged({
    required this.progress,
    required this.elapsed,
  });
}

class CompressCancelled extends CompressEvent {
  const CompressCancelled();
}

class CompressResultsSaved extends CompressEvent {
  final bool deleteOriginals;

  const CompressResultsSaved({required this.deleteOriginals});
}

class CompressMessagesCleared extends CompressEvent {
  const CompressMessagesCleared();
}
