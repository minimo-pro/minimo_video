class CompressionSettings {
  final double crf;
  final String? resolution;
  final CompressionAudioMode audioMode;
  final int? videoBitrateMbps;
  final int? frameRate;
  final CompressionCodec codec;

  const CompressionSettings({
    this.crf = 28,
    this.resolution = '1280:720',
    this.audioMode = CompressionAudioMode.stereo,
    this.videoBitrateMbps,
    this.frameRate,
    this.codec = CompressionCodec.h264,
  });

  CompressionSettings copyWith({
    double? crf,
    Object? resolution = _unset,
    CompressionAudioMode? audioMode,
    Object? videoBitrateMbps = _unset,
    Object? frameRate = _unset,
    CompressionCodec? codec,
  }) {
    return CompressionSettings(
      crf: crf ?? this.crf,
      resolution: resolution == _unset
          ? this.resolution
          : resolution as String?,
      audioMode: audioMode ?? this.audioMode,
      videoBitrateMbps: videoBitrateMbps == _unset
          ? this.videoBitrateMbps
          : videoBitrateMbps as int?,
      frameRate: frameRate == _unset ? this.frameRate : frameRate as int?,
      codec: codec ?? this.codec,
    );
  }

  SimpleCompressionQuality get simpleQuality {
    if (crf <= 22 && resolution == null) return SimpleCompressionQuality.high;
    if (crf <= 28 && resolution == '1280:720') {
      return SimpleCompressionQuality.medium;
    }
    return SimpleCompressionQuality.low;
  }

  double get resolutionEstimateScale => switch (resolution) {
    null => 1,
    '1920:1080' => 0.925,
    '1280:720' => 0.806,
    '854:480' => 0.624,
    '640:360' => 0.516,
    _ => 0.806,
  };
}

const _unset = Object();

enum SimpleCompressionQuality { high, medium, low }

enum CompressionAudioMode { stereo, remove }

enum CompressionCodec { h264, hevc }
