import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_event.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/data/video_file_adapter.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/domain/compression_result.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';

class _FailingCompressor extends VideoCompressorAdapter {
  @override
  Future<String?> createThumbnail(String inputPath) async => null;

  @override
  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    bool addKompressoPrefix = true,
    void Function(double progress)? onProgress,
  }) async {
    throw StateError('encoder failed');
  }
}

class _EstimatingCompressor extends VideoCompressorAdapter {
  @override
  Future<String?> createThumbnail(String inputPath) async => null;

  @override
  Future<int?> estimateCompressedSize(
    Iterable<String> inputPaths,
    CompressionSettings settings,
  ) async => 15;
}

class _MixedCompressor extends VideoCompressorAdapter {
  @override
  Future<String?> createThumbnail(String inputPath) async => null;

  @override
  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    bool addKompressoPrefix = true,
    void Function(double progress)? onProgress,
  }) async {
    onProgress?.call(1);
    return inputPath.contains('ok')
        ? const CompressionResult(
            success: true,
            originalSize: 100,
            outputSize: 40,
            outputPath: '/ok-small.mp4',
          )
        : const CompressionResult(
            success: false,
            originalSize: 100,
            outputSize: 100,
          );
  }
}

class _ControlledCompressor extends VideoCompressorAdapter {
  final completer = Completer<CompressionResult>();
  var cancelCalls = 0;

  @override
  Future<String?> createThumbnail(String inputPath) async => null;

  @override
  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    bool addKompressoPrefix = true,
    void Function(double progress)? onProgress,
  }) {
    return completer.future;
  }

  @override
  Future<void> cancelCompression() async => cancelCalls++;
}

class _WeightedProgressCompressor extends VideoCompressorAdapter {
  final firstResult = Completer<CompressionResult>();
  void Function(double progress)? firstProgress;
  var calls = 0;

  @override
  Future<String?> createThumbnail(String inputPath) async => null;

  @override
  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    bool addKompressoPrefix = true,
    void Function(double progress)? onProgress,
  }) {
    calls++;
    if (calls == 1) {
      firstProgress = onProgress;
      return firstResult.future;
    }
    return Future.value(const CompressionResult(success: false));
  }
}

class _StaleProgressCompressor extends VideoCompressorAdapter {
  void Function(double progress)? staleProgress;
  final secondRun = Completer<CompressionResult>();
  var calls = 0;

  @override
  Future<String?> createThumbnail(String inputPath) async => null;

  @override
  Future<CompressionResult> compress(
    String inputPath,
    String originalName,
    CompressionSettings settings, {
    bool addKompressoPrefix = true,
    void Function(double progress)? onProgress,
  }) {
    calls++;
    if (calls == 1) {
      staleProgress = onProgress;
      return Future.value(
        const CompressionResult(
          success: true,
          originalSize: 100,
          outputSize: 40,
          outputPath: '/small.mp4',
        ),
      );
    }
    return secondRun.future;
  }
}

class _SavingFileAdapter extends VideoFileAdapter {
  List<String> deletedIdentifiers = const [];

  @override
  Future<void> saveToGallery(String filePath, {String? album}) async {}

  @override
  Future<int> deleteOriginals(Iterable<String> sourceIdentifiers) async {
    deletedIdentifiers = sourceIdentifiers.toList();
    return deletedIdentifiers.length;
  }
}

