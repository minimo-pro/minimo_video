import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../screens/info_screen.dart';
import '../screens/settings_screen.dart';
import '../theme/app_theme.dart';
import 'pressable.dart';

void _showFullScreenSheet(BuildContext context, Widget child) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.90,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (context) => Column(
      children: [
        Container(
          width: 36,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(child: child),
      ],
    ),
  );
}

class BottomFrame extends StatelessWidget {
  const BottomFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: theme.frameBackgroundColor.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.frameBorderColor, width: 2),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FrameButton(
                icon: AppIcons.settings,
                onTap: () =>
                    _showFullScreenSheet(context, const SettingsScreen()),
              ),
              Container(
                width: 1,
                height: 32,
                color: theme.frameBorderColor.withValues(alpha: 0.5),
              ),
              _FrameButton(
                icon: AppIcons.info,
                onTap: () => _showFullScreenSheet(context, const InfoScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FrameButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _FrameButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Pressable(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            child: SvgPicture.asset(
              icon,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(theme.iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
