import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/app_icons.dart';
import '../generated/l10n.dart';
import '../services/app_stats_service.dart';
import '../services/utils.dart';
import '../theme/app_theme.dart';
import '../widgets/app_action_button.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/minimo_loader.dart';
import '../widgets/pressable.dart';
import '../widgets/rolling_counter_text.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Header(),
          FutureBuilder<AppStats>(
            future: AppStatsService.load(),
            builder: (context, snapshot) => snapshot.hasData
                ? _StatsContent(stats: snapshot.requireData)
                : snapshot.hasError
                ? const _StatsContent(
                    stats: AppStats(compressedVideos: 0, savedBytes: 0),
                  )
                : const Center(child: MinimoLoader()),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              S.of(context).statistics,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Pressable(
            child: IconButton(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: Navigator.of(context).maybePop,
              icon: SvgPicture.asset(
                AppIcons.close,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(theme.iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsContent extends StatelessWidget {
  final AppStats stats;

  const _StatsContent({required this.stats});

  Future<void> _share(BuildContext context) async {
    final strings = S.of(context);
    final box = context.findRenderObject() as RenderBox;
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: strings.shareStatisticsText(
            stats.compressedVideos,
            Utils.formatSize(stats.savedBytes),
            'https://minimo-video.vercel.app',
          ),
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: strings.failedToShareStatistics,
        type: AppSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: stats.compressedVideos,
                  formatter: (value) => value.toInt().toString(),
                  label: strings.videosCompressedStat,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value: stats.savedBytes,
                  formatter: (value) =>
                      Utils.formatSize(value.toInt()).toLowerCase(),
                  label: strings.spaceSavedStat,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            strings.statisticsSinceVersion,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          Builder(
            builder: (context) => AppActionButton(
              label: strings.share,
              icon: AppIcons.share,
              variant: AppActionButtonVariant.filled,
              width: double.infinity,
              onPressed: () => _share(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final num value;
  final String Function(num value) formatter;
  final String label;

  const _StatCard({
    required this.value,
    required this.formatter,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value.toInt()),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 1100),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, _) => RollingCounterText(
              value: animatedValue,
              formatter: formatter,
              style: TextStyle(
                color: theme.accentColor,
                fontSize: 34,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.secondaryTextColor, fontSize: 18),
        ),
      ],
    );
  }
}
