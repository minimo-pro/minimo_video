import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/l10n.dart';
import '../theme/app_theme.dart';
import 'pressable.dart';

class PhotoAppCard extends StatelessWidget {
  const PhotoAppCard({super.key});

  static final _appStoreUrl = Uri.parse(
    'https://apps.apple.com/us/app/minimo-photo-compressor/id6822256099',
  );
  static final _googlePlayUrl = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.khlebobul.minimo_photo',
  );

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Pressable(
      child: Material(
        color: theme.frameBackgroundColor,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: () => launchUrl(
            Platform.isIOS ? _appStoreUrl : _googlePlayUrl,
            mode: LaunchMode.externalApplication,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/logo/photo.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'minimo (photo)',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        S.of(context).photoAppDescription,
                        style: TextStyle(
                          color: theme.textColor,
                          fontSize: 15,
                          height: 1.25,
                        ),
                      ),
                    ],
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
