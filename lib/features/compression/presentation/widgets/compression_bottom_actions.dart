import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../generated/l10n.dart';
import '../../../../theme/app_colors.dart';

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
          SizedBox(
            width: 70,
            height: 47,
            child: OutlinedButton(
              onPressed: onBack,
              style:
                  OutlinedButton.styleFrom(
                    backgroundColor: CompressionUiColors.lightGrey,
                    side: const BorderSide(color: CompressionUiColors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    padding: EdgeInsets.zero,
                  ).copyWith(
                    overlayColor: const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                    splashFactory: NoSplash.splashFactory,
                  ),
              child: SvgPicture.asset(
                AppIcons.arrowBack,
                width: 21,
                height: 28,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 47,
              child: FilledButton(
                onPressed: onCompress,
                style:
                    FilledButton.styleFrom(
                      backgroundColor: CompressionUiColors.red,
                      foregroundColor: CompressionUiColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ).copyWith(
                      overlayColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      splashFactory: NoSplash.splashFactory,
                    ),
                child: Text(
                  S.of(context).compress,
                  style: const TextStyle(fontSize: 25, height: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
