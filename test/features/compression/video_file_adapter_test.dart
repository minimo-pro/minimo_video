import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/data/video_file_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('minimo_video/videos');

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'saveReplacement forwards source and returns metadata warnings',
    () async {
      MethodCall? received;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            received = call;
            return {
              'saved': true,
              'warnings': ['favorite_unavailable'],
            };
          });

      final result = await VideoFileAdapter().saveReplacement(
        '/compressed.mp4',
        'source-id',
        album: 'Minimo',
      );

      expect(received?.method, 'saveReplacement');
      expect(received?.arguments, {
        'path': '/compressed.mp4',
        'sourceIdentifier': 'source-id',
        'album': 'Minimo',
      });
      expect(result.warnings, ['favorite_unavailable']);
    },
  );
}
