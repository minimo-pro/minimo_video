import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/app_cache_service.dart';

void main() {
  test('counts and clears app cache', () async {
    final root = await Directory.systemTemp.createTemp('minimo_cache_test');
    addTearDown(() => root.delete(recursive: true));
    final picked = await Directory('${root.path}/picked_videos').create();
    final first = await File('${picked.path}/first.mp4').writeAsBytes([1, 2]);
    final second = await File('${picked.path}/second.mp4').writeAsBytes([3]);

    expect(await AppCacheService.size(root: root), 3);
    await AppCacheService.clear(root: root);
    expect(await first.exists(), isFalse);
    expect(await second.exists(), isFalse);
  });
}
