import 'dart:io';

import 'package:flutter/services.dart';
import 'package:light_compressor_v2/light_compressor_v2.dart';
import 'package:path_provider/path_provider.dart';

class AppCacheService {
  static const _channel = MethodChannel('minimo_video/videos');
  static const _directoryNames = [
    'picked_videos',
    'minimo_video',
    'minimo_thumbnails',
  ];

  static Future<int> size({Directory? root}) async {
    final directories = await _directories(root);
    var bytes = 0;
    for (final directory in directories) {
      if (!await directory.exists()) continue;
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) bytes += await entity.length();
      }
    }
    if (root == null && Platform.isIOS) {
      try {
        bytes += await _channel.invokeMethod<int>('temporaryCacheSize') ?? 0;
      } on PlatformException {
        // Keep the tracked cache size available if native accounting fails.
      } on MissingPluginException {
        // Allows the service to run before the native channel is registered.
      }
    }
    return bytes;
  }

  static Future<void> clear({Directory? root}) async {
    for (final directory in await _directories(root)) {
      if (await directory.exists()) await directory.delete(recursive: true);
    }
    if (root == null) {
      if (Platform.isIOS) {
        await _channel.invokeMethod<void>('clearTemporaryCache');
      }
      await LightCompressor().clearCache();
    }
  }

  static Future<List<Directory>> _directories(Directory? root) async {
    final temporaryDirectory = root ?? await getTemporaryDirectory();
    return _directoryNames
        .map((name) => Directory('${temporaryDirectory.path}/$name'))
        .toList();
  }
}
