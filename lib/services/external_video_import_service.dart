import 'package:flutter/services.dart';

import '../features/compression/data/video_file_adapter.dart';
import '../features/compression/domain/compression_settings.dart';
import '../features/compression/domain/picked_video.dart';

class ExternalVideoImport {
  final List<PickedVideo> videos;
  final CompressionSettings settings;

  const ExternalVideoImport({required this.videos, required this.settings});
}

class ExternalVideoImportService {
  static const _channel = MethodChannel('minimo_video/external_videos');

  void listen(Future<void> Function() onAvailable) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'externalVideosAvailable') await onAvailable();
    });
  }

  void stopListening() => _channel.setMethodCallHandler(null);

  Future<ExternalVideoImport?> consume() async {
    final Map<String, dynamic>? payload;
    try {
      payload = await _channel.invokeMapMethod<String, dynamic>(
        'consumeExternalVideos',
      );
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
    final files = payload?['files'] as List<dynamic>? ?? const [];
    if (files.isEmpty) return null;
    final settings = switch (payload?['preset']) {
      'high' => const CompressionSettings(crf: 22, resolution: null),
      'low' => const CompressionSettings(crf: 34, resolution: '854:480'),
      _ => const CompressionSettings(),
    };
    return ExternalVideoImport(
      videos: VideoFileAdapter.mapPlatformFiles(files),
      settings: settings,
    );
  }
}
