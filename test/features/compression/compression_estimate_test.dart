import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/presentation/utils/compression_estimate.dart';
import 'package:light_compressor_v2/light_compressor_v2.dart' as light;

void main() {
  test('custom bitrate overrides preset estimate', () {
    final automatic = CompressionEstimate.compressedSize(
      originalSize: 100000000,
      settings: const CompressionSettings(crf: 28),
    );
    final custom = CompressionEstimate.compressedSize(
      originalSize: 100000000,
      settings: const CompressionSettings(crf: 28, videoBitrateMbps: 1),
    );

    expect(custom, lessThan(automatic));
  });

  test('advanced codec and frame rate survive other setting changes', () {
    final settings = const CompressionSettings(
      frameRate: 24,
      codec: CompressionCodec.hevc,
    ).copyWith(audioMode: CompressionAudioMode.remove);

    expect(settings.frameRate, 24);
    expect(settings.codec, CompressionCodec.hevc);
  });

  test('encode plan forwards bitrate, frame rate, and HEVC', () {
    final plan = VideoCompressorAdapter.encodePlan(
      const CompressionSettings(
        crf: 22,
        videoBitrateMbps: 6,
        frameRate: 24,
        codec: CompressionCodec.hevc,
      ),
    );

    expect(plan.quality, light.VideoQuality.very_high);
    expect(plan.bitrateMbps, 6);
    expect(plan.frameRate, 24);
    expect(plan.format, light.VideoFormat.h265);
  });

  test('encode plan maps automatic bitrate from simple quality', () {
    final plan = VideoCompressorAdapter.encodePlan(
      const CompressionSettings(crf: 28),
    );

    expect(plan.bitrateMbps, 2);
    expect(plan.format, light.VideoFormat.h264);
  });

  test('automatic bitrate follows resolution, frame rate, and codec', () {
    int bitrate(CompressionSettings settings) =>
        VideoCompressorAdapter.encodePlan(settings).bitrateMbps;

    const h264720 = CompressionSettings(resolution: '1280:720', frameRate: 30);

    expect(
      bitrate(
        const CompressionSettings(resolution: '1920:1080', frameRate: 30),
      ),
      greaterThan(bitrate(h264720)),
    );
    expect(
      bitrate(const CompressionSettings(resolution: '1280:720', frameRate: 60)),
      greaterThan(bitrate(h264720)),
    );
    expect(
      bitrate(
        const CompressionSettings(
          resolution: '1280:720',
          frameRate: 30,
          codec: CompressionCodec.hevc,
        ),
      ),
      lessThan(bitrate(h264720)),
    );

    final source30 = VideoCompressorAdapter.encodePlan(
      const CompressionSettings(resolution: '1280:720', frameRate: 60),
      sourceFrameRate: 30,
    );
    expect(source30.bitrateMbps, bitrate(h264720));

    final original4k = VideoCompressorAdapter.encodePlan(
      const CompressionSettings(resolution: null),
      outputWidth: 3840,
      outputHeight: 2160,
      sourceFrameRate: 30,
    );
    expect(original4k.bitrateMbps, 8);
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
