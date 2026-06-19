import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_action_button.dart';
import '../../bloc/compress_bloc.dart';
import '../../bloc/compress_event.dart';
import '../../bloc/compress_state.dart';
import 'selected_videos_preview.dart';

class CompressionResultView extends StatelessWidget {
  final CompressState state;
  final VoidCallback onCompressOtherVideos;

  const CompressionResultView({
    super.key,
    required this.state,
    required this.onCompressOtherVideos,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final successResults = state.successResults;
    final originalSize = state.resultsOriginalSize;
    final compressedSize = state.compressedSize;
    final savedBytes = (originalSize - compressedSize).clamp(0, originalSize);

    return Column(
      children: [
        const Spacer(flex: 2),
        SelectedVideosPreview(
          selectedCount: state.videos.length,
          thumbnailPaths: state.thumbnailPaths,
          scale: 1.72,
        ),
        const SizedBox(height: 34),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: CompressionUiColors.green,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 12),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                successResults.length == state.results.length
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
          strings.youSavedSize(Utils.formatSize(savedBytes).toLowerCase()),
          style: const TextStyle(
            color: CompressionUiColors.grey,
            fontSize: 19,
            height: 1,
          ),
        ),
        const SizedBox(height: 40),
        AppActionButton(
          width: double.infinity,
          label: strings.share,
          icon: AppIcons.share,
          onPressed: successResults.isEmpty
              ? null
              : () => _shareResults(context),
        ),
        const SizedBox(height: 14),
        AppActionButton(
          width: double.infinity,
          label: strings.save,
          icon: AppIcons.save,
          variant: AppActionButtonVariant.filled,
          onPressed: successResults.isEmpty || state.isSaving
              ? null
              : () => context.read<CompressBloc>().add(
                  const CompressResultsSaved(deleteOriginals: false),
                ),
        ),
        // TODO: Restore Delete Original after implementing platform-safe
        // deletion from Photos/MediaStore with system confirmation.
        const Spacer(flex: 3),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.failedToShare(error.toString()))),
      );
    }
  }
}
