import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

import '../domain/picked_video.dart';

class VideoFileAdapter {
  static const _channel = MethodChannel('minimo_video/videos');

  Future<List<PickedVideo>> pickVideos() async {
    final result = await _channel.invokeMethod<List<dynamic>>('pickVideos');
    if (result == null) return const [];

    return result.cast<Map<dynamic, dynamic>>().map((file) {
      final path = file['path'] as String;
      final name = file['name'] as String;
      final size = file['size'] as int;
      return PickedVideo(path: path, name: name, size: size);
    }).toList();
  }

  Future<void> saveToGallery(String filePath, {String? album}) async {
    await Gal.putVideo(filePath, album: album);
  }

  Future<bool> deleteFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return false;
    await file.delete();
    return true;
  }
}
