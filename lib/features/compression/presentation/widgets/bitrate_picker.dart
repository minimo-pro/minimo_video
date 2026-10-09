import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../generated/l10n.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_action_button.dart';

class BitratePicker extends StatefulWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const BitratePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<BitratePicker> createState() => _BitratePickerState();
}

class _BitratePickerState extends State<BitratePicker> {
  late int? _selected = widget.value;

  @override
  void didUpdateWidget(covariant BitratePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _selected = widget.value;
  }

  void _select(int? value) {
    if (value == _selected) return;
    setState(() => _selected = value);
    HapticFeedback.selectionClick();
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final sliderBitrate = (_selected ?? 2).clamp(1, 20);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Column(
        children: [
          Row(
            children: [
              AppActionButton(
                label: strings.automatic,
                variant: _selected == null
                    ? AppActionButtonVariant.filled
                    : AppActionButtonVariant.outlined,
                height: 40,
                fontSize: 16,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                onPressed: () => _select(null),
              ),
              const SizedBox(width: 12),
              if (_selected != null)
                Expanded(
                  child: Text(
                    '$_selected Mbps',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 25,
                      height: 1,
                      color: CompressionUiColors.red,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Semantics(
            label: strings.videoBitrate,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                activeTrackColor: _selected == null
                    ? colors.outline
                    : CompressionUiColors.red,
                inactiveTrackColor: colors.outline,
                thumbColor: _selected == null
                    ? colors.outline
                    : CompressionUiColors.red,
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: const _BitrateThumb(),
                trackShape: const _DrawnBitrateTrack(),
                activeTickMarkColor: _selected == null
                    ? colors.outline
                    : CompressionUiColors.red,
                inactiveTickMarkColor: colors.outline,
                tickMarkShape: const RoundSliderTickMarkShape(
                  tickMarkRadius: 1.5,
                ),
              ),
              child: Slider(
                value: sliderBitrate.toDouble(),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                min: 1,
                max: 20,
                divisions: 19,
                semanticFormatterCallback: (value) =>
                    _selected == null && value.round() == sliderBitrate
                    ? strings.automatic
                    : '${value.round()} Mbps',
                onChanged: (value) => _select(value.round()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1 Mbps',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  '20 Mbps',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BitrateThumb extends SliderComponentShape {
  const _BitrateThumb();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(28, 28);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final outline = Path()
      ..moveTo(0, -14)
      ..cubicTo(8, -14.5, 14, -7, 14, 0.5)
      ..cubicTo(14, 8, 7, 14, -0.5, 14)
      ..cubicTo(-8, 14, -14, 7, -14, -0.5)
      ..cubicTo(-14, -8, -7, -14, 0, -14)
      ..close();
    canvas.drawPath(
      outline.shift(center),
      Paint()..color = sliderTheme.thumbColor!,
    );
  }
}

class _DrawnBitrateTrack extends SliderTrackShape with BaseSliderTrackShape {
  const _DrawnBitrateTrack();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final x = rect.left;
    final y = rect.center.dy;
    final w = rect.width;
    // Fixed curves keep the drawn line still while the thumb moves.
    final line = Path()
      ..moveTo(x, y + 0.6)
      ..cubicTo(x + w * 0.12, y - 1.8, x + w * 0.24, y + 1.6, x + w * 0.36, y)
      ..cubicTo(
        x + w * 0.5,
        y - 1.4,
        x + w * 0.62,
        y + 1.8,
        x + w * 0.74,
        y + 0.4,
      )
      ..cubicTo(
        x + w * 0.84,
        y - 1,
        x + w * 0.93,
        y + 1.3,
        rect.right,
        y - 0.4,
      );
    final pen = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = sliderTheme.trackHeight!
      ..color = sliderTheme.inactiveTrackColor!;
    final canvas = context.canvas;
    canvas.drawPath(line, pen);
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(
        textDirection == TextDirection.ltr ? rect.left - 3 : thumbCenter.dx,
        rect.top - 3,
        textDirection == TextDirection.ltr ? thumbCenter.dx : rect.right + 3,
        rect.bottom + 3,
      ),
    );
    canvas.drawPath(line, pen..color = sliderTheme.activeTrackColor!);
    canvas.restore();
  }
}
