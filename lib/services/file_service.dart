import 'dart:io';

import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

class PickedVideo {
  final String path;
  final String name;
  final int size;

  PickedVideo({required this.path, required this.name, required this.size});
}

class FileService {
  final _picker = ImagePicker();

  Future<PickedVideo?> pickVideo() async {
    final xfile = await _picker.pickVideo(source: ImageSource.gallery);
    if (xfile == null) return null;

    final size = await xfile.length();
    return PickedVideo(path: xfile.path, name: xfile.name, size: size);
  }

  Future<void> saveToGallery(String filePath) async {
    await Gal.putVideo(filePath);
  }

  static String get tempOutputPath {
    final dir = Directory.systemTemp;
    return '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.mp4';
  }
}
