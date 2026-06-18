import 'package:v_video_compressor/v_video_compressor.dart';

import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';

class VideoCompressorAdapter {
  final VVideoCompressor _compressor;

  VideoCompressorAdapter({VVideoCompressor? compressor})
    : _compressor = compressor ?? VVideoCompressor();

  Future<CompressionResult> compress(
    String inputPath,
    CompressionSettings settings, {
    void Function(double progress)? onProgress,
  }) async {
    final result = await _compressor.compressVideo(
      inputPath,
      _buildConfig(settings),
      onProgress: onProgress,
    );

    if (result == null) {
      return const CompressionResult(success: false);
    }

    return CompressionResult(
      success: true,
      outputSize: result.compressedSizeBytes,
      outputPath: result.compressedFilePath,
      durationMs: result.timeTaken,
    );
  }

  Future<void> cancelCompression() {
    return _compressor.cancelCompression();
  }

  Future<String?> createThumbnail(String inputPath) async {
    final result = await _compressor.getVideoThumbnail(
      inputPath,
      const VVideoThumbnailConfig.defaults(maxWidth: 220, maxHeight: 220),
    );

    return result?.thumbnailPath;
  }

  VVideoCompressionConfig _buildConfig(CompressionSettings settings) {
    final (width, height) = _parseResolution(settings.resolution);

    return VVideoCompressionConfig(
      quality: _qualityForCrf(settings.crf),
      saveToGallery: false,
      includeAudio: true,
      includeMetadata: true,
      optimizeForStreaming: true,
      copyMetadata: true,
      useHardwareAcceleration: true,
      useFastStart: true,
      useTwoPassEncoding: settings.preset == 'slow',
      useVariableBitrate: true,
      advanced: VVideoAdvancedConfig(
        customWidth: width,
        customHeight: height,
        audioCodec: VAudioCodec.aac,
        audioBitrate: 128000,
        encodingSpeed: _encodingSpeedForPreset(settings.preset),
        crf: settings.crf.toInt(),
        hardwareAcceleration: true,
        twoPassEncoding: settings.preset == 'slow',
        variableBitrate: true,
        dimensionHandling: VDimensionHandling.autoAlign,
      ),
    );
  }

  VVideoCompressQuality _qualityForCrf(double crf) {
    if (crf < 20) return VVideoCompressQuality.high;
    if (crf < 25) return VVideoCompressQuality.medium;
    if (crf < 31) return VVideoCompressQuality.low;
    return VVideoCompressQuality.veryLow;
  }

  VEncodingSpeed _encodingSpeedForPreset(String preset) {
    switch (preset) {
      case 'ultrafast':
        return VEncodingSpeed.ultrafast;
      case 'medium':
        return VEncodingSpeed.medium;
      case 'slow':
        return VEncodingSpeed.slow;
      case 'fast':
      default:
        return VEncodingSpeed.fast;
    }
  }

  (int?, int?) _parseResolution(String? resolution) {
    if (resolution == null) return (null, null);

    final parts = resolution.split(':');
    if (parts.length != 2) return (null, null);

    return (int.tryParse(parts[0]), int.tryParse(parts[1]));
  }
}
