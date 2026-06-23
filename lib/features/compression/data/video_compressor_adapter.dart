import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:v_video_compressor/v_video_compressor.dart';

import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';

class VideoCompressorAdapter {
  final VVideoCompressor _compressor;

  VideoCompressorAdapter({VVideoCompressor? compressor})
    : _compressor = compressor ?? VVideoCompressor();

  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    void Function(double progress)? onProgress,
  }) async {
    final outputPath = await _createOutputPath(originalName);
    final result = await _compressor.compressVideo(
      inputPath,
      _buildConfig(settings, outputPath),
      onProgress: onProgress,
    );

    if (result == null) {
      return const CompressionResult(success: false);
    }

    final compressedFile = File(result.compressedFilePath);
    final originalSize = result.originalSizeBytes > 0
        ? result.originalSizeBytes
        : await File(inputPath).length();
    final outputSize = result.compressedSizeBytes > 0
        ? result.compressedSizeBytes
        : await compressedFile.length();

    return CompressionResult(
      success: outputSize < originalSize,
      originalSize: originalSize,
      outputSize: outputSize,
      outputPath: outputSize < originalSize ? result.compressedFilePath : null,
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

  Future<String> _createOutputPath(String originalName) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final outputDirectory = Directory(
      path.join(temporaryDirectory.path, 'minimo_video'),
    );
    await outputDirectory.create(recursive: true);

    final originalBaseName = path.basenameWithoutExtension(originalName);
    final safeBaseName = originalBaseName
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final baseName = safeBaseName.isEmpty ? 'video' : safeBaseName;

    var candidate = path.join(outputDirectory.path, '${baseName}_minimo.mp4');
    var duplicateIndex = 2;
    while (await File(candidate).exists()) {
      candidate = path.join(
        outputDirectory.path,
        '${baseName}_minimo_$duplicateIndex.mp4',
      );
      duplicateIndex++;
    }
    return candidate;
  }

  VVideoCompressionConfig _buildConfig(
    CompressionSettings settings,
    String outputPath,
  ) {
    final (width, height) = _parseResolution(settings.resolution);

    return VVideoCompressionConfig(
      quality: _qualityForCrf(settings.crf),
      outputPath: outputPath,
      saveToGallery: false,
      includeAudio: settings.audioMode != CompressionAudioMode.remove,
      includeMetadata: settings.preserveMetadata,
      optimizeForStreaming: settings.optimizeForStreaming,
      copyMetadata: settings.preserveMetadata,
      useHardwareAcceleration: settings.hardwareAcceleration,
      useFastStart: true,
      useTwoPassEncoding: settings.twoPassEncoding,
      useVariableBitrate: true,
      advanced: VVideoAdvancedConfig(
        customWidth: width,
        customHeight: height,
        frameRate: settings.frameRate,
        videoCodec: settings.videoCodec == CompressionVideoCodec.h265
            ? VVideoCodec.h265
            : VVideoCodec.h264,
        audioCodec: VAudioCodec.aac,
        audioBitrate: settings.audioMode == CompressionAudioMode.mono
            ? 96000
            : 128000,
        audioChannels: settings.audioMode == CompressionAudioMode.mono ? 1 : 2,
        removeAudio: settings.audioMode == CompressionAudioMode.remove,
        monoAudio: settings.audioMode == CompressionAudioMode.mono,
        encodingSpeed: _encodingSpeedForPreset(settings.preset),
        crf: settings.crf.toInt(),
        hardwareAcceleration: settings.hardwareAcceleration,
        twoPassEncoding: settings.twoPassEncoding,
        variableBitrate: true,
        noiseReduction: settings.noiseReduction,
        autoCorrectOrientation: true,
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
      case 'veryslow':
        return VEncodingSpeed.veryslow;
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
