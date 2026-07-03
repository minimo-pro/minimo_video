import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_action_button.dart';
import '../../../../widgets/app_snack_bar.dart';
import '../../bloc/compress_bloc.dart';
import '../../bloc/compress_event.dart';
import '../../bloc/compress_state.dart';
import 'selected_videos_preview.dart';
import 'video_status_list.dart';

class CompressionResultView extends StatelessWidget {
  final CompressState state;
  final VoidCallback onTryAgain;
  final VoidCallback onCompressOtherVideos;

  const CompressionResultView({
    super.key,
    required this.state,
    required this.onTryAgain,
    required this.onCompressOtherVideos,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final successResults = state.successResults;
    final allFailed = successResults.isEmpty;
    final alreadyOptimized = allFailed && state.compressionError == null;
    final originalSize = state.resultsOriginalSize;
    final compressedSize = state.compressedSize;
    final savedBytes = (originalSize - compressedSize).clamp(0, originalSize);

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 24),
              SelectedVideosPreview(
                selectedCount: state.videos.length,
                thumbnailPaths: state.thumbnailPaths,
                scale: 1.72,
              ),
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: allFailed
                          ? CompressionUiColors.red
                          : CompressionUiColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 12),
                  ),
                  const SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      allFailed
                          ? alreadyOptimized
                                ? strings.alreadyOptimized
                                : strings.compressionFailed
                          : successResults.length == state.results.length
                          ? strings.compressionCompleted
                          : strings.videosCompressed(
                              successResults.length,
                              state.results.length,
                            ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: CompressionUiColors.dark,
                        fontSize: 25,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                allFailed
                    ? alreadyOptimized
                          ? strings.alreadyOptimizedDescription
                          : strings.compressionFailedDescription
                    : strings.youSavedSize(
                        Utils.formatSize(savedBytes).toLowerCase(),
                      ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CompressionUiColors.grey,
                  fontSize: 19,
                  height: 1,
                ),
              ),
              const SizedBox(height: 22),
              Flexible(
                fit: FlexFit.loose,
                child: VideoStatusList(state: state),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (allFailed && !alreadyOptimized)
          AppActionButton(
            width: double.infinity,
            label: strings.tryAgain,
            variant: AppActionButtonVariant.filled,
            onPressed: onTryAgain,
          )
        else ...[
          AppActionButton(
            width: double.infinity,
            label: strings.share,
            icon: AppIcons.share,
            onPressed: () => _shareResults(context),
          ),
          const SizedBox(height: 14),
          AppActionButton(
            width: double.infinity,
            label: strings.save,
            icon: AppIcons.download,
            variant: AppActionButtonVariant.filled,
            onPressed: state.isSaving
                ? null
                : () => context.read<CompressBloc>().add(
                    const CompressResultsSaved(deleteOriginals: false),
                  ),
          ),
        ],
        // TODO: Restore Delete Original after implementing platform-safe
        // deletion from Photos/MediaStore with system confirmation.
        const SizedBox(height: 14),
        AppActionButton(
          width: double.infinity,
          label: strings.compressOtherVideos,
          fontSize: 22,
          onPressed: onCompressOtherVideos,
        ),
      ],
    );
  }

  Future<void> _shareResults(BuildContext context) async {
    final strings = S.of(context);
    final paths = state.successfulOutputPaths;
    if (paths.isEmpty) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    final origin = renderBox == null
        ? null
        : renderBox.localToGlobal(Offset.zero) & renderBox.size;

    try {
      await SharePlus.instance.share(
        ShareParams(
          files: paths.map((path) => XFile(path, mimeType: 'video/*')).toList(),
          sharePositionOrigin: origin,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: strings.failedToShare(error.toString()),
        type: AppSnackBarType.error,
      );
    }
  }
}
