import '../../../../generated/l10n.dart';

abstract final class CompressionLabels {
  static String preset(String preset, S strings) {
    return switch (preset) {
      'ultrafast' => strings.ultraFast,
      'fast' => strings.fast,
      'medium' => strings.medium,
      'slow' => strings.slow,
      _ => preset,
    };
  }

  static String resolution(String? resolution, S strings) {
    return switch (resolution) {
      null => strings.original,
      '1920:1080' => '1080p',
      '1280:720' => '720p',
      '854:480' => '480p',
      _ => resolution,
    };
  }

  static String quality(double crf, S strings) {
    if (crf < 20) return strings.high;
    if (crf < 25) return strings.good;
    if (crf < 31) return strings.medium;
    return strings.small;
  }
}
