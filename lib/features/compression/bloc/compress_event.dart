abstract class CompressEvent {
  const CompressEvent();
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

class CompressResultsSaved extends CompressEvent {
  const CompressResultsSaved();
}

class CompressMessagesCleared extends CompressEvent {
  const CompressMessagesCleared();
}
