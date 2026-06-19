import 'package:flutter/material.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/app_action_button.dart';

class CompressionBottomActions extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCompress;

  const CompressionBottomActions({
    super.key,
    required this.onBack,
    required this.onCompress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: Row(
        children: [
          AppActionButton(
            width: 70,
            icon: AppIcons.arrowBack,
            iconWidth: 21,
            iconHeight: 28,
            padding: EdgeInsets.zero,
            onPressed: onBack,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppActionButton(
              label: S.of(context).compress,
              variant: AppActionButtonVariant.filled,
              onPressed: onCompress,
            ),
          ),
        ],
      ),
    );
  }
}
