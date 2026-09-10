import 'package:flutter/material.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/app_action_button.dart';

class CompressionBottomActions extends StatelessWidget {
  final VoidCallback? onAdd;
  final VoidCallback? onCompress;
  final bool isImporting;
  final (int, int)? importProgress;

  const CompressionBottomActions({
    super.key,
    required this.onAdd,
    this.onCompress,
    this.isImporting = false,
    this.importProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppActionButton(
          width: 47,
          icon: AppIcons.plus,
          iconWidth: 22,
          iconHeight: 22,
          onPressed: onAdd,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppActionButton(
            width: double.infinity,
            label: isImporting
                ? [
                    S.of(context).loadingVideos,
                    if (importProgress case (final done, final total))
                      _fixedWidthProgress(done, total),
                  ].join(' ')
                : S.of(context).compress,
            loading: isImporting,
            fontSize: isImporting ? 18 : 25,
            variant: AppActionButtonVariant.filled,
            onPressed: isImporting ? null : onCompress,
          ),
        ),
      ],
    );
  }
}

String _fixedWidthProgress(int done, int total) {
  final doneText = done.toString();
  final totalText = total.toString();
  final padding = totalText.length - doneText.length;
  final leadingSpace = List.filled(padding > 0 ? padding : 0, '\u2007').join();
  return '$leadingSpace$doneText / $totalText';
}
