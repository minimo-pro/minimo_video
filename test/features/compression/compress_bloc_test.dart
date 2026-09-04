import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_event.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
import 'package:minimo_video/features/compression/data/video_file_adapter.dart';
import 'package:minimo_video/features/compression/data/video_compressor_adapter.dart';
import 'package:minimo_video/features/compression/domain/compression_result.dart';
import 'package:minimo_video/features/compression/domain/compression_settings.dart';
import 'package:minimo_video/features/compression/domain/picked_video.dart';
import 'package:minimo_video/services/app_settings_service.dart';
import 'package:minimo_video/services/screen_awake_service.dart';

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
    CompressionSettings settings, {
    bool Function()? isCancelled,
  }) async => 15;
}

class _QueuedEstimatingCompressor extends VideoCompressorAdapter {
  final firstStarted = Completer<void>();
  final releaseFirst = Completer<void>();
  final releaseUncancelled = Completer<void>();
  Future<void> _tail = Future.value();
  var calls = 0;

  @override
  Future<int?> estimateCompressedSize(
    Iterable<String> inputPaths,
    CompressionSettings settings, {
    bool Function()? isCancelled,
  }) async {
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    await previous;
    try {
      calls++;
      if (calls == 1) {
        firstStarted.complete();
        await releaseFirst.future;
        if (isCancelled?.call() != true) await releaseUncancelled.future;
      }
      return settings.crf.round();
    } finally {
      done.complete();
    }
  }

  void unblock() {
    if (!releaseUncancelled.isCompleted) releaseUncancelled.complete();
  }
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

class _IosRecoveryCompressor extends VideoCompressorAdapter {
  final interrupted = Completer<CompressionResult>();
  final calls = <String>[];
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
    calls.add(inputPath);
    if (calls.length == 2) return interrupted.future;
    return Future.value(
      CompressionResult(
        success: true,
        originalSize: 100,
        outputSize: 40,
        outputPath: '$inputPath-small.mp4',
      ),
    );
  }

  @override
  Future<void> cancelCompression() async {
    cancelCalls++;
    interrupted.complete(const CompressionResult(success: false));
  }
}

class _SavingFileAdapter extends VideoFileAdapter {
  List<String> deletedIdentifiers = const [];
  final calls = <String>[];

  @override
  Future<void> saveToGallery(String filePath, {String? album}) async {
    calls.add('save:$filePath');
  }

  @override
  Future<GallerySaveResult> saveReplacement(
    String filePath,
    String sourceIdentifier, {
    String? album,
  }) async {
    calls.add('replace:$sourceIdentifier');
    return const GallerySaveResult();
  }

  @override
  Future<int> deleteOriginals(Iterable<String> sourceIdentifiers) async {
    deletedIdentifiers = sourceIdentifiers.toList();
    calls.add('delete:${deletedIdentifiers.join(',')}');
    return deletedIdentifiers.length;
  }
}

class _FailingSaveFileAdapter extends _SavingFileAdapter {
  @override
  Future<GallerySaveResult> saveReplacement(
    String filePath,
    String sourceIdentifier, {
    String? album,
  }) async {
    throw StateError('gallery unavailable');
  }
}

class _WarningSaveFileAdapter extends _SavingFileAdapter {
  @override
  Future<GallerySaveResult> saveReplacement(
    String filePath,
    String sourceIdentifier, {
    String? album,
  }) async {
    calls.add('replace:$sourceIdentifier');
    return const GallerySaveResult(warnings: ['favorite_unavailable']);
  }
}

class _UnavailableAfterDeleteFileAdapter extends _SavingFileAdapter {
  @override
  Future<GallerySaveResult> saveReplacement(
    String filePath,
    String sourceIdentifier, {
    String? album,
  }) async {
    if (calls.any((call) => call.startsWith('replace:'))) {
      throw PlatformException(
        code: 'save_failed',
        message: 'original Photos asset is unavailable',
      );
    }
    return super.saveReplacement(filePath, sourceIdentifier, album: album);
  }
}

class _FakeScreenAwakeService extends ScreenAwakeService {
  final calls = <bool>[];

