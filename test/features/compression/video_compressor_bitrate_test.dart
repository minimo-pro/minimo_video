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
                'isHdr': true,
              },
              'getCompressionEstimate' => {'estimatedSizeBytes': 500},
              'startCompression' => jsonEncode({'onSuccess': output.path}),
              _ => null,
            };
          });
      final adapter = VideoCompressorAdapter();
      final settings = CompressionSettings(videoBitrateMbps: bitrate);
      final estimate = await adapter.estimateCompressedSize([
        input.path,
      ], settings);
      expect(estimate.bytes, 500);
      expect(estimate.hdrPaths, {input.path});
      final result = await adapter.compress(input.path, 'input.mp4', settings);
      expect(result.success, isTrue);
      expect(result.sourceIsHdr, isTrue);
      final expected = bitrate ?? 1.93536;
      for (final method in ['getCompressionEstimate', 'startCompression']) {
        final args =
            calls.singleWhere((call) => call.method == method).arguments as Map;
        expect(args['videoBitrateInMbps'], closeTo(expected, 1e-9));
      }
    });
  }

  test('detects later HDR videos when an earlier estimate fails', () async {
    final first = await File('${root.path}/first.mp4').writeAsBytes([1]);
    final hdr = await File('${root.path}/hdr.mp4').writeAsBytes([2]);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(compressorChannel, (call) async {
          final input = (call.arguments as Map)['path'];
          return switch (call.method) {
            'getMediaInfo' => {
              'width': 1920,
              'height': 1080,
              'isHdr': input == hdr.path,
            },
            'getCompressionEstimate' => throw PlatformException(
              code: 'ESTIMATE_FAILED',
            ),
            _ => null,
          };
        });

    final estimate = await VideoCompressorAdapter().estimateCompressedSize([
      first.path,
      hdr.path,
    ], const CompressionSettings());
    expect(estimate.bytes, isNull);
    expect(estimate.hdrPaths, {hdr.path});
  });
}
