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

  test('lower resolution lowers bitrate estimate', () {
    final originalResolution = VideoCompressorAdapter.estimateBytes(
      durationMs: 24000,
      videoBitrateMbps: 2,
      includeAudio: true,
    );
    final reducedResolution = VideoCompressorAdapter.estimateBytes(
      durationMs: 24000,
      videoBitrateMbps: 2,
      includeAudio: true,
      resolutionScale: const CompressionSettings(
        resolution: '854:480',
      ).resolutionEstimateScale,
    );

    expect(reducedResolution, lessThan(originalResolution));
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

  test('target resolution preserves non-standard source aspect ratio', () {
    expect(
      VideoCompressorAdapter.targetResolutionForSource(
        targetWidth: 1280,
        targetHeight: 720,
        sourceWidth: 2340,
        sourceHeight: 1080,
      ),
      (1280, 590),
    );
    expect(
      VideoCompressorAdapter.targetResolutionForSource(
        targetWidth: 1280,
        targetHeight: 720,
        sourceWidth: 1080,
        sourceHeight: 2340,
      ),
      (590, 1280),
    );
  });

  test('target resolution does not upscale smaller videos', () {
    expect(
      VideoCompressorAdapter.targetResolutionForSource(
        targetWidth: 1280,
        targetHeight: 720,
        sourceWidth: 640,
        sourceHeight: 360,
      ),
      (640, 360),
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
