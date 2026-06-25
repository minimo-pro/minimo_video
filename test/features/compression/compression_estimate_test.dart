import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/presentation/utils/compression_estimate.dart';

void main() {
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
