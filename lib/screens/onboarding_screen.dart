import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../generated/l10n.dart';
import '../router/app_router.gr.dart';
import '../services/changelog_service.dart';
import '../services/first_launch_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_action_button.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late final _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  int _currentPage = 0;
  bool _finishing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    await FirstLaunchService.completeOnboarding();
    await ChangelogService.instance.markCurrentVersionSeen();
    if (mounted) {
      context.router.replace(const StartRoute());
    }
  }

  void _next() {
    if (_currentPage == 2) {
      _finish();
      return;
    }
    if (MediaQuery.disableAnimationsOf(context)) {
      _pageController.jumpToPage(_currentPage + 1);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = AppTheme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final pages = [
      _OnboardingPageData(
        title: strings.onboardingPickTitle,
        description: strings.onboardingPickDescription,
      ),
      _OnboardingPageData(
        title: strings.onboardingQualityTitle,
        description: strings.onboardingQualityDescription,
      ),
      _OnboardingPageData(
        title: strings.onboardingSaveTitle,
        description: strings.onboardingSaveDescription,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'minimo',
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(color: theme.textColor, fontSize: 25),
                    ),
                  ),
                  Flexible(
                    child: AppActionButton(
                      variant: AppActionButtonVariant.text,
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      onPressed: _finishing ? null : _finish,
                      label: strings.skip,
                      fontSize: 17,
                      foregroundColor: theme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: Listenable.merge([_pageController, _entrance]),
                    builder: (context, _) {
                      final page =
                          _pageController.hasClients &&
                              _pageController.position.haveDimensions
                          ? _pageController.page ?? 0
                          : _currentPage.toDouble();
                      return _OnboardingPage(
                        data: pages[index],
                        index: index,
                        offset: reduceMotion ? 0 : page - index,
                        reveal: reduceMotion
                            ? 1
                            : (1 - (page - index).abs()).clamp(0.0, 1.0) *
                                  _entrance.value,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    child: AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, _) {
                        final page =
                            _pageController.hasClients &&
                                _pageController.position.haveDimensions
                            ? _pageController.page ?? 0
                            : _currentPage.toDouble();
                        return Row(
                          children: List.generate(pages.length, (index) {
                            final progress =
                                ((reduceMotion
                                            ? _currentPage.toDouble()
                                            : page) +
                                        1 -
                                        index)
                                    .clamp(0.0, 1.0);
                            return Expanded(
                              child: Semantics(
                                label: '${index + 1} / ${pages.length}',
                                selected: index == _currentPage,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: LinearProgressIndicator(
                                    key: ValueKey('onboarding-progress-$index'),
                                    value: progress,
                                    minHeight: 4,
                                    borderRadius: BorderRadius.circular(99),
                                    color: theme.accentColor,
                                    backgroundColor: theme.frameBorderColor
                                        .withValues(alpha: 0.24),
                                    stopIndicatorRadius: 0,
                                    trackGap: 0,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppActionButton(
                    variant: AppActionButtonVariant.filled,
                    width: double.infinity,
                    height: 56,
                    onPressed: _finishing ? null : _next,
                    label: _currentPage == pages.length - 1
                        ? strings.getStarted
                        : strings.next,
                    icon: _currentPage == pages.length - 1
                        ? AppIcons.check
                        : AppIcons.arrowForward,
                    iconWidth: 20,
                    iconHeight: 20,
                    iconAlignment: IconAlignment.end,
                    fontSize: 21,
                    backgroundColor: theme.accentColor,
                    foregroundColor: theme.onAccentColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final int index;
  final double offset;
  final double reveal;

  const _OnboardingPage({
    required this.data,
    required this.index,
    required this.offset,
    required this.reveal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _OnboardingReveal(
                  key: ValueKey('onboarding-$index-artwork'),
                  progress: reveal,
                  delay: 0.0,
                  child: ExcludeSemantics(
                    child: Transform.translate(
                      offset: Offset(offset * 36, (1 - reveal) * 20),
                      child: SizedBox(
                        height: (constraints.maxHeight * 0.55).clamp(
                          190.0,
                          330.0,
                        ),
                        child: FittedBox(
                          child: _OnboardingArtwork(
                            index: index,
                            reveal: reveal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _OnboardingReveal(
                  key: ValueKey('onboarding-$index-step'),
                  progress: reveal,
                  delay: 0.1,
                  child: Text(
                    '0${index + 1} / 03',
                    style: TextStyle(
                      color: theme.accentColor,
                      fontSize: 15,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _OnboardingReveal(
                  key: ValueKey('onboarding-$index-title'),
                  progress: reveal,
                  delay: 0.18,
                  child: Transform.translate(
                    offset: Offset(offset * -18, 0),
                    child: Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 34,
                        height: 1.08,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _OnboardingReveal(
                  key: ValueKey('onboarding-$index-description'),
                  progress: reveal,
                  delay: 0.28,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: Text(
                      data.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.secondaryTextColor,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingReveal extends StatelessWidget {
  final double progress;
  final double delay;
  final Widget child;

  const _OnboardingReveal({
    super.key,
    required this.progress,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final value = Interval(
      delay,
      1,
      curve: Curves.easeOutCubic,
    ).transform(progress);
    return Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 32 * (1 - value)),
        child: child,
      ),
    );
  }
}

class _OnboardingArtwork extends StatelessWidget {
  final int index;
  final double reveal;

  const _OnboardingArtwork({required this.index, required this.reveal});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strings = S.of(context);
    final accent = theme.accentColor;
    final spread = index == 0 ? 1.0 : 0.25;
    return SizedBox(
      width: 330,
      height: 310,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            _OnboardingReveal(
              progress: reveal,
              delay: i * 0.08,
              child: Transform.translate(
                offset: Offset(
                  (i - 1) * 48 * spread * reveal,
                  (i == 1 ? -12 : 8) * reveal,
                ),
                child: Transform.rotate(
                  angle: (i - 1) * 0.16 * spread * reveal,
                  child: Transform.scale(
                    scale: index == 1 ? 1 - reveal * 0.18 : 0.9 + reveal * 0.1,
                    child: Container(
                      width: 170,
                      height: 208,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.frameBorderColor.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: theme.isDarkTheme ? 0.25 : 0.08,
                            ),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/background.png',
                              fit: BoxFit.cover,
                              alignment: Alignment(i - 1.0, 0),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white70),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.play,
                                  width: 23,
                                  height: 23,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
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
            ),
          Positioned(
            bottom: 20,
            child: _OnboardingReveal(
              progress: reveal,
              delay: 0.32,
              child: Transform.scale(
                scale: 0.85 + reveal * 0.15,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 290),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: index == 1 ? theme.backgroundColor : accent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: index == 1 ? theme.frameBorderColor : accent,
                    ),
                  ),
                  child: index == 1
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final label in [
                                strings.high,
                                strings.medium,
                                strings.low,
                              ])
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: label == strings.medium
                                        ? accent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: label == strings.medium
                                          ? theme.onAccentColor
                                          : theme.secondaryTextColor,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              index == 0 ? AppIcons.plus : AppIcons.check,
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                theme.onAccentColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                index == 0
                                    ? strings.onboardingPickTitle
                                    : strings.saved,
                                style: TextStyle(
                                  color: theme.onAccentColor,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;

  const _OnboardingPageData({required this.title, required this.description});
}
