import '../../domain/compression_settings.dart';

abstract final class CompressionEstimate {
  static int compressedSize({
    required int originalSize,
    required CompressionSettings settings,
  }) {
    final crfProgress = ((settings.crf - 18) / 16).clamp(0.0, 1.0);
    var ratio = (0.95 - crfProgress * 0.35) * 0.93;
    if (settings.videoBitrateMbps case final bitrate?) {
      ratio *= bitrate / _presetBitrate(settings.crf);
    } else {
      ratio *= settings.resolutionEstimateScale;
      ratio *= (settings.validatedFrameRate ?? 30) / 30;
      if (settings.codec == CompressionCodec.hevc) ratio *= 0.72;
    }
    if (settings.audioMode == CompressionAudioMode.remove) ratio *= 0.9;
    return (originalSize * ratio.clamp(0.05, 1)).round();
  }

  static int _presetBitrate(double crf) => crf <= 22 ? 4 : (crf <= 28 ? 2 : 1);
}
