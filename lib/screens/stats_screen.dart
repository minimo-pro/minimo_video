import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../generated/l10n.dart';
import '../services/app_stats_service.dart';
import '../services/utils.dart';
import '../theme/app_theme.dart';
import '../widgets/minimo_loader.dart';
import '../widgets/pressable.dart';
import '../widgets/rolling_counter_text.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: FutureBuilder<AppStats>(
                future: AppStatsService.load(),
                builder: (context, snapshot) => snapshot.hasData
                    ? _StatsContent(stats: snapshot.requireData)
                    : const Center(child: MinimoLoader()),
              ),
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
