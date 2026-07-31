import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../widgets/app_action_button.dart';

class CompressionBottomActions extends StatelessWidget {
  final VoidCallback onCompress;

  const CompressionBottomActions({super.key, required this.onCompress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      width: double.infinity,
      child: AppActionButton(
        label: S.of(context).compress,
        variant: AppActionButtonVariant.filled,
        onPressed: onCompress,
      ),
    );
  }
}
