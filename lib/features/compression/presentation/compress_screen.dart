import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_icons.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_router.gr.dart';
import '../../../services/app_settings_service.dart';
import '../../../services/app_cache_service.dart';
import '../../../services/review_service.dart';
import '../../../services/screen_awake_service.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/app_action_button.dart';
import '../../../widgets/app_snack_bar.dart';
import '../../../widgets/minimo_loader.dart';
import '../../../widgets/photo_app_card.dart';
import '../bloc/compress_bloc.dart';
import '../bloc/compress_event.dart';
import '../bloc/compress_state.dart';
import '../data/video_file_adapter.dart';
import '../domain/picked_video.dart';
import '../domain/compression_settings.dart';
import '../domain/video_pick_source.dart';
import 'widgets/compression_progress_view.dart';
import 'widgets/compression_result_view.dart';
import 'widgets/compression_settings_view.dart';
import 'widgets/video_loading_view.dart';
import 'widgets/video_pick_source_sheet.dart';

@RoutePage()
class CompressScreen extends StatelessWidget {
  final List<PickedVideo> initialVideos;
  final VideoPickSource? initialPickSource;
  final CompressionSettings initialSettings;

  const CompressScreen({
    super.key,
    this.initialVideos = const [],
    this.initialPickSource,
    this.initialSettings = const CompressionSettings(),
  });

