import '../../domain/compression_settings.dart';

abstract final class CompressionEstimate {
  static int compressedSize({
    required int originalSize,
    required CompressionSettings settings,
  }) {
    var ratio = switch (settings.simpleQuality) {
      SimpleCompressionQuality.high => 0.8,
      SimpleCompressionQuality.medium => 0.55,
      SimpleCompressionQuality.low => 0.35,
    };
    if (settings.videoCodec == CompressionVideoCodec.h265) ratio *= 0.82;
    if (settings.audioMode == CompressionAudioMode.mono) ratio *= 0.96;
    if (settings.audioMode == CompressionAudioMode.remove) ratio *= 0.9;
    if (settings.noiseReduction) ratio *= 0.96;
    return (originalSize * ratio).round();
  }

  static int savingsPercent({
    required int originalSize,
    required CompressionSettings settings,
  }) {
    if (originalSize == 0) return 0;
    final estimatedSize = compressedSize(
      originalSize: originalSize,
      settings: settings,
    );
    return ((1 - estimatedSize / originalSize) * 100).clamp(0, 99).round();
  }
}
