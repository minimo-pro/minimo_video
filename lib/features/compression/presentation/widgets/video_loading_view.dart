import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/minimo_loader.dart';

class VideoLoadingView extends StatelessWidget {
  const VideoLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strings = S.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MinimoLoader(size: 58, semanticsLabel: strings.loadingVideos),
            const SizedBox(height: 18),
            Text(
              strings.loadingVideos,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: theme.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              strings.loadingManyVideosHint,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: theme.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
