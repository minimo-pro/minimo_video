import '../../domain/compression_settings.dart';

abstract final class CompressionEstimate {
  static int compressedSize({
    required int originalSize,
    required CompressionSettings settings,
  }) {
    final crfProgress = ((settings.crf - 18) / 16).clamp(0.0, 1.0);
    var ratio = 0.95 - crfProgress * 0.35;
    ratio *= switch (settings.resolution) {
      null => 0.93,
      '1920:1080' => 0.86,
      '1280:720' => 0.75,
      '854:480' => 0.58,
      '640:360' => 0.48,
      _ => 0.75,
    };
    if (settings.videoCodec == CompressionVideoCodec.h265) ratio *= 0.82;
    if (settings.audioMode == CompressionAudioMode.mono) ratio *= 0.96;
    if (settings.audioMode == CompressionAudioMode.remove) ratio *= 0.9;
    if (settings.noiseReduction) ratio *= 0.96;
    return (originalSize * ratio).round();
  }
}