  @override
  Widget build(BuildContext context) {
    if (initialVideos.isEmpty && initialPickSource == null) {
      return const _StartRedirect();
    }

    return BlocProvider(
      create: (_) => CompressBloc(
        initialVideos: initialVideos,
        initialSettings: initialSettings,
      ),
      child: _CompressView(initialPickSource: initialPickSource),
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
  final VideoPickSource? initialPickSource;

  const _CompressView({this.initialPickSource});

  @override
  State<_CompressView> createState() => _CompressViewState();
}

class _CompressViewState extends State<_CompressView>
    with WidgetsBindingObserver {
  final _videoFileAdapter = VideoFileAdapter();
  var _backgroundedWhileProcessing = false;
  int? _promptRequestedForRunId;
  final _photoPrompt = OverlayPortalController();
  Timer? _photoPromptTimer;
  bool _loadingVideos = false;
  bool _screenAwakeEnabled = false;
  (int, int)? _loadingProgress;
  bool _initialSelectionConfirmed = false;
  bool _leaveConfirmationOpen = false;
  bool _leavingDuringImport = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadingVideos = widget.initialPickSource != null;
    if (widget.initialPickSource case final source?) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(_importVideos(source, initial: true)),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _photoPromptTimer?.cancel();
    if (_loadingVideos) {
      unawaited(_videoFileAdapter.cancelVideoPick());
    }
    unawaited(_setScreenAwake(false));
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
    return OverlayPortal(
      controller: _photoPrompt,
      overlayChildBuilder: _buildPhotoPrompt,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocConsumer<CompressBloc, CompressState>(
      listener: (context, state) {
        _showSaveMessage(context, state);
        unawaited(_promptAfterSuccessfulCompression(state));
      },
      builder: (context, state) {
        final waitingForInitialSelection =
            state.videos.isEmpty &&
            widget.initialPickSource != null &&
            !_initialSelectionConfirmed;
        final canLeave =
            state.status != CompressStatus.processing &&
            !_loadingVideos &&
            !state.isSaving &&
            !state.hasUnsavedResults;
        final backButton = AppActionButton(
          width: 47,
          icon: AppIcons.arrowBack,
          iconWidth: 22,
          iconHeight: 22,
          onPressed: () => unawaited(_requestLeave(context, state)),
        );
        return PopScope(
          canPop: canLeave,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            if (_loadingVideos) {
              unawaited(_confirmLoadingExit(context));
            } else if (state.hasUnsavedResults) {
              unawaited(_confirmUnsavedExit(context));
            }
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
                child: Column(
                  children: [
                    if (waitingForInitialSelection)
                      Expanded(
                        child: Stack(
                          children: [
                            const Positioned.fill(child: VideoLoadingView()),
                            Align(
                              alignment: Alignment.topLeft,
                              child: backButton,
                            ),
                          ],
                        ),
                      )
                    else ...[
                      if (state.status != CompressStatus.processing) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: backButton,
                        ),
                        const SizedBox(height: 8),
                      ],
                      Expanded(
                        child: switch (state.status) {
                          CompressStatus.ready => CompressionSettingsView(
                            state: state,
                            isImporting: _loadingVideos,
                            importProgress: _loadingProgress,
                            onAddVideos: _loadingVideos
                                ? null
                                : () => unawaited(_pickMoreVideos()),
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

  Widget _buildPhotoPrompt(BuildContext context) {
    return Positioned(
      left: 18,
      right: 18,
      top: MediaQuery.paddingOf(context).top + 14,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, -24 * (1 - value)),
            child: child,
          ),
        ),
        child: Semantics(
          container: true,
          liveRegion: true,
          child: Material(
            color: AppTheme.of(context).frameBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).photoAppPromptTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Tooltip(
                          message: MaterialLocalizations.of(
                            context,
                          ).closeButtonTooltip,
                          child: AppActionButton(
                            width: 40,
                            height: 40,
                            icon: AppIcons.close,
                            variant: AppActionButtonVariant.text,
                            onPressed: _dismissPhotoPrompt,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PhotoAppCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dismissPhotoPrompt() {
    _photoPromptTimer?.cancel();
    _photoPrompt.hide();
  }

  Future<void> _pickMoreVideos() async {
    final source = await showVideoPickSourceSheet(context);
    if (source == null || !mounted) return;

    await _importVideos(source);
  }

  Future<void> _importVideos(
    VideoPickSource source, {
    bool initial = false,
  }) async {
    setState(() {
      _loadingVideos = true;
      _loadingProgress = null;
    });
    unawaited(_setScreenAwake(AppSettingsService.instance.preventScreenSleep));

    try {
      final videos = await _videoFileAdapter.pickVideos(
        source: source,
        onProgress: (processed, total) {
          if (mounted) {
            setState(() {
              _loadingProgress = (processed, total);
              if (initial && total > 0) _initialSelectionConfirmed = true;
            });
          }
        },
      );
      if (videos.isNotEmpty && mounted) {
        context.read<CompressBloc>().add(CompressVideosAdded(videos));
      } else if (!mounted && videos.isNotEmpty) {
        await AppCacheService.removeFiles(videos.map((video) => video.path));
      } else if (initial && mounted && !_leavingDuringImport) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: S.of(context).failedToPickVideos,
          type: AppSnackBarType.error,
        );
        if (initial) {
          Navigator.of(context).pop();
        }
      }
    } finally {
      unawaited(_setScreenAwake(false));
      if (mounted) {
        setState(() {
          _loadingVideos = false;
          _loadingProgress = null;
        });
      }
    }
  }

  Future<void> _setScreenAwake(bool enabled) async {
    if (enabled == _screenAwakeEnabled) return;
    _screenAwakeEnabled = enabled;
    try {
      await ScreenAwakeService.instance.setEnabled(enabled);
    } catch (_) {
      _screenAwakeEnabled = !enabled;
    }
  }

  Future<void> _promptAfterSuccessfulCompression(CompressState state) async {
    if (state.status != CompressStatus.done ||
        _promptRequestedForRunId == state.compressionRunId) {
      return;
    }

    _promptRequestedForRunId = state.compressionRunId;
    final prompt = await ReviewService.instance.onSuccessfulConversions(
      state.successfulOutputPaths.length,
    );
    if (prompt != CompressionPrompt.photoApp ||
        !mounted ||
        context.read<CompressBloc>().state.compressionRunId !=
            state.compressionRunId) {
      return;
    }
    _photoPrompt.show();
    _photoPromptTimer?.cancel();
    _photoPromptTimer = Timer(const Duration(seconds: 10), _dismissPhotoPrompt);
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

  Future<void> _requestLeave(BuildContext context, CompressState state) async {
    if (state.isSaving) return;
    if (_loadingVideos) {
      await _confirmLoadingExit(context);
    } else if (state.hasUnsavedResults) {
      await _confirmUnsavedExit(context);
    } else {
      _goToStart(context);
    }
  }

  Future<void> _confirmUnsavedExit(BuildContext context) async {
    if (context.read<CompressBloc>().state.isSaving) return;
    final strings = S.of(context);
    final leave = await _confirmExit(
      context,
      title: strings.unsavedResultsTitle,
      message: strings.unsavedResultsMessage,
      leaveLabel: strings.leaveWithoutSaving,
    );
    if (leave && mounted) _goToStart(this.context);
  }

  Future<void> _confirmLoadingExit(BuildContext context) async {
    final strings = S.of(context);
    final leave = await _confirmExit(
      context,
      title: strings.loadingExitTitle,
      message: strings.loadingExitMessage,
      leaveLabel: strings.leave,
    );
    if (!leave || !mounted) return;
    _leavingDuringImport = true;
    await _videoFileAdapter.cancelVideoPick();
    if (mounted) Navigator.of(this.context).pop();
  }

  Future<bool> _confirmExit(
    BuildContext context, {
    required String title,
    required String message,
    required String leaveLabel,
  }) async {
    if (_leaveConfirmationOpen) return false;
    _leaveConfirmationOpen = true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (_) => _ExitConfirmationDialog(
        title: title,
        message: message,
        leaveLabel: leaveLabel,
      ),
    );
    _leaveConfirmationOpen = false;
    return leave ?? false;
  }
}

class _ExitConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String leaveLabel;

  const _ExitConfirmationDialog({
    required this.title,
    required this.message,
    required this.leaveLabel,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: colors.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.onSurface,
                    fontSize: 30,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 17,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                AppActionButton(
                  width: double.infinity,
                  height: 54,
                  label: strings.stay,
                  fontSize: 22,
                  variant: AppActionButtonVariant.filled,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                const SizedBox(height: 10),
                AppActionButton(
                  width: double.infinity,
                  height: 54,
                  label: leaveLabel,
                  fontSize: 18,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
