class CompressionSettings {
  final double crf;
  final String? resolution;
  final CompressionAudioMode audioMode;

  const CompressionSettings({
    this.crf = 28,
    this.resolution = '1280:720',
    this.audioMode = CompressionAudioMode.stereo,
  });

  CompressionSettings copyWith({
    double? crf,
    Object? resolution = _unset,
    CompressionAudioMode? audioMode,
  }) {
    return CompressionSettings(
      crf: crf ?? this.crf,
      resolution: resolution == _unset
          ? this.resolution
          : resolution as String?,
      audioMode: audioMode ?? this.audioMode,
    );
  }

  SimpleCompressionQuality get simpleQuality {
    if (crf <= 22 && resolution == null) return SimpleCompressionQuality.high;
    if (crf <= 28 && resolution == '1280:720') {
      return SimpleCompressionQuality.medium;
    }
    return SimpleCompressionQuality.low;
  }
}

const _unset = Object();

enum SimpleCompressionQuality { high, medium, low }

enum CompressionAudioMode { stereo, remove }
