import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/presentation/utils/compression_estimate.dart';

void main() {
  test('bitrate estimate includes video and audio', () {
    final estimate = VideoCompressorAdapter.estimateBytes(
      durationMs: 24000,
      videoBitrateMbps: 2,
      includeAudio: true,
    );

    expect(estimate / 1024 / 1024, closeTo(6.1, 0.1));
  });

  test('audio removal lowers bitrate estimate', () {
    final withAudio = VideoCompressorAdapter.estimateBytes(
      durationMs: 24000,
      videoBitrateMbps: 2,
      includeAudio: true,
    );
    final withoutAudio = VideoCompressorAdapter.estimateBytes(
      durationMs: 24000,
      videoBitrateMbps: 2,
      includeAudio: false,
    );

    expect(withoutAudio, lessThan(withAudio));
  });

  test('compressed output needs at least ten percent savings', () {
    expect(VideoCompressorAdapter.isUsefulCompression(1000, 900), isTrue);
    expect(VideoCompressorAdapter.isUsefulCompression(1000, 901), isFalse);
  });

  test('target resolution follows source orientation', () {
    expect(
      VideoCompressorAdapter.targetResolutionForSource(
        targetWidth: 1280,
        targetHeight: 720,
        sourceWidth: 1080,
        sourceHeight: 1920,
      ),
      (720, 1280),
    );
    expect(
      VideoCompressorAdapter.targetResolutionForSource(
        targetWidth: 1280,
        targetHeight: 720,
        sourceWidth: 1920,
        sourceHeight: 1080,
      ),
      (1280, 720),
    );
    expect(
      VideoCompressorAdapter.targetResolutionForSource(
        targetWidth: 1280,
        targetHeight: 720,
        sourceWidth: 1920,
        sourceHeight: 1080,
      ),
      (1280, 720),
    );
  });

  test('estimated size changes on every crf step', () {
    var previous = CompressionEstimate.compressedSize(
      originalSize: 1000000,
      settings: const CompressionSettings(crf: 18),
    );

    for (var crf = 19; crf <= 34; crf++) {
      final current = CompressionEstimate.compressedSize(
        originalSize: 1000000,
        settings: CompressionSettings(crf: crf.toDouble()),
      );

      expect(current, lessThan(previous));
      previous = current;
    }
  });
}
