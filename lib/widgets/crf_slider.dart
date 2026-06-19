import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../features/compression/presentation/utils/compression_labels.dart';
import '../generated/l10n.dart';
import '../theme/app_colors.dart';

class CrfSlider extends StatelessWidget {
  static const min = 18.0;
  static const max = 33.0;

  final double value;
  final ValueChanged<double> onChanged;

  const CrfSlider({super.key, required this.value, required this.onChanged});

  void _updateValue(double localX, double width) {
    final progress = (localX / width).clamp(0.0, 1.0);
    onChanged((min + progress * (max - min)).roundToDouble());
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: CompressionUiColors.lightGrey.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CompressionUiColors.grey),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  CompressionLabels.quality(value, strings),
                  key: ValueKey(CompressionLabels.quality(value, strings)),
                  style: const TextStyle(
                    color: CompressionUiColors.dark,
                    fontSize: 20,
                    height: 1,
                  ),
                ),
              ),
              Text(
                strings.crfValue(value.toInt()),
                style: const TextStyle(
                  color: CompressionUiColors.grey,
                  fontSize: 15,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Semantics(
            slider: true,
            value: value.toInt().toString(),
            increasedValue: (value + 1).clamp(min, max).toInt().toString(),
            decreasedValue: (value - 1).clamp(min, max).toInt().toString(),
            onIncrease: () => onChanged((value + 1).clamp(min, max)),
            onDecrease: () => onChanged((value - 1).clamp(min, max)),
            child: ExcludeSemantics(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) {
                      _updateValue(
                        details.localPosition.dx,
                        constraints.maxWidth,
                      );
                    },
                    onHorizontalDragUpdate: (details) {
                      _updateValue(
                        details.localPosition.dx,
                        constraints.maxWidth,
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: (value - min) / (max - min),
                          end: (value - min) / (max - min),
                        ),
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        builder: (context, progress, child) {
                          return CustomPaint(
                            painter: _HandDrawnSliderPainter(
                              progress: progress,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.better,
                style: const TextStyle(
                  color: CompressionUiColors.grey,
                  fontSize: 13,
                ),
              ),
              Text(
                strings.smaller,
                style: const TextStyle(
                  color: CompressionUiColors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HandDrawnSliderPainter extends CustomPainter {
  final double progress;

  const _HandDrawnSliderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final startX = 8.0;
    final endX = size.width - 8;
    final activeEnd = startX + (endX - startX) * progress;

    final inactivePath = _createLine(startX, endX, centerY);
    canvas.drawPath(
      inactivePath,
      Paint()
        ..color = CompressionUiColors.grey.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, activeEnd, size.height));
    canvas.drawPath(
      inactivePath,
      Paint()
        ..color = CompressionUiColors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();

    for (var index = 0; index < 6; index++) {
      final x = startX + (endX - startX) * index / 5;
      final tickHeight = index == 0 || index == 5 ? 13.0 : 9.0;
      final tickCenterY = centerY + math.sin(index * 2.1) * 0.6;
      canvas.drawLine(
        Offset(x, tickCenterY - tickHeight / 2),
        Offset(x, tickCenterY + tickHeight / 2),
        Paint()
          ..color = x <= activeEnd
              ? CompressionUiColors.red
              : CompressionUiColors.grey
          ..strokeWidth = index == 0 || index == 5 ? 2.8 : 2.2
          ..strokeCap = StrokeCap.round,
      );
    }

    final markerCenter = Offset(
      activeEnd,
      centerY + math.sin(progress * math.pi * 6) * 0.8,
    );
    canvas.drawCircle(
      markerCenter,
      9,
      Paint()..color = CompressionUiColors.red,
    );
  }

  Path _createLine(double startX, double endX, double centerY) {
    final path = Path();
    const segments = 36;
    for (var index = 0; index <= segments; index++) {
      final position = index / segments;
      final x = startX + (endX - startX) * position;
      final y =
          centerY +
          math.sin(position * math.pi * 7) * 0.7 +
          math.sin(position * math.pi * 17) * 0.3;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _HandDrawnSliderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
