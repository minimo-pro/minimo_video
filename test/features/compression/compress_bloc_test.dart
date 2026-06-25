import 'package:flutter_test/flutter_test.dart';
import 'package:minimo_video/features/compression/bloc/compress_bloc.dart';
import 'package:minimo_video/features/compression/bloc/compress_event.dart';
import 'package:minimo_video/features/compression/bloc/compress_state.dart';
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

void main() {
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
            ),
      ),
    );
    await bloc.close();
  });
}
