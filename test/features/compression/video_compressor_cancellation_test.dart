import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const compressorChannel = MethodChannel('light_compressor');
  const pathChannel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('minimo_cancel_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, (_) async => root.path);
  });
  tearDown(() async {
    for (final channel in [compressorChannel, pathChannel]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    }
    await root.delete(recursive: true);
  });

  test(
    'cancellation waits for native terminal result, not just cancel acknowledgement',
    () async {
      final started = Completer<void>();
      final terminal = Completer<String>();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(compressorChannel, (call) async {
            if (call.method == 'startCompression') {
              started.complete();
              return terminal.future;
            }
            return null;
          });
      final adapter = VideoCompressorAdapter();
      final result = expectLater(
        adapter.compress(
          '/input.mp4',
          'input.mp4',
          const CompressionSettings(),
        ),
        throwsStateError,
      );
      await started.future;
      var cancelled = false;
      final cancellation = adapter.cancelCompression().then(
        (_) => cancelled = true,
      );
      await Future<void>.delayed(Duration.zero);
      expect(cancelled, isFalse);
      terminal.complete('{"onCancelled":true}');
      await result;
      await cancellation;
      expect(cancelled, isTrue);
    },
  );

  test(
    'cancellation during media lookup never starts the native encoder',
    () async {
      final lookupStarted = Completer<void>();
      final releaseLookup = Completer<void>();
      var encoderCalls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(compressorChannel, (call) async {
            if (call.method == 'getMediaInfo') {
              lookupStarted.complete();
              await releaseLookup.future;
            }
            if (call.method == 'startCompression') encoderCalls++;
            return null;
          });
      final adapter = VideoCompressorAdapter();
      final result = expectLater(
        adapter.compress(
          '/input.mp4',
          'input.mp4',
          const CompressionSettings(),
        ),
        throwsStateError,
      );
      await lookupStarted.future;
      final cancellation = adapter.cancelCompression();
      releaseLookup.complete();
      await cancellation;
      await result;
      expect(encoderCalls, 0);
    },
  );
}
