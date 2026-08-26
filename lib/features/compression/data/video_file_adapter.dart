import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

import '../domain/picked_video.dart';
import '../domain/video_pick_source.dart';

class VideoFileAdapter {
  static const _channel = MethodChannel('minimo_video/videos');

  Future<List<PickedVideo>> pickVideos({
    VideoPickSource source = VideoPickSource.gallery,
    void Function(int processed, int total)? onProgress,
  }) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'pickProgress') return;
      final progress = call.arguments as Map<dynamic, dynamic>;
      onProgress?.call(progress['processed'] as int, progress['total'] as int);
    });
    final List<dynamic>? result;
    try {
      result = await _channel.invokeMethod<List<dynamic>>('pickVideos', {
        'source': source.channelValue,
      });
    } finally {
      _channel.setMethodCallHandler(null);
    }
    if (result == null) return const [];

    return result.cast<Map<dynamic, dynamic>>().map((file) {
      final path = file['path'] as String;
      final name = file['name'] as String;
      final size = file['size'] as int;
      return PickedVideo(
        path: path,
        name: name,
        size: size,
        sourceIdentifier: file['sourceIdentifier'] as String?,
        canDeleteOriginal: file['canDeleteOriginal'] as bool? ?? false,
      );
    }).toList();
  }

  Future<void> saveToGallery(String filePath, {String? album}) async {
    await Gal.putVideo(filePath, album: album);
  }

  Future<GallerySaveResult> saveReplacement(
    String filePath,
    String sourceIdentifier, {
    String? album,
  }) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'saveReplacement',
      {'path': filePath, 'sourceIdentifier': sourceIdentifier, 'album': album},
    );
    if (result == null || result['saved'] != true) {
      throw StateError('replacement video was not saved');
    }
    return GallerySaveResult(
      warnings: (result['warnings'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
    );
  }

  Future<int> deleteOriginals(Iterable<String> sourceIdentifiers) async {
    return await _channel.invokeMethod<int>(
          'deleteOriginals',
          sourceIdentifiers.toList(),
        ) ??
        0;
  }
}

class GallerySaveResult {
  final List<String> warnings;

  const GallerySaveResult({this.warnings = const []});
}
