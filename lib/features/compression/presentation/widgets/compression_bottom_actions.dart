import 'package:flutter/material.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/app_action_button.dart';

class CompressionBottomActions extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback? onCompress;

  const CompressionBottomActions({
    super.key,
    required this.onAdd,
    this.onCompress,
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
            label: S.of(context).compress,
            variant: AppActionButtonVariant.filled,
            onPressed: onCompress,
          ),
        ),
      ],
    );
  }
}
