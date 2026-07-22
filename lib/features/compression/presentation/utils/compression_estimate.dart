import '../../domain/compression_settings.dart';

abstract final class CompressionEstimate {
  static int compressedSize({
    required int originalSize,
    required CompressionSettings settings,
  }) {
    final crfProgress = ((settings.crf - 18) / 16).clamp(0.0, 1.0);
    var ratio =
        (0.95 - crfProgress * 0.35) *
        0.93 *
        settings.resolutionEstimateScale;
    if (settings.audioMode == CompressionAudioMode.remove) ratio *= 0.9;
    return (originalSize * ratio).round();
  }
}
