import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';

import '../domain/picked_video.dart';

class VideoFileAdapter {
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

  Future<bool> deleteFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return false;
    await file.delete();
    return true;
  }
}
