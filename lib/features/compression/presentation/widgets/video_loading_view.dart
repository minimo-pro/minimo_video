import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/minimo_loader.dart';

class VideoLoadingView extends StatelessWidget {
  final (int, int)? progress;

  const VideoLoadingView({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
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
              style: materialTheme.textTheme.titleMedium?.copyWith(
                color: theme.textColor,
              ),
            ),
            if (progress case (final done, final total)) ...[
              const SizedBox(height: 8),
              Text(
                '$done / $total',
                style: materialTheme.textTheme.titleLarge?.copyWith(
                  color: theme.textColor,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              strings.loadingManyVideosHint,
              textAlign: TextAlign.center,
              style: materialTheme.textTheme.bodyMedium?.copyWith(
                color: theme.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
