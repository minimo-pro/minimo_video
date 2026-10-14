import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/services/app_cache_service.dart';

void main() {
  test(
    'session cleanup removes only listed managed files, never originals or symlinks',
    () async {
      final root = await Directory.systemTemp.createTemp('minimo_cleanup_test');
      addTearDown(() => root.delete(recursive: true));
      final picked = await Directory('${root.path}/picked_videos').create();
      final output = await Directory('${root.path}/minimo_video').create();
      final imported = await File('${picked.path}/input.mp4').writeAsBytes([1]);
      final result = await File('${output.path}/result.mp4').writeAsBytes([2]);
      final otherBatch = await File(
        '${output.path}/other.mp4',
      ).writeAsBytes([3]);
      final original = await File(
        '${root.path}/original.mp4',
      ).writeAsBytes([4]);
      final link = await Link(
        '${picked.path}/linked.mp4',
      ).create(original.path);
      await AppCacheService.removeFiles([
        imported.path,
        result.path,
        original.path,
        link.path,
        '${picked.path}/../original.mp4',
        '${picked.path}/missing.mp4',
      ], root: root);
      expect(await imported.exists(), isFalse);
      expect(await result.exists(), isFalse);
      expect(await otherBatch.exists(), isTrue);
      expect(await original.exists(), isTrue);
      expect(await link.exists(), isTrue);
    },
  );

  test('counts and clears app cache', () async {
    final root = await Directory.systemTemp.createTemp('minimo_cache_test');
    addTearDown(() => root.delete(recursive: true));
    final picked = await Directory('${root.path}/picked_videos').create();
    final thumbnails = await Directory(
      '${root.path}/minimo_thumbnails',
    ).create();
    final first = await File('${picked.path}/first.mp4').writeAsBytes([1, 2]);
    final second = await File('${picked.path}/second.mp4').writeAsBytes([3]);
    final thumbnail = await File(
      '${thumbnails.path}/preview.jpg',
    ).writeAsBytes([4, 5]);

    expect(await AppCacheService.size(root: root), 5);
    await AppCacheService.clear(root: root);
    expect(await first.exists(), isFalse);
    expect(await second.exists(), isFalse);
    expect(await thumbnail.exists(), isFalse);
  });
}
