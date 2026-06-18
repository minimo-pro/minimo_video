import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../generated/l10n.dart';
import '../router/app_router.gr.dart';
import '../services/first_launch_service.dart';
import '../theme/app_theme.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    await FirstLaunchService.completeOnboarding();
    if (mounted) {
      context.router.replace(const StartRoute());
    }
  }

  void _next() {
    if (_currentPage == 2) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = AppTheme.of(context);
    final pages = [
      _OnboardingPageData(
        icon: AppIcons.plus,
        title: strings.onboardingPickTitle,
        description: strings.onboardingPickDescription,
      ),
      _OnboardingPageData(
        icon: AppIcons.settings,
        title: strings.onboardingQualityTitle,
        description: strings.onboardingQualityDescription,
      ),
      _OnboardingPageData(
        icon: AppIcons.check,
        title: strings.onboardingSaveTitle,
        description: strings.onboardingSaveDescription,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishing ? null : _finish,
                  child: Text(
                    strings.skip,
                    style: TextStyle(
                      color: theme.secondaryTextColor,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  itemBuilder: (context, index) {
                    return _OnboardingPage(data: pages[index]);
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(
                        pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          margin: const EdgeInsets.only(right: 8),
                          width: index == _currentPage ? 28 : 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: index == _currentPage
                                ? theme.accentColor
                                : theme.frameBorderColor,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _finishing ? null : _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.accentColor,
                      foregroundColor: theme.onAccentColor,
                      minimumSize: const Size(134, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _currentPage == pages.length - 1
                          ? strings.getStarted
                          : strings.next,
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 190,
            height: 190,
            padding: const EdgeInsets.all(52),
            decoration: BoxDecoration(
              color: theme.frameBackgroundColor.withValues(alpha: 0.52),
              borderRadius: BorderRadius.circular(42),
              border: Border.all(color: theme.frameBorderColor, width: 2),
            ),
            child: SvgPicture.asset(
              data.icon,
              colorFilter: ColorFilter.mode(theme.iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 42),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textColor,
              fontSize: 31,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 310),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.secondaryTextColor,
                fontSize: 18,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String icon;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });
}
