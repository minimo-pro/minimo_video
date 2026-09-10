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

  test('pickVideos maps private-picker metadata capabilities', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'pickVideos');
          return [
            {
              'path': '/private.mov',
              'name': 'private.mov',
              'size': 42,
              'sourceIdentifier': 'private-id',
              'canPreserveMetadata': true,
              'canDeleteOriginal': false,
              'captureDate': '2026-09-10T08:00:00Z',
              'latitude': 37.3317,
              'longitude': -122.0301,
            },
          ];
        });

    final videos = await VideoFileAdapter().pickVideos();

    expect(videos, hasLength(1));
    expect(videos.single.canPreserveMetadata, isTrue);
    expect(videos.single.canDeleteOriginal, isFalse);
    expect(videos.single.captureDate, '2026-09-10T08:00:00Z');
    expect(videos.single.latitude, 37.3317);
    expect(videos.single.longitude, -122.0301);
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
        captureDate: '2026-09-10T08:00:00Z',
        latitude: 37.3317,
        longitude: -122.0301,
      );

      expect(received?.method, 'saveReplacement');
      expect(received?.arguments, {
        'path': '/compressed.mp4',
        'sourceIdentifier': 'source-id',
        'album': 'Minimo',
        'captureDate': '2026-09-10T08:00:00Z',
        'latitude': 37.3317,
        'longitude': -122.0301,
      });
      expect(result.warnings, ['favorite_unavailable']);
    },
  );
}
