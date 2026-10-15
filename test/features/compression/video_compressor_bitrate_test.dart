import 'dart:convert';
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
    root = await Directory.systemTemp.createTemp('minimo_bitrate_test');
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

  for (final bitrate in [1.5, null]) {
    test('native estimate and compression preserve bitrate $bitrate', () async {
      final input = await File(
        '${root.path}/input.mp4',
      ).writeAsBytes(List.filled(1000, 0));
      final output = await File(
        '${root.path}/encoded.mp4',
      ).writeAsBytes(List.filled(500, 0));
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(compressorChannel, (call) async {
            calls.add(call);
            return switch (call.method) {
              'getMediaInfo' => {
                'width': 1920,
                'height': 1080,
                'frameRate': 30.0,
              },
              'getCompressionEstimate' => {'estimatedSizeBytes': 500},
              'startCompression' => jsonEncode({'onSuccess': output.path}),
              _ => null,
            };
          });
      final adapter = VideoCompressorAdapter();
      final settings = CompressionSettings(videoBitrateMbps: bitrate);
      expect(await adapter.estimateCompressedSize([input.path], settings), 500);
      final result = await adapter.compress(input.path, 'input.mp4', settings);
      expect(result.success, isTrue);
      final expected = bitrate ?? 1.93536;
      for (final method in ['getCompressionEstimate', 'startCompression']) {
        final args =
            calls.singleWhere((call) => call.method == method).arguments as Map;
        expect(args['videoBitrateInMbps'], closeTo(expected, 1e-9));
      }
    });
  }
}
