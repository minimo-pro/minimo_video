import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/app_cache_service.dart';

void main() {
  test('counts cache and removes only old files automatically', () async {
    final root = await Directory.systemTemp.createTemp('minimo_cache_test');
    addTearDown(() => root.delete(recursive: true));
    final picked = await Directory('${root.path}/picked_videos').create();
    final old = await File('${picked.path}/old.mp4').writeAsBytes([1, 2]);
    final fresh = await File('${picked.path}/fresh.mp4').writeAsBytes([3]);
    final now = DateTime(2026, 7, 2, 12);
    await old.setLastModified(now.subtract(const Duration(days: 2)));
    await fresh.setLastModified(now);

    expect(await AppCacheService.size(root: root), 3);
    await AppCacheService.clearOld(root: root, now: now);
    expect(await old.exists(), isFalse);
    expect(await fresh.exists(), isTrue);

    await AppCacheService.clear(root: root);
    expect(await fresh.exists(), isFalse);
  });
}
