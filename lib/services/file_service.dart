import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';

class PickedVideo {
  final String path;
  final String name;
  final int size;

  PickedVideo({required this.path, required this.name, required this.size});
}

class FileService {
  Future<List<PickedVideo>> pickVideos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
      withData: false,
    );
    if (result == null) return [];

    return result.files
        .where((file) => file.path != null)
        .map(
          (file) =>
              PickedVideo(path: file.path!, name: file.name, size: file.size),
        )
        .toList();
  }

  Future<void> saveToGallery(String filePath) async {
    await Gal.putVideo(filePath);
  }

  static String get tempOutputPath {
    final dir = Directory.systemTemp;
    return '${dir.path}/compressed_${DateTime.now().microsecondsSinceEpoch}.mp4';
  }
}
