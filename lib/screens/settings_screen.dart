import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_icons.dart';
import '../generated/l10n.dart';
import '../services/app_cache_service.dart';
import '../services/app_settings_service.dart';
import '../services/utils.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_asset_checkbox.dart';
import '../widgets/app_snack_bar.dart';
import '../widgets/faded_scroll_view.dart';
import '../widgets/hold_to_confirm_button.dart';
import '../widgets/pressable.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsService.instance;
    final strings = S.of(context);

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AnimatedBuilder(
          animation: settings,
          builder: (context, _) => Column(
            children: [
              const _Header(),
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
                      _ToggleRow(
                        title: strings.addPrefix(AppSettingsService.appPrefix),
                        description: strings.addPrefixDescription(
                          AppSettingsService.appPrefix,
                        ),
                        value: settings.addKompressoPrefix,
                        onChanged: settings.setAddKompressoPrefix,
                      ),
                      _ToggleRow(
                        title: strings.showOverheatWarning,
                        description: strings.showOverheatWarningDescription,
                        value: settings.showOverheatWarning,
                        onChanged: settings.setShowOverheatWarning,
                      ),
                      _ToggleRow(
                        title: strings.saveVideosToAlbum,
                        description: strings.saveVideosToAlbumDescription(
                          AppSettingsService.albumName.toLowerCase(),
                        ),
                        value: settings.saveVideosToAlbum,
                        onChanged: settings.setSaveVideosToAlbum,
                      ),
                      _ToggleRow(
                        title: strings.deleteOriginalsAfterSaving,
                        description:
                            strings.deleteOriginalsAfterSavingDescription,
                        value: settings.deleteOriginalsAfterSaving,
                        onChanged: settings.setDeleteOriginalsAfterSaving,
                      ),
                      _ToggleRow(
                        title: strings.preventScreenSleep,
                        description: strings.preventScreenSleepDescription,
                        value: settings.preventScreenSleep,
                        onChanged: settings.setPreventScreenSleep,
                      ),
                      _ToggleRow(
                        title: strings.darkTheme,
                        description: strings.darkThemeDescription,
                        value:
                            settings.darkTheme ??
                            Theme.of(context).brightness == Brightness.dark,
                        onChanged: settings.setDarkTheme,
                      ),
                      const _CacheRow(),
                      _LanguageRow(settings: settings),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CacheRow extends StatefulWidget {
  const _CacheRow();

  @override
  State<_CacheRow> createState() => _CacheRowState();
}

class _CacheRowState extends State<_CacheRow> {
  int? _size;
  bool _clearing = false;

  @override
  void initState() {
    super.initState();
    _loadSize();
  }

  Future<void> _loadSize() async {
    final size = await AppCacheService.size();
    if (mounted) setState(() => _size = size);
  }

  Future<void> _clear() async {
    if (_clearing) return;
    _clearing = true;
    var cleared = false;
    try {
      await AppCacheService.clear();
      cleared = true;
      if (mounted) {
        AppSnackBar.show(
          context,
          message: S.of(context).cacheCleared,
          type: AppSnackBarType.success,
        );
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: S.of(context).cacheClearFailed,
          type: AppSnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          if (cleared) _size = 0;
          _clearing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final enabled = _size != null && _size! > 0 && !_clearing;
    return _SettingBlock(
      description: strings.clearCacheDescription,
      contentPadding: EdgeInsets.zero,
      framed: false,
      child: HoldToConfirmButton(
        label: strings.clearCache,
        trailing: _size == null ? '…' : Utils.formatSize(_size!),
        enabled: enabled,
        onTap: () =>
            AppSnackBar.show(context, message: strings.holdToClearCache),
        onCompleted: _clear,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final strings = S.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(strings.settings, style: textTheme.headlineSmall),
          ),
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
                colorFilter: ColorFilter.mode(theme.iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingBlock(
      description: description,
      child: Pressable(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(!value),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16)),
              ),
              IgnorePointer(
                child: AnimatedAssetCheckbox(
                  value: value,
                  onChanged: (_) {},
                  size: 31,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final AppSettingsService settings;

  const _LanguageRow({required this.settings});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final language = switch (settings.languageCode) {
      'en' => strings.english,
      'ru' => strings.russian,
      _ => strings.system,
    };

    return _SettingBlock(
      description: strings.languageDescription,
      child: Pressable(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showLanguageSheet(context),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  strings.language,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                language,
                style: TextStyle(color: AppTheme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLanguageSheet(BuildContext context) async {
    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LanguageSheet(selected: settings.languageCode),
    );
    if (value == null) return;
    final languageCode = value == 'system' ? null : value;
    if (languageCode == settings.languageCode) return;
    await settings.setLanguageCode(languageCode);
  }
}

class _LanguageSheet extends StatelessWidget {
  final String? selected;

  const _LanguageSheet({required this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strings = S.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LanguageOption(
                  value: 'system',
                  title: strings.system,
                  selected: selected == null,
                ),
                _LanguageOption(
                  value: 'en',
                  title: strings.english,
                  selected: selected == 'en',
                ),
                _LanguageOption(
                  value: 'ru',
                  title: strings.russian,
                  selected: selected == 'ru',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String value;
  final String title;
  final bool selected;

  const _LanguageOption({
    required this.value,
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Pressable(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(value),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.frameBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              height: 57,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(fontSize: 17)),
                    ),
                    IgnorePointer(
                      child: AnimatedAssetCheckbox(
                        value: selected,
                        onChanged: (_) {},
                        size: 31,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingBlock extends StatelessWidget {
  final Widget child;
  final String description;
  final EdgeInsetsGeometry contentPadding;
  final bool framed;

  const _SettingBlock({
    required this.child,
    required this.description,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 13,
    ),
    this.framed = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: framed ? theme.frameBackgroundColor : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: contentPadding,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 31),
                child: child,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              description,
              style: TextStyle(
                color: theme.secondaryTextColor,
                fontSize: 13,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
