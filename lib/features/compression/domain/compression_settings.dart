class CompressionSettings {
  final double crf;
  final String preset;
  final String? resolution;

  CompressionSettings({
    this.crf = 28,
    this.preset = 'fast',
    this.resolution = '1280:720',
  });

  CompressionSettings copyWith({
    double? crf,
    String? preset,
    Object? resolution = _unset,
  }) {
    return CompressionSettings(
      crf: crf ?? this.crf,
      preset: preset ?? this.preset,
      resolution: resolution == _unset
          ? this.resolution
          : resolution as String?,
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
