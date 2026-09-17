import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/services/external_video_import_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('minimo_video/external_videos');

  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test(
    'maps external files and shortcut preset without delete capability',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (_) async => {
              'preset': 'high',
              'files': [
                {'path': '/shared.mov', 'name': 'shared.mov', 'size': 42},
              ],
            },
          );

      final request = await ExternalVideoImportService().consume();

      expect(request?.settings.simpleQuality, SimpleCompressionQuality.high);
      expect(request?.videos.single.path, '/shared.mov');
      expect(request?.videos.single.canDeleteOriginal, isFalse);
      expect(request?.videos.single.canPreserveMetadata, isFalse);
    },
  );
}
