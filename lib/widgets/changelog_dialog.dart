import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../services/changelog_service.dart';
import '../theme/app_theme.dart';
import 'app_action_button.dart';

Future<void> showChangelogDialog(
  BuildContext context,
  ChangelogUpdate update,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _ChangelogDialog(update: update),
  );
  await ChangelogService.instance.dismiss();
}

class _ChangelogDialog extends StatelessWidget {
  final ChangelogUpdate update;

  const _ChangelogDialog({required this.update});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = AppTheme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.frameBorderColor, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.changelogTitle(update.version),
                  style: textTheme.headlineSmall?.copyWith(
                    color: theme.textColor,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.changelogSubtitle,
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.secondaryTextColor,
                    fontSize: 16,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 18),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final change in update.changes)
                          _ChangeRow(text: change),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: AppActionButton(
                    label: strings.changelogDone,
                    variant: AppActionButtonVariant.filled,
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: theme.accentColor,
                    foregroundColor: theme.onAccentColor,
                    fontSize: 19,
                    height: 50,
                    borderRadius: BorderRadius.circular(14),
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

class _ChangeRow extends StatelessWidget {
  final String text;

  const _ChangeRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.frameBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const SizedBox(width: 7, height: 7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: theme.textColor,
                    fontSize: 17,
                    height: 1.25,
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
