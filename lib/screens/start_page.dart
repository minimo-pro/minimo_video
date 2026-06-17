import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../router/app_router.gr.dart';
import '../services/file_service.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_frame.dart';

@RoutePage()
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _fileService = FileService();
  bool _loading = false;

  Future<void> _pickAndGo() async {
    setState(() => _loading = true);

    try {
      final videos = await _fileService.pickVideos();
      if (videos.isNotEmpty && mounted) {
        context.pushRoute(CompressRoute(initialVideos: videos));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
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
                        'minimo (video)',
                        style: theme.textTheme.headlineSmall?.copyWith(
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
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: GestureDetector(
                            onTap: _pickAndGo,
                            child: Container(
                              width: 300,
                              height: 300,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colors.frameBackground.withValues(
                                  alpha: 0.7,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: colors.frameBorder,
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/plus.svg',
                                      width: 56,
                                      height: 56,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black54,
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
                const BottomFrame(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
