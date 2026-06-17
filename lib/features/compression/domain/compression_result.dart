class CompressionResult {
  final bool success;
  final int? outputSize;
  final String? outputPath;
  final int? durationMs;

  const CompressionResult({
    required this.success,
    this.outputSize,
    this.outputPath,
    this.durationMs,
  });
}
