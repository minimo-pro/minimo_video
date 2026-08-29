import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upgrader/upgrader.dart';

import '../constants/app_icons.dart';
import '../features/compression/presentation/widgets/video_pick_source_sheet.dart';
import '../generated/l10n.dart';
import '../router/app_router.gr.dart';
import '../services/app_settings_service.dart';
import '../services/changelog_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_frame.dart';
import '../widgets/changelog_dialog.dart';
import '../widgets/pressable.dart';

@RoutePage()
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _upgrader = Upgrader();
  final _upgradeFlowDone = Completer<void>();
  var _changelogStarted = false;

  @override
  void initState() {
    super.initState();
    _upgrader.willDisplayUpgrade =
        ({
          required bool display,
          String? installedVersion,
          UpgraderVersionInfo? versionInfo,
        }) {
          if (!display) _completeUpgradeFlow();
        };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_showChangelogWhenReady());
    });
  }

  void _completeUpgradeFlow() {
    if (!_upgradeFlowDone.isCompleted) {
      _upgradeFlowDone.complete();
    }
  }

  bool _onUpgradeDismissed() {
    _completeUpgradeFlow();
    return true;
  }

  Future<void> _showChangelogWhenReady() async {
    unawaited(_releaseUpgradeFlowIfCheckStalls());
    await _upgradeFlowDone.future;
    if (!mounted || _changelogStarted) return;
    _changelogStarted = true;
    await _showChangelog();
  }

  /// Store lookup can finish without [UpgraderState.versionInfo], and then
  /// [UpgradeAlert] never calls [Upgrader.shouldDisplayUpgrade].
  Future<void> _releaseUpgradeFlowIfCheckStalls() async {
    try {
      await _upgrader.initialize().timeout(const Duration(seconds: 8));
    } catch (_) {}
    if (_upgrader.state.versionInfo == null) {
      _completeUpgradeFlow();
    }
  }

  Future<void> _showChangelog() async {
    if (!mounted) return;
    final language = Language.fromCode(
      AppSettingsService.instance.languageCode ??
          Localizations.localeOf(context).languageCode,
    );
    final update = await ChangelogService.instance.initialize(
      language: language,
    );
    if (update != null && mounted) {
      await showChangelogDialog(context, update);
    }
  }

  Future<void> _pickAndGo() async {
    final source = await showVideoPickSourceSheet(context);
    if (source == null || !mounted) return;
    context.pushRoute(CompressRoute(initialPickSource: source));
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final theme = AppTheme.of(context);

    return UpgradeAlert(
      showReleaseNotes: false,
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      upgrader: _upgrader,
      onIgnore: _onUpgradeDismissed,
      onLater: _onUpgradeDismissed,
      onUpdate: _onUpgradeDismissed,
      child: Scaffold(
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
                          style: materialTheme.textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
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
                                      theme.iconColor.withValues(alpha: 0.54),
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
      ),
    );
  }
}
