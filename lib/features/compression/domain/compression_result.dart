import 'compression_settings.dart';

class CompressionResult {
  final bool success;
  final int? originalSize;
  final int? outputSize;
  final String? outputPath;
  final int? durationMs;
  final CompressionCodec? usedCodec;

  const CompressionResult({
    required this.success,
    this.originalSize,
    this.outputSize,
    this.outputPath,
    this.durationMs,
    this.usedCodec,
  });
}
