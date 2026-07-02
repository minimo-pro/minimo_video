import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppCacheService {
  static const _directoryNames = ['picked_videos', 'minimo_video'];

  static Future<int> size({Directory? root}) async {
    final directories = await _directories(root);
    var bytes = 0;
    for (final directory in directories) {
      if (!await directory.exists()) continue;
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) bytes += await entity.length();
      }
    }
    return bytes;
  }

  static Future<void> clear({Directory? root}) async {
    for (final directory in await _directories(root)) {
      if (await directory.exists()) await directory.delete(recursive: true);
    }
  }

  static Future<void> clearOld({
    Directory? root,
    Duration maxAge = const Duration(hours: 24),
    DateTime? now,
  }) async {
    final cutoff = (now ?? DateTime.now()).subtract(maxAge);
    for (final directory in await _directories(root)) {
      if (!await directory.exists()) continue;
      await for (final entity in directory.list()) {
        if ((await entity.stat()).modified.isBefore(cutoff)) {
          await entity.delete(recursive: true);
        }
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
