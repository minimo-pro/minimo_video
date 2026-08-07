class PickedVideo {
  final String path;
  final String name;
  final int size;
  final String? sourceIdentifier;
  final bool canDeleteOriginal;

  const PickedVideo({
    required this.path,
    required this.name,
    required this.size,
    this.sourceIdentifier,
    this.canDeleteOriginal = false,
  });
}
