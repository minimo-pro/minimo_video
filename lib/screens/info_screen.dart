import 'dart:io';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_icons.dart';
import '../generated/l10n.dart';
import '../services/changelog_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/changelog_dialog.dart';
import '../widgets/faded_scroll_view.dart';
import '../widgets/pressable.dart';
import '../widgets/photo_app_card.dart';

@RoutePage()
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static const _email = 'khlebobul@gmail.com';
  static const _appStoreAppId = '6787456951';
  static const _appStoreAppUrl =
      'https://apps.apple.com/us/app/minimo-video/id6787456951';
  static const _googlePlayAppUrl =
      'https://play.google.com/store/apps/details?id=com.khlebobul.minimo_video';
  static final _appStoreApps = Uri.parse(
    'https://apps.apple.com/developer/gleb-shalimov/id1775466597',
  );
  static final _googlePlayApps = Uri.parse(
    'https://play.google.com/store/apps/developer?id=Gleb+Shalimov&hl=en',
  );
  static final _links = <String, Uri>{
    'project': Uri.parse('https://minimo-video.vercel.app'),
    'github': Uri.parse('https://github.com/minimo-pro/minimo_video'),
    'x': Uri.parse('https://x.com/khlebobul'),
    'threads': Uri.parse('https://www.threads.com/@khlebobul'),
  };

  Future<void> _open(String link) =>
      launchUrl(_links[link]!, mode: LaunchMode.externalApplication);

  Future<void> _openOtherApps() => launchUrl(
    Platform.isIOS ? _appStoreApps : _googlePlayApps,
    mode: LaunchMode.externalApplication,
  );

  Future<void> _rateApp() async {
    await launchUrl(
      Uri.parse(
        Platform.isIOS
            ? 'https://apps.apple.com/app/id$_appStoreAppId?action=write-review'
            : _googlePlayAppUrl,
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _shareApp(BuildContext context) async {
    final url = Platform.isIOS ? _appStoreAppUrl : _googlePlayAppUrl;
    final renderBox = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        text: S.of(context).shareAppText(url),
        sharePositionOrigin: renderBox == null
            ? null
            : renderBox.localToGlobal(Offset.zero) & renderBox.size,
      ),
    );
  }

  Future<void> _sendEmail(
    BuildContext context, {
    String? subject,
    String? body,
  }) async {
    final strings = S.of(context);
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      query: [
        'subject=${Uri.encodeComponent(subject ?? 'feedback ${strings.appName}')}',
        if (body != null) 'body=${Uri.encodeComponent(body)}',
      ].join('&'),
    );

    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;

    await Clipboard.setData(const ClipboardData(text: _email));
    if (!context.mounted) return;
    AppSnackBar.show(context, message: strings.emailCopied);
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = AppTheme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
              child: Row(
                children: [
                  Expanded(child: const _VersionIndicator()),
                  Pressable(
                    child: IconButton(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: context.maybePop,
                      icon: SvgPicture.asset(
                        AppIcons.close,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          theme.iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadedScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  math.max(36, MediaQuery.viewPaddingOf(context).bottom),
                ),
                child: Column(
                  children: [
                    Text(
                      strings.aboutStory,
                      style: textTheme.bodyLarge?.copyWith(
                        color: theme.secondaryTextColor,
                        fontSize: 18,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _CompressionExplanation(strings: strings),
                    const SizedBox(height: 18),

                    const _WhatsNewLink(),
                    _InfoLink(title: strings.rateTheApp, onTap: _rateApp),
                    _InfoLink(
                      title: strings.shareWithFriends,
                      onTap: () => _shareApp(context),
                    ),
                    _InfoLink(
                      title: strings.reportBug,
                      onTap: () => _sendEmail(
                        context,
                        subject: '${strings.appName} — ${strings.reportBug}',
                        body: strings.bugReportBody,
                      ),
                    ),
                    _InfoLink(
                      title: strings.myOtherApps,
                      onTap: _openOtherApps,
                    ),
                    const SizedBox(height: 12),
                    const PhotoAppCard(),
                    const SizedBox(height: 16),
                    Text(
                      strings.openSourceNote,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: theme.secondaryTextColor,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoLink(title: 'website', onTap: () => _open('project')),
                    _InfoLink(title: 'email', onTap: () => _sendEmail(context)),
                    _InfoLink(title: 'github', onTap: () => _open('github')),
                    _InfoLink(title: 'x', onTap: () => _open('x')),
                    Tooltip(
                      message: 'threads · @khlebobul',
                      child: _InfoLink(
                        title: 'threads',
                        onTap: () => _open('threads'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhatsNewLink extends StatefulWidget {
  const _WhatsNewLink();

  @override
  State<_WhatsNewLink> createState() => _WhatsNewLinkState();
}

class _WhatsNewLinkState extends State<_WhatsNewLink> {
  ChangelogUpdate? _update;
  String? _languageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_languageCode == languageCode) return;
    _languageCode = languageCode;
    _load(languageCode);
  }

  Future<void> _load(String languageCode) async {
    final update = await ChangelogService.instance.currentUpdate(
      language: Language.fromCode(languageCode),
    );
    if (mounted && _languageCode == languageCode) {
      setState(() => _update = update);
    }
  }

  @override
  Widget build(BuildContext context) {
    final update = _update;
    if (update == null) return const SizedBox.shrink();

    return _InfoLink(
      title: S.of(context).changelogTitle(update.version),
      onTap: () => showChangelogDialog(context, update),
    );
  }
}

class _CompressionExplanation extends StatelessWidget {
  final S strings;

  const _CompressionExplanation({required this.strings});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.howCompressionWorksTitle,
          style: textTheme.titleLarge?.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 10),
        Text(
          strings.howCompressionWorksBody,
          style: textTheme.bodyLarge?.copyWith(
            color: theme.secondaryTextColor,
            fontSize: 17,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _VersionIndicator extends StatefulWidget {
  const _VersionIndicator();

  @override
  State<_VersionIndicator> createState() => _VersionIndicatorState();
}

class _VersionIndicatorState extends State<_VersionIndicator> {
  String? _version;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = info.version);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${S.of(context).appName}${_version == null ? '' : ' $_version'}',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _InfoLink extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _InfoLink({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Pressable(
        child: Material(
          color: theme.frameBackgroundColor,
          borderRadius: BorderRadius.circular(13),
          child: InkWell(
            onTap: onTap ?? () {},
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            borderRadius: BorderRadius.circular(13),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontSize: 20)),
                  ),
                  SvgPicture.asset(
                    AppIcons.arrowForward,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      theme.iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
