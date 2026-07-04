import 'dart:io';

import 'package:flutter/services.dart';
import 'package:light_compressor_v2/light_compressor_v2.dart' as light;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../domain/compression_result.dart';
import '../domain/compression_settings.dart';
import '../../../services/app_settings_service.dart';

class VideoCompressorAdapter {
  static const _channel = MethodChannel('minimo_video/videos');
  final light.LightCompressor _compressor = light.LightCompressor();
  Future<void> _preparation = Future.value();
  var _cancelGeneration = 0;

  VideoCompressorAdapter();

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
    return _compress(inputPath, outputPath, settings, onProgress: onProgress);
  }

  Future<void> cancelCompression() async {
    _cancelGeneration++;
    await _compressor.cancelCompression();
  }

  Future<CompressionResult> _compress(
    String inputPath,
    String outputPath,
    CompressionSettings settings, {
    void Function(double progress)? onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    final (width, height) = _parseResolution(settings.resolution);
    final progress = onProgress == null
        ? null
        : _compressor.onProgressUpdated.listen(
            (value) => onProgress((value / 100).clamp(0, 1)),
          );

    try {
      final result = await _compressor.compressVideo(
        path: inputPath,
        videoQuality: _quality(settings.crf),
        isMinBitrateCheckEnabled: false,
        disableAudio: settings.audioMode == CompressionAudioMode.remove,
        video: light.Video(
          videoName: path.basenameWithoutExtension(outputPath),
          keepOriginalResolution: settings.resolution == null,
          videoBitrateInMbps: _bitrateMbps(settings.crf),
          videoWidth: width,
          videoHeight: height,
        ),
        android: light.AndroidConfig(isSharedStorage: false),
        ios: light.IOSConfig(saveInGallery: false),
      );
      if (result is light.OnFailure) throw StateError(result.message);
      if (result is light.OnCancelled) {
        throw StateError('Video compression cancelled');
      }
      if (result is! light.OnSuccess) {
        throw StateError('Video compression failed');
      }

      final originalSize = await File(inputPath).length();
      final outputFile = File(result.destinationPath);
      final outputSize = await outputFile.length();
      final success = isUsefulCompression(originalSize, outputSize);
      final savedFile = success
          ? await _moveToOutputPath(outputFile, outputPath)
          : null;
      if (!success) await outputFile.delete();
      return CompressionResult(
        success: success,
        originalSize: originalSize,
        outputSize: outputSize,
        outputPath: savedFile?.path,
        durationMs: stopwatch.elapsedMilliseconds,
      );
    } finally {
      await progress?.cancel();
    }
  }

  Future<int?> estimateCompressedSize(
    Iterable<String> inputPaths,
    CompressionSettings settings,
  ) {
    return _prepare(() async {
      try {
        var total = 0;
        for (final inputPath in inputPaths) {
          final info = await _channel.invokeMapMethod<String, dynamic>(
            'videoInfo',
            inputPath,
          );
          final durationMs = info?['durationMs'] as int?;
          if (durationMs == null) return null;
          final originalSize = await File(inputPath).length();
          final estimate = estimateBytes(
            durationMs: durationMs,
            videoBitrateMbps: _bitrateMbps(settings.crf),
            includeAudio: settings.audioMode != CompressionAudioMode.remove,
          );
          total += estimate.clamp(0, originalSize);
        }
        return total;
      } catch (_) {
        return null;
      }
    });
  }

  static int estimateBytes({
    required int durationMs,
    required int videoBitrateMbps,
    required bool includeAudio,
  }) {
    final bitrate = videoBitrateMbps * 1000000 + (includeAudio ? 128000 : 0);
    return (bitrate * durationMs / 8000).round();
  }

  static bool isUsefulCompression(int originalSize, int outputSize) {
    return outputSize * 10 <= originalSize * 9;
  }

  Future<String?> createThumbnail(String inputPath) {
    return _prepare(() async {
      try {
        return await _channel.invokeMethod<String>(
          'createThumbnail',
          inputPath,
        );
      } catch (_) {
        return null;
      }
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

  static light.VideoQuality _quality(double crf) {
    if (crf <= 22) return light.VideoQuality.very_high;
    if (crf <= 28) return light.VideoQuality.medium;
    if (crf <= 34) return light.VideoQuality.low;
    return light.VideoQuality.very_low;
  }

  static int _bitrateMbps(double crf) {
    if (crf <= 22) return 4;
    if (crf <= 28) return 2;
    return 1;
  }

  static (int?, int?) _parseResolution(String? resolution) {
    if (resolution == null) return (null, null);

    final parts = resolution.split(':');
    if (parts.length != 2) return (null, null);

    return (int.tryParse(parts[0]), int.tryParse(parts[1]));
  }
}
