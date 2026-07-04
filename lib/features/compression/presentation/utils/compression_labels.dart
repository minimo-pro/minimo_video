import '../../../../generated/l10n.dart';

abstract final class CompressionLabels {
  static String resolution(String? resolution, S strings) {
    return switch (resolution) {
      null => strings.original,
      '1920:1080' => '1080p',
      '1280:720' => '720p',
      '854:480' => '480p',
      '640:360' => '360p',
      _ => resolution,
    };
  }
}
