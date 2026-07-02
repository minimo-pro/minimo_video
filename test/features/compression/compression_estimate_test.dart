import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/presentation/utils/compression_estimate.dart';

void main() {
  test('Android estimate stays conservative when resolution is unchanged', () {
    final estimate = VideoCompressorAdapter.androidEstimateFloor(
      originalSize: 17 * 1024 * 1024,
      width: 1280,
      height: 720,
      settings: const CompressionSettings(),
    );

    expect(estimate / 1024 / 1024, closeTo(15.1, 0.1));
  });

  test('Android simple quality presets produce different estimates', () {
    final estimates =
        [
              const CompressionSettings(crf: 22, resolution: null),
              const CompressionSettings(crf: 28, resolution: '1280:720'),
              const CompressionSettings(crf: 34, resolution: '854:480'),
            ]
            .map(
              (settings) => VideoCompressorAdapter.androidEstimateFloor(
                originalSize: 17 * 1024 * 1024,
                width: 1920,
                height: 1080,
                settings: settings,
              ),
            )
            .toList();

    expect(estimates.toSet(), hasLength(3));
    expect(estimates[0] / 1024 / 1024, closeTo(16.3, 0.1));
    expect(estimates[1] / 1024 / 1024, closeTo(14.9, 0.1));
    expect(estimates[2] / 1024 / 1024, closeTo(7.1, 0.1));
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