  @override
  Future<void> setEnabled(bool enabled) async {
    calls.add(enabled);
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

  test('adds picked videos while keeping compression settings', () async {
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/one.mp4', name: 'one.mp4', size: 100),
      ],
      videoCompressorAdapter: _EstimatingCompressor(),
    );

    bloc.add(
      const CompressSettingsChanged(
        CompressionSettings(
          crf: 34,
          resolution: '854:480',
          audioMode: CompressionAudioMode.remove,
        ),
      ),
    );
    await bloc.stream.firstWhere(
      (state) => state.settings.audioMode == CompressionAudioMode.remove,
    );

    bloc.add(
      const CompressVideosAdded([
        PickedVideo(path: '/two.mp4', name: 'two.mp4', size: 200),
        PickedVideo(path: '/three.mp4', name: 'three.mp4', size: 300),
      ]),
    );
    await bloc.stream.firstWhere((state) => state.videos.length == 3);

    expect(bloc.state.videos.map((video) => video.name), [
      'one.mp4',
      'two.mp4',
      'three.mp4',
    ]);
    expect(bloc.state.thumbnailPaths, hasLength(3));
    expect(bloc.state.videoStatuses, [
      VideoCompressionStatus.waiting,
      VideoCompressionStatus.waiting,
      VideoCompressionStatus.waiting,
    ]);
    expect(bloc.state.settings.resolution, '854:480');
    expect(bloc.state.settings.audioMode, CompressionAudioMode.remove);

    await bloc.close();
  });

  test('does not add videos already present in the batch', () async {
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/cached/original.mp4',
          name: 'original.mp4',
          size: 100,
          sourceIdentifier: 'gallery-id',
        ),
        PickedVideo(
          path: '/cached/document.mov',
          name: 'document.mov',
          size: 200,
        ),
      ],
      videoCompressorAdapter: _EstimatingCompressor(),
    );

    bloc.add(
      const CompressVideosAdded([
        PickedVideo(
          path: '/cached/original_2.mp4',
          name: 'original.mp4',
          size: 100,
          sourceIdentifier: 'gallery-id',
        ),
        PickedVideo(
          path: '/cached/document_2.mov',
          name: 'document.mov',
          size: 200,
        ),
        PickedVideo(
          path: '/cached/new-document.mov',
          name: 'document.mov',
          size: 300,
        ),
      ]),
    );
    await bloc.stream.firstWhere((state) => state.videos.length != 2);

    expect(bloc.state.videos.map((video) => video.path), [
      '/cached/original.mp4',
      '/cached/document.mov',
      '/cached/new-document.mov',
    ]);

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

  test('iOS background recovery retries only the interrupted video', () async {
    final compressor = _IosRecoveryCompressor();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/one.mp4', name: 'one.mp4', size: 100),
        PickedVideo(path: '/two.mp4', name: 'two.mp4', size: 100),
      ],
      videoCompressorAdapter: compressor,
    );

    bloc.add(const CompressStarted());
    while (compressor.calls.length < 2) {
      await Future<void>.delayed(Duration.zero);
    }
    bloc.add(const CompressBackgrounded());
    while (compressor.cancelCalls < 1) {
      await Future<void>.delayed(Duration.zero);
    }
    bloc.add(const CompressForegroundResumed());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );

    expect(compressor.calls, ['/one.mp4', '/two.mp4', '/two.mp4']);
    expect(compressor.cancelCalls, 1);
    expect(bloc.state.results, hasLength(2));
    await bloc.close();
  });

  test('deletes successful originals through platform identifiers', () async {
    final files = _SavingFileAdapter();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/ok.mp4',
          name: 'video.mp4',
          size: 100,
          sourceIdentifier: 'photos-id',
          canDeleteOriginal: true,
        ),
      ],
      videoFileAdapter: files,
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );
    bloc.add(
      const CompressResultsSaved(
        preserveMetadataSourceIdentifiers: {'photos-id'},
        deleteSourceIdentifiers: {'photos-id'},
      ),
    );
    await bloc.stream.firstWhere((state) => state.deletedOriginalCount == 1);

    expect(files.deletedIdentifiers, ['photos-id']);
    expect(files.calls, ['replace:photos-id', 'delete:photos-id']);
    await bloc.close();
  });

  test('preserves metadata without deleting the original', () async {
    final files = _SavingFileAdapter();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/ok.mp4',
          name: 'video.mp4',
          size: 100,
          sourceIdentifier: 'photos-id',
          canDeleteOriginal: true,
        ),
      ],
      videoFileAdapter: files,
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );
    bloc.add(
      const CompressResultsSaved(
        preserveMetadataSourceIdentifiers: {'photos-id'},
      ),
    );
    await bloc.stream.firstWhere((state) => state.savedVideoCount == 1);

    expect(files.calls, ['replace:photos-id']);
    expect(bloc.state.isSaved, isTrue);
    bloc.add(const CompressMessagesCleared());
    await bloc.stream.firstWhere((state) => state.savedVideoCount == null);
    expect(bloc.state.isSaved, isTrue);
    await bloc.close();
  });

  test('does not save or delete the same replacement twice', () async {
    final files = _UnavailableAfterDeleteFileAdapter();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/ok.mp4',
          name: 'video.mp4',
          size: 100,
          sourceIdentifier: 'photos-id',
          canDeleteOriginal: true,
        ),
      ],
      videoFileAdapter: files,
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );
    bloc.add(
      const CompressResultsSaved(
        preserveMetadataSourceIdentifiers: {'photos-id'},
        deleteSourceIdentifiers: {'photos-id'},
      ),
    );
    await bloc.stream.firstWhere((state) => state.deletedOriginalCount == 1);
    bloc.add(const CompressMessagesCleared());
    await bloc.stream.firstWhere((state) => state.savedVideoCount == null);

    final repeatedSaveFinished = bloc.stream.firstWhere(
      (state) => !state.isSaving && state.saveError == null,
    );
    bloc.add(
      const CompressResultsSaved(
        preserveMetadataSourceIdentifiers: {'photos-id'},
        deleteSourceIdentifiers: {'photos-id'},
      ),
    );
    await repeatedSaveFinished;

    expect(files.calls, ['replace:photos-id', 'delete:photos-id']);
    expect(bloc.state.saveError, isNull);
    await bloc.close();
  });

  test('does not delete originals when saving fails', () async {
    final files = _FailingSaveFileAdapter();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/ok.mp4',
          name: 'video.mp4',
          size: 100,
          sourceIdentifier: 'photos-id',
          canDeleteOriginal: true,
        ),
      ],
      videoFileAdapter: files,
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );
    bloc.add(
      const CompressResultsSaved(
        preserveMetadataSourceIdentifiers: {'photos-id'},
        deleteSourceIdentifiers: {'photos-id'},
      ),
    );
    await bloc.stream.firstWhere((state) => state.saveError != null);

    expect(files.deletedIdentifiers, isEmpty);
    expect(bloc.state.isSaved, isFalse);
    await bloc.close();
  });

  test(
    'reports metadata warning after verified replacement and deletion',
    () async {
      final files = _WarningSaveFileAdapter();
      final bloc = CompressBloc(
        initialVideos: const [
          PickedVideo(
            path: '/ok.mp4',
            name: 'video.mp4',
            size: 100,
            sourceIdentifier: 'photos-id',
            canDeleteOriginal: true,
          ),
        ],
        videoFileAdapter: files,
        videoCompressorAdapter: _MixedCompressor(),
      );

      bloc.add(const CompressStarted());
      await bloc.stream.firstWhere(
        (state) => state.status == CompressStatus.done,
      );
      bloc.add(
        const CompressResultsSaved(
          preserveMetadataSourceIdentifiers: {'photos-id'},
          deleteSourceIdentifiers: {'photos-id'},
        ),
      );
      await bloc.stream.firstWhere((state) => state.deletedOriginalCount == 1);

      expect(bloc.state.metadataError, 'favorite_unavailable');
      expect(files.calls, ['replace:photos-id', 'delete:photos-id']);
      await bloc.close();
    },
  );

  test('allows saving another copy after success', () async {
    final files = _SavingFileAdapter();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/ok.mp4',
          name: 'video.mp4',
          size: 100,
          sourceIdentifier: 'picker-uri',
        ),
      ],
      videoFileAdapter: files,
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );
    expect(bloc.state.hasUnsavedResults, isTrue);
    bloc.add(const CompressResultsSaved());
    await bloc.stream.firstWhere((state) => state.savedVideoCount == 1);
    expect(bloc.state.hasUnsavedResults, isFalse);
    final savedAgain = bloc.stream.firstWhere(
      (state) => state.savedVideoCount == 1 && !state.isSaving,
    );
    bloc.add(const CompressResultsSaved());
    await savedAgain;

    expect(files.deletedIdentifiers, isEmpty);
    expect(files.calls, ['save:/ok-small.mp4', 'save:/ok-small.mp4']);
    await bloc.close();
  });

  test('deletes only selected original identifiers', () async {
    final files = _SavingFileAdapter();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(
          path: '/ok-one.mp4',
          name: 'one.mp4',
          size: 100,
          sourceIdentifier: 'one-id',
          canDeleteOriginal: true,
        ),
        PickedVideo(
          path: '/ok-two.mp4',
          name: 'two.mp4',
          size: 100,
          sourceIdentifier: 'two-id',
          canDeleteOriginal: true,
        ),
      ],
      videoFileAdapter: files,
      videoCompressorAdapter: _MixedCompressor(),
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );
    bloc.add(
      const CompressResultsSaved(
        preserveMetadataSourceIdentifiers: {'two-id'},
        deleteSourceIdentifiers: {'two-id'},
      ),
    );
    await bloc.stream.firstWhere((state) => state.deletedOriginalCount == 1);

    expect(files.deletedIdentifiers, ['two-id']);
    expect(files.calls, [
      'save:/ok-small.mp4',
      'replace:two-id',
      'delete:two-id',
    ]);
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

  test('keeps previous estimate while settings estimate refreshes', () async {
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 17),
      ],
      videoCompressorAdapter: _EstimatingCompressor(),
    );

    await bloc.stream.firstWhere((state) => state.estimatedSize == 15);
    bloc.add(const CompressSettingsChanged(CompressionSettings(crf: 34)));
    final changed = await bloc.stream.firstWhere(
      (state) => state.settings.crf == 34,
    );

    expect(changed.estimatedSize, 15);
    await bloc.close();
  });

  test(
    'latest estimate skips stale work for a batch over 100 videos',
    () async {
      final compressor = _QueuedEstimatingCompressor();
      final bloc = CompressBloc(
        initialVideos: List.generate(
          101,
          (index) => PickedVideo(
            path: '/video-$index.mp4',
            name: 'video-$index.mp4',
            size: 100,
          ),
        ),
        videoCompressorAdapter: compressor,
      );
      addTearDown(() async {
        compressor.unblock();
        await bloc.close();
      });

      await compressor.firstStarted.future;
      bloc.add(const CompressSettingsChanged(CompressionSettings(crf: 34)));
      final changed = await bloc.stream.firstWhere(
        (state) => state.settings.crf == 34,
      );
      expect(changed.isEstimating, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      compressor.releaseFirst.complete();

      final estimated = await bloc.stream
          .firstWhere((state) => state.estimatedSize == 34)
          .timeout(const Duration(milliseconds: 500));
      expect(estimated.isEstimating, isFalse);
      expect(compressor.calls, 2);
    },
  );

  test('keeps screen awake while compression is active', () async {
    final settings = AppSettingsService.instance;
    final previous = settings.preventScreenSleep;
    settings.preventScreenSleep = true;
    addTearDown(() => settings.preventScreenSleep = previous);

    final compressor = _ControlledCompressor();
    final screenAwake = _FakeScreenAwakeService();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/video.mp4', name: 'video.mp4', size: 100),
      ],
      videoCompressorAdapter: compressor,
      screenAwakeService: screenAwake,
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.processing,
    );
    expect(screenAwake.calls, [true]);

    compressor.completer.complete(
      const CompressionResult(
        success: true,
        originalSize: 100,
        outputSize: 40,
        outputPath: '/small.mp4',
      ),
    );
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );

    expect(screenAwake.calls, [true, false]);
    await bloc.close();
  });

  test('does not keep screen awake when setting is off', () async {
    final settings = AppSettingsService.instance;
    final previous = settings.preventScreenSleep;
    settings.preventScreenSleep = false;
    addTearDown(() => settings.preventScreenSleep = previous);

    final screenAwake = _FakeScreenAwakeService();
    final bloc = CompressBloc(
      initialVideos: const [
        PickedVideo(path: '/ok.mp4', name: 'ok.mp4', size: 100),
      ],
      videoCompressorAdapter: _MixedCompressor(),
      screenAwakeService: screenAwake,
    );

    bloc.add(const CompressStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == CompressStatus.done,
    );

    expect(screenAwake.calls, isEmpty);
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
    expect(bloc.state.currentVideoProgress, 0.5);
    compressor.firstProgress?.call(0.25);
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.progress, 0.125);
    expect(bloc.state.currentVideoProgress, 0.5);
    compressor.firstResult.complete(const CompressionResult(success: false));
    await bloc.close();
  });
}
