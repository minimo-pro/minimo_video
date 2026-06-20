import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_icons.dart';
import '../generated/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/faded_scroll_view.dart';

@RoutePage()
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static const _email = 'khlebobul@gmail.com';
  static final _appStoreApps = Uri.parse(
    'https://apps.apple.com/developer/gleb-shalimov/id1775466597',
  );
  static final _googlePlayApps = Uri.parse(
    'https://play.google.com/store/apps/developer?id=Gleb+Shalimov&hl=en',
  );
  static final _links = <String, Uri>{
    'project': Uri.parse('https://github.com/minimo-pro'),
    'telegram': Uri.parse('https://t.me/khlebobul_dev'),
    'github': Uri.parse('https://github.com/minimo-pro/minimo_video'),
    'x': Uri.parse('https://x.com/khlebobul'),
    'website': Uri.parse('https://khlebobul.github.io'),
  };

  Future<void> _open(String link) =>
      launchUrl(_links[link]!, mode: LaunchMode.externalApplication);

  Future<void> _openOtherApps() => launchUrl(
    Platform.isIOS ? _appStoreApps : _googlePlayApps,
    mode: LaunchMode.externalApplication,
  );

  Future<void> _sendEmail(BuildContext context) async {
    final strings = S.of(context);
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {'subject': 'feedback - ${strings.appName}'},
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return;
    }

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(strings.about, style: textTheme.headlineSmall),
                  ),
                  IconButton(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: context.maybePop,
                    icon: SvgPicture.asset(
                      AppIcons.close,
                      width: 32,
                      height: 32,
                      colorFilter: ColorFilter.mode(
                        theme.iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadedScrollView(
                fadeExtent: 0.08,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
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
                    const SizedBox(height: 28),
                    _InfoLink(title: strings.rateTheApp),
                    _InfoLink(title: strings.shareWithFriends),
                    _InfoLink(
                      title: strings.projectWebsite,
                      onTap: () => _open('project'),
                    ),
                    _InfoLink(
                      title: strings.myOtherApps,
                      onTap: _openOtherApps,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      strings.openSourceNote,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: theme.secondaryTextColor,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialLink(
                          icon: AppIcons.code,
                          onTap: () => _open('github'),
                        ),
                        _SocialLink(icon: AppIcons.x, onTap: () => _open('x')),
                        _SocialLink(
                          icon: AppIcons.mail,
                          onTap: () => _sendEmail(context),
                        ),
                        _SocialLink(
                          icon: AppIcons.website,
                          onTap: () => _open('website'),
                        ),
                      ],
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

class _InfoLink extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _InfoLink({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.frameBackgroundColor,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
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
    );
  }
}

class _SocialLink extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;

  const _SocialLink({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return IconButton(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: onTap,
      iconSize: 26,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      color: theme.iconColor,
      icon: SvgPicture.asset(
        icon,
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(theme.iconColor, BlendMode.srcIn),
      ),
    );
  }
}
