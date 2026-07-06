import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

import '../domain/picked_video.dart';

class VideoFileAdapter {
  static const _channel = MethodChannel('minimo_video/videos');

  Future<List<PickedVideo>> pickVideos({
    void Function(int processed, int total)? onProgress,
  }) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'pickProgress') return;
      final progress = call.arguments as Map<dynamic, dynamic>;
      onProgress?.call(progress['processed'] as int, progress['total'] as int);
    });
    final List<dynamic>? result;
    try {
      result = await _channel.invokeMethod<List<dynamic>>('pickVideos');
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
      );
    }).toList();
  }

  Future<void> saveToGallery(String filePath, {String? album}) async {
    await Gal.putVideo(filePath, album: album);
  }

  Future<int> deleteOriginals(Iterable<String> sourceIdentifiers) async {
    return await _channel.invokeMethod<int>(
          'deleteOriginals',
          sourceIdentifiers.toList(),
        ) ??
        0;
  }
}
