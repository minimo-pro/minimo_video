class CompressionSettings {
  final double crf;
  final String preset;
  final String? resolution;
  final double? frameRate;
  final CompressionVideoCodec videoCodec;
  final CompressionAudioMode audioMode;
  final bool twoPassEncoding;
  final bool noiseReduction;
  final bool optimizeForStreaming;
  final bool preserveMetadata;
  final bool hardwareAcceleration;

  const CompressionSettings({
    this.crf = 28,
    this.preset = 'fast',
    this.resolution = '1280:720',
    this.frameRate,
    this.videoCodec = CompressionVideoCodec.h264,
    this.audioMode = CompressionAudioMode.stereo,
    this.twoPassEncoding = false,
    this.noiseReduction = false,
    this.optimizeForStreaming = true,
    this.preserveMetadata = true,
    this.hardwareAcceleration = true,
  });

  CompressionSettings copyWith({
    double? crf,
    String? preset,
    Object? resolution = _unset,
    Object? frameRate = _unset,
    CompressionVideoCodec? videoCodec,
    CompressionAudioMode? audioMode,
    bool? twoPassEncoding,
    bool? noiseReduction,
    bool? optimizeForStreaming,
    bool? preserveMetadata,
    bool? hardwareAcceleration,
  }) {
    return CompressionSettings(
      crf: crf ?? this.crf,
      preset: preset ?? this.preset,
      resolution: resolution == _unset
          ? this.resolution
          : resolution as String?,
      frameRate: frameRate == _unset ? this.frameRate : frameRate as double?,
      videoCodec: videoCodec ?? this.videoCodec,
      audioMode: audioMode ?? this.audioMode,
      twoPassEncoding: twoPassEncoding ?? this.twoPassEncoding,
      noiseReduction: noiseReduction ?? this.noiseReduction,
      optimizeForStreaming: optimizeForStreaming ?? this.optimizeForStreaming,
      preserveMetadata: preserveMetadata ?? this.preserveMetadata,
      hardwareAcceleration: hardwareAcceleration ?? this.hardwareAcceleration,
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

enum CompressionVideoCodec { h264, h265 }

enum CompressionAudioMode { stereo, mono, remove }
