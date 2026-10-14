import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
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

  static Future<void> removeFiles(
    Iterable<String> paths, {
    Directory? root,
  }) async {
    final existing = <String>[];
    for (final filePath in paths.toSet()) {
      if (await File(filePath).exists()) existing.add(filePath);
    }
    if (existing.isEmpty) return;
    final cacheRoot = root ?? await getTemporaryDirectory();
    final directories = _directoryNames
        .map((name) => path.join(cacheRoot.path, name))
        .toList();
    for (final filePath in existing) {
      final file = File(filePath);
      try {
        if (!await file.exists()) continue;
        final resolved = await file.resolveSymbolicLinks();
        final resolvedRoot = await cacheRoot.resolveSymbolicLinks();
        if (!directories.any(
              (directory) => path.isWithin(directory, filePath),
            ) ||
            !_directoryNames.any(
              (name) => path.isWithin(path.join(resolvedRoot, name), resolved),
            )) {
          continue;
        }
        await file.delete();
      } on FileSystemException catch (error) {
        // Cold-start/manual cleanup retries files that could not be removed.
        debugPrint('Cache cleanup failed: $error');
      }
    }
  }

  static Future<List<Directory>> _directories(Directory? root) async {
    final temporaryDirectory = root ?? await getTemporaryDirectory();
    return _directoryNames
        .map((name) => Directory('${temporaryDirectory.path}/$name'))
        .toList();
  }
}
