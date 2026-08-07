import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../features/compression/data/video_file_adapter.dart';
import '../features/compression/presentation/widgets/video_loading_view.dart';
import '../features/compression/presentation/widgets/video_pick_source_sheet.dart';
import '../generated/l10n.dart';
import '../router/app_router.gr.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_frame.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/pressable.dart';

@RoutePage()
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _videoFileAdapter = VideoFileAdapter();
  bool _loading = false;
  (int, int)? _loadingProgress;

  Future<void> _pickAndGo() async {
    final source = await showVideoPickSourceSheet(context);
    if (source == null || !mounted) return;

    setState(() => _loading = true);

    try {
      final videos = await _videoFileAdapter.pickVideos(
        source: source,
        onProgress: (processed, total) {
          if (mounted) setState(() => _loadingProgress = (processed, total));
        },
      );
      if (videos.isNotEmpty && mounted) {
        context.pushRoute(CompressRoute(initialVideos: videos));
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
          _loading = false;
          _loadingProgress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final theme = AppTheme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              theme.isDarkTheme
                  ? 'assets/images/background_dark.png'
                  : 'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).appName,
                        style: materialTheme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox.shrink(),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? VideoLoadingView(progress: _loadingProgress)
                      : Center(
                          child: Pressable(
                            child: GestureDetector(
                              onTap: _pickAndGo,
                              child: Container(
                                width: 300,
                                height: 300,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: theme.frameBackgroundColor.withValues(
                                    alpha: 0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: theme.frameBorderColor,
                                    width: 2,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: SvgPicture.asset(
                                        AppIcons.plus,
                                        width: 56,
                                        height: 56,
                                        colorFilter: ColorFilter.mode(
                                          theme.iconColor.withValues(
                                            alpha: 0.54,
                                          ),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: BottomFrame(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
