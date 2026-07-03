import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:v_video_compressor/v_video_compressor.dart';

import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';
import '../../../services/app_settings_service.dart';

class VideoCompressorAdapter {
  final VVideoCompressor _compressor;
  Future<void> _preparation = Future.value();
  var _cancelGeneration = 0;

  VideoCompressorAdapter({VVideoCompressor? compressor})
    : _compressor = compressor ?? VVideoCompressor();

  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    bool addKompressoPrefix = true,
    void Function(double progress)? onProgress,
  }) async {
    final cancelGeneration = _cancelGeneration;
    await _preparation;
    if (cancelGeneration != _cancelGeneration) {
      throw StateError('Video compression cancelled');
    }
    final outputPath = await _createOutputPath(
      originalName,
      addKompressoPrefix: addKompressoPrefix,
    );
    final result = await _compressor.compressVideo(
      inputPath,
      _buildConfig(settings, path.dirname(outputPath)),
      onProgress: onProgress,
    );

    if (result == null) {
      throw StateError('Video compression failed');
    }

    final compressedFile = File(result.compressedFilePath);
    final originalSize = result.originalSizeBytes > 0
        ? result.originalSizeBytes
        : await File(inputPath).length();
    final outputSize = result.compressedSizeBytes > 0
        ? result.compressedSizeBytes
        : await compressedFile.length();

    final success = outputSize < originalSize;
    final outputFile = success
        ? await _moveToOutputPath(compressedFile, outputPath)
        : null;

    return CompressionResult(
      success: success,
      originalSize: originalSize,
      outputSize: outputSize,
      outputPath: outputFile?.path,
      durationMs: result.timeTaken,
    );
  }

  Future<void> cancelCompression() {
    _cancelGeneration++;
    return _compressor.cancelCompression();
  }

  Future<int?> estimateCompressedSize(
    Iterable<String> inputPaths,
    CompressionSettings settings,
  ) {
    return _prepare(() async {
      var total = 0;
      for (final inputPath in inputPaths) {
        final info = await _compressor.getVideoInfo(inputPath);
        final estimate = await _compressor.getCompressionEstimate(
          inputPath,
          _qualityForCrf(settings.crf),
          advanced: _buildAdvancedConfig(settings),
        );
        if (estimate == null || info == null) return null;
        var estimatedSize = estimate.estimatedSizeBytes;
        if (Platform.isAndroid) {
          // ponytail: v2.0.0 calculates bitrate but does not apply it to Media3.
          // Remove this floor when the Android encoder starts applying bitrate.
          final floor = androidEstimateFloor(
            originalSize: info.fileSizeBytes,
            width: info.width,
            height: info.height,
            settings: settings,
          );
          if (floor > estimatedSize) estimatedSize = floor;
          if (estimatedSize > info.fileSizeBytes) {
            estimatedSize = info.fileSizeBytes;
          }
        }
        total += estimatedSize;
      }
      return total;
    });
  }

  static int androidEstimateFloor({
    required int originalSize,
    required int width,
    required int height,
    required CompressionSettings settings,
  }) {
    if (originalSize <= 0 || width <= 0 || height <= 0) return 0;
    final resolution =
        settings.resolution ??
        switch (_qualityForCrfStatic(settings.crf)) {
          VVideoCompressQuality.high => '1920:1080',
          VVideoCompressQuality.medium => '1280:720',
          VVideoCompressQuality.low => '854:480',
          VVideoCompressQuality.veryLow => '640:360',
          VVideoCompressQuality.ultraLow => '432:240',
        };
    final parts = resolution.split(':');
    if (parts.length != 2) return originalSize;
    final targetWidth = int.tryParse(parts[0]);
    final targetHeight = int.tryParse(parts[1]);
    if (targetWidth == null || targetHeight == null) return originalSize;
    final scale = [
      1.0,
      targetWidth / width,
      targetHeight / height,
    ].reduce((a, b) => a < b ? a : b);
    final qualityRatio = switch (_qualityForCrfStatic(settings.crf)) {
      VVideoCompressQuality.high => 0.96,
      VVideoCompressQuality.medium => 0.89,
      VVideoCompressQuality.low => 0.43,
      VVideoCompressQuality.veryLow => 0.32,
      VVideoCompressQuality.ultraLow => 0.24,
    };
    final resolutionRatio = math.pow(scale * scale, 0.02);
    return (originalSize * qualityRatio * resolutionRatio).round();
  }

  Future<String?> createThumbnail(String inputPath) {
    return _prepare(() async {
      final result = await _compressor.getVideoThumbnail(
        inputPath,
        const VVideoThumbnailConfig.defaults(maxWidth: 220, maxHeight: 220),
      );

      return result?.thumbnailPath;
    });
  }

  Future<T> _prepare<T>(Future<T> Function() task) {
    final result = _preparation.then((_) => task());
    _preparation = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  Future<String> _createOutputPath(
    String originalName, {
    required bool addKompressoPrefix,
  }) async {
    final temporaryDirectory = await getTemporaryDirectory();
    final outputDirectory = Directory(
      path.join(temporaryDirectory.path, 'minimo_video'),
    );
    await outputDirectory.create(recursive: true);

    final appPrefix = AppSettingsService.appPrefix;
    final rawBaseName = path.basenameWithoutExtension(originalName);
    final originalBaseName =
        addKompressoPrefix && rawBaseName.startsWith(appPrefix)
        ? rawBaseName.substring(appPrefix.length)
        : rawBaseName;
    final safeBaseName = originalBaseName
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final baseName = safeBaseName.isEmpty ? 'video' : safeBaseName;

    final prefix = addKompressoPrefix ? appPrefix : '';
    var candidate = path.join(outputDirectory.path, '$prefix$baseName.mp4');
    var duplicateIndex = 2;
    while (await FileSystemEntity.type(candidate) !=
        FileSystemEntityType.notFound) {
      candidate = path.join(
        outputDirectory.path,
        '$prefix${baseName}_$duplicateIndex.mp4',
      );
      duplicateIndex++;
    }
    return candidate;
  }

  Future<File> _moveToOutputPath(File file, String outputPath) async {
    if (file.path == outputPath) return file;
    return file.rename(outputPath);
  }

  VVideoCompressionConfig _buildConfig(
    CompressionSettings settings,
    String outputPath,
  ) {
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
      advanced: _buildAdvancedConfig(settings),
    );
  }

  VVideoAdvancedConfig _buildAdvancedConfig(CompressionSettings settings) {
    final (width, height) = _parseResolution(settings.resolution);
    return VVideoAdvancedConfig(
      customWidth: width,
      customHeight: height,
      frameRate: settings.frameRate,
      reducedFrameRate: settings.frameRate,
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
    );
  }

  VVideoCompressQuality _qualityForCrf(double crf) {
    return _qualityForCrfStatic(crf);
  }

  static VVideoCompressQuality _qualityForCrfStatic(double crf) {
    if (crf <= 22) return VVideoCompressQuality.high;
    if (crf <= 28) return VVideoCompressQuality.medium;
    if (crf <= 34) return VVideoCompressQuality.low;
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
