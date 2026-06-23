import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../router/app_router.gr.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_snack_bar.dart';
import '../../../widgets/minimo_loader.dart';
import '../bloc/compress_bloc.dart';
import '../bloc/compress_event.dart';
import '../bloc/compress_state.dart';
import '../domain/picked_video.dart';
import 'widgets/compression_progress_view.dart';
import 'widgets/compression_result_view.dart';
import 'widgets/compression_settings_view.dart';

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

class _CompressView extends StatelessWidget {
  const _CompressView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompressBloc, CompressState>(
      listener: _showSaveMessage,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CompressionUiColors.page,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
              child: switch (state.status) {
                CompressStatus.ready => CompressionSettingsView(
                  state: state,
                  onBack: () => _goToStart(context),
                ),
                CompressStatus.processing => CompressionProgressView(
                  state: state,
                ),
                CompressStatus.done => CompressionResultView(
                  state: state,
                  onTryAgain: () =>
                      context.read<CompressBloc>().add(const CompressStarted()),
                  onCompressOtherVideos: () => _goToStart(context),
                ),
              },
            ),
          ),
        );
      },
    );
  }

  void _showSaveMessage(BuildContext context, CompressState state) {
    final strings = S.of(context);
    final message = state.deleteError != null
        ? strings.savedButOriginalsNotDeleted(state.deleteError.toString())
        : state.savedVideoCount != null && (state.deletedOriginalCount ?? 0) > 0
        ? strings.savedVideosAndDeletedOriginals(
            state.savedVideoCount!,
            state.deletedOriginalCount!,
          )
        : state.savedVideoCount != null
        ? strings.savedVideosToGallery(state.savedVideoCount!)
        : state.saveError != null
        ? strings.failedToSave(state.saveError.toString())
        : null;
    if (message == null) return;

    AppSnackBar.show(
      context,
      message: message,
      type: state.deleteError != null || state.saveError != null
          ? AppSnackBarType.error
          : AppSnackBarType.success,
    );
    context.read<CompressBloc>().add(const CompressMessagesCleared());
  }

  void _goToStart(BuildContext context) {
    context.router.replaceAll([const StartRoute()]);
  }
}
