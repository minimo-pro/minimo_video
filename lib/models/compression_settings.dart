class CompressionSettings {
  double crf;
  String preset;
  String? resolution;

  CompressionSettings({
    this.crf = 28,
    this.preset = 'fast',
    this.resolution,
  });

  String get presetLabel {
    switch (preset) {
      case 'ultrafast': return 'Ultra Fast';
      case 'fast': return 'Fast';
      case 'medium': return 'Medium';
      case 'slow': return 'Slow';
      default: return preset;
    }
  }

  String get resolutionLabel {
    switch (resolution) {
      case null: return 'Original';
      case '1920:1080': return '1080p';
      case '1280:720': return '720p';
      case '854:480': return '480p';
      default: return resolution!;
    }
  }

  String get qualityLabel {
    if (crf < 20) return 'High';
    if (crf < 25) return 'Good';
    if (crf < 31) return 'Medium';
    return 'Small';
  }

  String buildCommand(String inputPath, String outputPath) {
    final filters = <String>[];
    if (resolution != null) {
      filters.add('scale=$resolution:force_original_aspect_ratio=decrease');
    }

    var cmd = '-i "$inputPath"';
    cmd += ' -c:v libx264';
    cmd += ' -preset $preset';
    cmd += ' -crf ${crf.toInt()}';
    if (filters.isNotEmpty) {
      cmd += ' -vf "${filters.join(',')}"';
    }
    cmd += ' -c:a aac -b:a 128k';
    cmd += ' "$outputPath"';
    return cmd;
  }
}
