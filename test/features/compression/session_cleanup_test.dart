import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_event.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/domain/compression_result.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';

class _Compressor extends VideoCompressorAdapter {
  final Directory root;
  final thumbnailStarted = Completer<void>();
  Completer<void>? releaseThumbnail;
  Completer<CompressionResult>? secondResult;
  final secondStarted = Completer<void>();
  int calls = 0;

  _Compressor(this.root);

  @override
  Future<int?> estimateCompressedSize(
    Iterable<String> inputPaths,
    CompressionSettings settings, {
    bool Function()? isCancelled,
  }) async => 10;

  @override
  Future<String?> createThumbnail(String inputPath) async {
    if (!thumbnailStarted.isCompleted) thumbnailStarted.complete();
    await releaseThumbnail?.future;
    final directory = await Directory(
      '${root.path}/minimo_thumbnails',
    ).create();
    return (await File('${directory.path}/preview.jpg').writeAsBytes([1])).path;
  }

  @override
  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    bool addKompressoPrefix = true,
    void Function(double)? onProgress,
  }) async {
    calls++;
    if (calls == 2 && secondResult != null) {
      secondStarted.complete();
      return secondResult!.future;
    }
    final directory = await Directory('${root.path}/minimo_video').create();
    final output = await File('${directory.path}/output.mp4').writeAsBytes([1]);
    return CompressionResult(
      success: true,
      originalSize: 100,
      outputSize: 1,
      outputPath: output.path,
    );
  }

  @override
  Future<void> cancelCompression() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  late File source;
  late _Compressor compressor;
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  setUp(() async {
    root = await Directory.systemTemp.createTemp('minimo_session_test');
    final directory = await Directory('${root.path}/picked_videos').create();
    source = await File('${directory.path}/input.mp4').writeAsBytes([1, 2]);
    compressor = _Compressor(root);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => root.path);
  });
  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await root.delete(recursive: true);
  });

  CompressBloc makeBloc({bool twoVideos = false}) => CompressBloc(
    initialVideos: [
      PickedVideo(path: source.path, name: 'input.mp4', size: 100),
      if (twoVideos)
        PickedVideo(path: source.path, name: 'second.mp4', size: 100),
    ],
    videoCompressorAdapter: compressor,
  );

  test(
    'keeps results open, then waits for sharing before session cleanup',
    () async {
      final bloc = makeBloc();
      await compressor.thumbnailStarted.future;
      bloc.add(const CompressStarted());
      await bloc.stream.firstWhere((s) => s.status == CompressStatus.done);
      final output = File(bloc.state.successfulOutputPaths.single);
      final thumbnail = File('${root.path}/minimo_thumbnails/preview.jpg');
      final other = await File(
        '${root.path}/picked_videos/other.mp4',
      ).writeAsBytes([1]);
      expect(await output.exists(), isTrue);
      final releaseShare = Completer<void>();
      final sharing = bloc.useFiles(() => releaseShare.future);
      var closed = false;
      final closing = bloc.close().then((_) => closed = true);
      await Future<void>.delayed(Duration.zero);
      expect(closed, isFalse);
      expect(await output.exists(), isTrue);
      releaseShare.complete();
      await sharing;
      await closing;
      expect(await source.exists(), isFalse);
      expect(await output.exists(), isFalse);
      expect(await thumbnail.exists(), isFalse);
      expect(await other.exists(), isTrue);
    },
  );

  test('waits for late thumbnail before removing session files', () async {
    compressor.releaseThumbnail = Completer<void>();
    final bloc = makeBloc();
    await compressor.thumbnailStarted.future;
    final closing = bloc.close();
    await Future<void>.delayed(Duration.zero);
    expect(await source.exists(), isTrue);
    compressor.releaseThumbnail!.complete();
    await closing;
    expect(await source.exists(), isFalse);
    expect(
      await File('${root.path}/minimo_thumbnails/preview.jpg').exists(),
      isFalse,
    );
  });

  test(
    'cancellation removes completed and late outputs but preserves retry sources',
    () async {
      compressor.secondResult = Completer<CompressionResult>();
      final bloc = makeBloc(twoVideos: true);
      bloc.add(const CompressStarted());
      await compressor.secondStarted.future;
      final completed = File(bloc.state.successfulOutputPaths.single);
      bloc.add(const CompressCancelled());
      await bloc.stream.firstWhere((s) => s.status == CompressStatus.ready);
      expect(await completed.exists(), isFalse);
      expect(await source.exists(), isTrue);
      final late = await File(
        '${root.path}/minimo_video/late.mp4',
      ).writeAsBytes([1]);
      compressor.secondResult!.complete(
        CompressionResult(
          success: true,
          originalSize: 100,
          outputSize: 1,
          outputPath: late.path,
        ),
      );
      await bloc.close();
      expect(await late.exists(), isFalse);
    },
  );
}
