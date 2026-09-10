class PickedVideo {
  final String path;
  final String name;
  final int size;
  final String? sourceIdentifier;
  final bool canPreserveMetadata;
  final bool canDeleteOriginal;
  final String? captureDate;
  final double? latitude;
  final double? longitude;

  const PickedVideo({
    required this.path,
    required this.name,
    required this.size,
    this.sourceIdentifier,
    this.canPreserveMetadata = false,
    this.canDeleteOriginal = false,
    this.captureDate,
    this.latitude,
    this.longitude,
  });
}
