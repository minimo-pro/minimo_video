import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_icons.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_router.gr.dart';
import '../../../services/review_service.dart';
import '../../../widgets/app_action_button.dart';
import '../../../widgets/app_snack_bar.dart';
import '../../../widgets/minimo_loader.dart';
import '../bloc/compress_bloc.dart';
import '../bloc/compress_event.dart';
import '../bloc/compress_state.dart';
import '../data/video_file_adapter.dart';
import '../domain/picked_video.dart';
import 'widgets/compression_progress_view.dart';
import 'widgets/compression_result_view.dart';
import 'widgets/compression_settings_view.dart';
import 'widgets/video_loading_view.dart';
import 'widgets/video_pick_source_sheet.dart';

@RoutePage()
class CompressScreen extends StatelessWidget {
  final List<PickedVideo> initialVideos;

  const CompressScreen({super.key, this.initialVideos = const []});

  @override
  Widget build(BuildContext context) {
    if (initialVideos.isEmpty) {
      return const _StartRedirect();
    }

    return BlocProvider(
      create: (_) => CompressBloc(initialVideos: initialVideos),
      child: const _CompressView(),
    );
  }
}

class _StartRedirect extends StatefulWidget {
  const _StartRedirect();

  @override
  State<_StartRedirect> createState() => _StartRedirectState();
}

class _StartRedirectState extends State<_StartRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.router.replaceAll([const StartRoute()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MinimoLoader(semanticsLabel: S.of(context).loadingVideos),
      ),
    );
  }
}

class _CompressView extends StatefulWidget {
  const _CompressView();

  @override
  State<_CompressView> createState() => _CompressViewState();
}

class _CompressViewState extends State<_CompressView>
    with WidgetsBindingObserver {
  final _videoFileAdapter = VideoFileAdapter();
  var _backgroundedWhileProcessing = false;
  int? _reviewRequestedForRunId;
  bool _loadingVideos = false;
  (int, int)? _loadingProgress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _backgroundedWhileProcessing =
          context.read<CompressBloc>().state.status ==
          CompressStatus.processing;
      if (_backgroundedWhileProcessing) {
        context.read<CompressBloc>().add(const CompressBackgrounded());
      }
    } else if (state == AppLifecycleState.resumed &&
        _backgroundedWhileProcessing) {
      _backgroundedWhileProcessing = false;
      context.read<CompressBloc>().add(const CompressForegroundResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompressBloc, CompressState>(
      listener: (context, state) {
        _showSaveMessage(context, state);
        _requestReviewAfterSuccessfulCompression(state);
      },
      builder: (context, state) {
        return PopScope(
          canPop: state.status != CompressStatus.processing && !_loadingVideos,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
                child: Column(
                  children: [
                    if (_loadingVideos)
                      Expanded(
                        child: VideoLoadingView(progress: _loadingProgress),
                      )
                    else ...[
                      if (state.status != CompressStatus.processing) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppActionButton(
                            width: 47,
                            icon: AppIcons.arrowBack,
                            iconWidth: 22,
                            iconHeight: 22,
                            variant: AppActionButtonVariant.text,
                            onPressed: () => _goToStart(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Expanded(
                        child: switch (state.status) {
                          CompressStatus.ready => CompressionSettingsView(
                            state: state,
                            onAddVideos: () => unawaited(_pickMoreVideos()),
                          ),
                          CompressStatus.processing => CompressionProgressView(
                            key: ValueKey(state.compressionRunId),
                            state: state,
                          ),
                          CompressStatus.done => CompressionResultView(
                            state: state,
                            onTryAgain: () => context.read<CompressBloc>().add(
                              const CompressStarted(),
                            ),
                          ),
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickMoreVideos() async {
    final source = await showVideoPickSourceSheet(context);
    if (source == null || !mounted) return;

    setState(() {
      _loadingVideos = true;
      _loadingProgress = null;
    });

    try {
      final videos = await _videoFileAdapter.pickVideos(
        source: source,
        onProgress: (processed, total) {
          if (mounted) {
            setState(() => _loadingProgress = (processed, total));
          }
        },
      );
      if (videos.isNotEmpty && mounted) {
        context.read<CompressBloc>().add(CompressVideosAdded(videos));
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: S.of(context).failedToPickVideos,
          type: AppSnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingVideos = false;
          _loadingProgress = null;
        });
      }
    }
  }

  void _requestReviewAfterSuccessfulCompression(CompressState state) {
    if (state.status != CompressStatus.done ||
        _reviewRequestedForRunId == state.compressionRunId) {
      return;
    }

    _reviewRequestedForRunId = state.compressionRunId;
    unawaited(
      ReviewService.instance.onSuccessfulConversions(
        state.successfulOutputPaths.length,
      ),
    );
  }

  void _showSaveMessage(BuildContext context, CompressState state) {
    final strings = S.of(context);
    final partialErrors = [
      if (state.metadataError != null) strings.metadataPreservationIncomplete,
      if (state.deleteError != null) strings.originalDeletionFailed,
    ];
    final message = partialErrors.isNotEmpty
        ? strings.savedWithWarnings(partialErrors.join('; '))
        : state.savedVideoCount != null && (state.deletedOriginalCount ?? 0) > 0
        ? strings.savedVideosAndDeletedOriginals(
            state.savedVideoCount!,
            state.deletedOriginalCount!,
          )
        : state.savedVideoCount != null
        ? strings.savedVideosToGallery(state.savedVideoCount!)
        : state.saveError != null
        ? strings.failedToSave
        : null;
    if (message == null) return;

    AppSnackBar.show(
      context,
      message: message,
      type:
          state.deleteError != null ||
              state.metadataError != null ||
              state.saveError != null
          ? AppSnackBarType.error
          : AppSnackBarType.success,
    );
    context.read<CompressBloc>().add(const CompressMessagesCleared());
  }

  void _goToStart(BuildContext context) {
    context.router.replaceAll([const StartRoute()]);
  }
}
