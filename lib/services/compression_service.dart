import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

class CompressionResult {
  final bool success;
  final int? outputSize;
  final String? outputPath;
  final int? durationMs;

  CompressionResult({
    required this.success,
    this.outputSize,
    this.outputPath,
    this.durationMs,
  });
}

class CompressionService {
  Future<CompressionResult> execute(String command, String outputPath) async {
    final completer = Completer<CompressionResult>();

    await FFmpegKit.executeAsync(
      command,
      (session) async {
        final returnCode = await session.getReturnCode();
        final success = ReturnCode.isSuccess(returnCode);
        final duration = await session.getDuration();

        int? size;
        if (success) {
          final file = File(outputPath);
          if (file.existsSync()) size = file.lengthSync();
        }

        if (!completer.isCompleted) {
          completer.complete(CompressionResult(
            success: success,
            outputSize: size,
            outputPath: outputPath,
            durationMs: duration,
          ));
        }
      },
      (log) {},
      (statistics) {},
    );

    return completer.future;
  }
}
