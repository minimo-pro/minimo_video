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

  int effectiveBitrateMbps({
    int? outputWidth,
    int? outputHeight,
    double? sourceFrameRate,
  }) {
    if (videoBitrateMbps case final bitrate?) return bitrate;

    final outputFps = frameRate == null
        ? sourceFrameRate ?? 30
        : sourceFrameRate == null
        ? frameRate!.toDouble()
        : frameRate!.clamp(1, sourceFrameRate);
    final resolutionParts = resolution?.split(':');
    final width =
        outputWidth ??
        (resolutionParts?.length == 2
            ? int.tryParse(resolutionParts!.first)
            : null);
    final height =
        outputHeight ??
        (resolutionParts?.length == 2
            ? int.tryParse(resolutionParts![1])
            : null);

    double bitrate;
    if (width == null || height == null) {
      bitrate = _presetBitrateMbps(crf) * outputFps / 30;
      if (codec == CompressionCodec.hevc) bitrate *= 0.72;
    } else {
      final bitsPerPixel = codec == CompressionCodec.hevc ? 0.05 : 0.07;
      final qualityScale = crf <= 28 ? 1.0 : 0.75;
      bitrate = width * height * outputFps * bitsPerPixel * qualityScale / 1e6;
    }

    // ponytail: plugin accepts whole Mbps; use finer units when it supports them.
    return bitrate.round().clamp(1, 8);
  }

  double get resolutionEstimateScale => switch (resolution) {
    null => 1,
    '1920:1080' => 0.925,
    '1280:720' => 0.806,
    '854:480' => 0.624,
    '640:360' => 0.516,
    _ => 0.806,
  };

  static int _presetBitrateMbps(double crf) =>
      crf <= 22 ? 4 : (crf <= 28 ? 2 : 1);
}

const _unset = Object();

enum SimpleCompressionQuality { high, medium, low }

enum CompressionAudioMode { stereo, remove }

enum CompressionCodec { h264, hevc }