void main() {
  test('quality presets select expected bitrate tier and resolution', () async {
    final bloc = CompressBloc(videoCompressorAdapter: _EstimatingCompressor());

    for (final (quality, crf, resolution) in [
      (SimpleCompressionQuality.high, 22.0, null),
      (SimpleCompressionQuality.medium, 28.0, '1280:720'),
      (SimpleCompressionQuality.low, 34.0, '854:480'),
    ]) {
      bloc.add(CompressSimpleQualityChanged(quality));
      await bloc.stream.firstWhere(
        (state) =>
            state.settings.crf == crf &&
            state.settings.resolution == resolution,
      );
    }

    await bloc.close();
  });

  test(
    'cancelling active compression resets state and calls compressor',
    () async {
      final compressor = _ControlledCompressor();
      final bloc = CompressBloc(
        initialVideos: const [
          PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 100),
        ],
        videoCompressorAdapter: compressor,
      );

      bloc.add(const CompressStarted());
      await bloc.stream.firstWhere(
        (state) => state.status == CompressStatus.processing,
      );
      bloc.add(const CompressCancelled());
      await bloc.stream.firstWhere(
        (state) => state.status == CompressStatus.ready,
      );

      expect(compressor.cancelCalls, 1);
      expect(bloc.state.progress, 0);
      expect(bloc.state.results, isEmpty);
      expect(bloc.state.videoStatuses, const [VideoCompressionStatus.waiting]);

      compressor.completer.complete(const CompressionResult(success: false));
      await bloc.close();
    },
  );

  test('deletes successful originals through platform identifiers', () async {
    final files = _SavingFileAdapter();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/ok.mp4',
          name: 'video.mp4',
          size: 100,
          sourceIdentifier: 'photos-id',
        ),
      ],
      videoFileAdapter: files,
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );
    bloc.add(const CompressResultsSaved(deleteOriginals: true));
    await bloc.stream.firstWhere((state) => state.deletedOriginalCount == 1);

    expect(files.deletedIdentifiers, ['photos-id']);
    await bloc.close();
  });

  test('uses platform compression estimate', () async {
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 17),
      ],
      videoCompressorAdapter: _EstimatingCompressor(),
    );

    await expectLater(
      bloc.stream,
      emitsThrough(
        predicate<CompressState>((state) => state.estimatedSize == 15),
      ),
    );
    await bloc.close();
  });

  test('no-saving results are not treated as compressed videos', () {
    final state = CompressState.initial(const []).copyWith(
      results: const [
        CompressedVideo(
          source: PickedVideo(path: '/same.mp4', name: 'same.mp4', size: 100),
          result: CompressionResult(
            success: false,
            originalSize: 100,
            outputSize: 100,
          ),
        ),
      ],
    );

    expect(state.successResults, isEmpty);
    expect(state.successfulOutputPaths, isEmpty);
  });

  test('saved size only compares successfully compressed videos', () {
    final state = CompressState.initial(const []).copyWith(
      results: const [
        CompressedVideo(
          source: PickedVideo(path: '/ok.mp4', name: 'ok.mp4', size: 100),
          result: CompressionResult(
            success: true,
            originalSize: 0,
            outputSize: 40,
          ),
        ),
        CompressedVideo(
          source: PickedVideo(
            path: '/failed.mp4',
            name: 'failed.mp4',
            size: 500,
          ),
          result: CompressionResult(success: false),
        ),
      ],
    );

    expect(state.resultsOriginalSize - state.compressedSize, 60);
  });

  test('processing display progress hides stale 100 before first result', () {
    final state = CompressState.initial(const [
      PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 100),
    ]).copyWith(status: CompressStatus.processing, progress: 1);

    expect(state.displayProgress, 0);
  });

  test('compression errors finish with a failed result', () async {
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 100),
      ],
      videoCompressorAdapter: _FailingCompressor(),
    );

    bloc.add(const CompressStarted());
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<CompressState>()
            .having((state) => state.status, 'status', CompressStatus.done)
            .having((state) => state.successResults, 'successResults', isEmpty)
            .having(
              (state) => state.compressionError,
              'compressionError',
              isNotNull,
            )
            .having((state) => state.videoStatuses, 'videoStatuses', const [
              VideoCompressionStatus.failed,
            ]),
      ),
    );
    await bloc.close();
  });

  test('mixed compression keeps per-video statuses', () async {
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/ok.mp4', name: 'ok.mp4', size: 100),
        PickedVideo(path: '/same.mp4', name: 'same.mp4', size: 100),
      ],
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<CompressState>()
            .having((state) => state.status, 'status', CompressStatus.done)
            .having((state) => state.progress, 'progress', 1)
            .having((state) => state.videoStatuses, 'videoStatuses', const [
              VideoCompressionStatus.compressed,
              VideoCompressionStatus.skipped,
            ]),
      ),
    );
    await bloc.close();
  });

  test('current video status changes while compression is running', () async {
    final compressor = _ControlledCompressor();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 100),
      ],
      videoCompressorAdapter: compressor,
    );

    bloc.add(const CompressStarted());
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<CompressState>().having(
          (state) => state.videoStatuses,
          'videoStatuses',
          const [VideoCompressionStatus.processing],
        ),
      ),
    );

    compressor.completer.complete(
      const CompressionResult(
        success: true,
        originalSize: 100,
        outputSize: 40,
        outputPath: '/small.mp4',
      ),
    );
    await bloc.close();
  });

  test('stale progress from previous run is ignored', () async {
    final compressor = _StaleProgressCompressor();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 100),
      ],
      videoCompressorAdapter: compressor,
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) =>
          state.status == CompressStatus.processing &&
          state.compressionRunId == 2,
    );

    expect(bloc.state.progress, 0);
    compressor.staleProgress?.call(0.8);
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.progress, 0);

    compressor.secondRun.complete(
      const CompressionResult(
        success: true,
        originalSize: 100,
        outputSize: 40,
        outputPath: '/small-2.mp4',
      ),
    );
    await bloc.close();
  });

  test('overall progress is weighted by video size', () async {
    final compressor = _WeightedProgressCompressor();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/small.mp4', name: 'small.mp4', size: 100),
        PickedVideo(path: '/large.mp4', name: 'large.mp4', size: 300),
      ],
      videoCompressorAdapter: compressor,
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.processing,
    );
    compressor.firstProgress?.call(0.5);
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.progress, 0.125);
    compressor.firstProgress?.call(0.25);
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.progress, 0.125);
    compressor.firstResult.complete(const CompressionResult(success: false));
    await bloc.close();
  });
}
