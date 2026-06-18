import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MinimoLoader extends StatefulWidget {
  final double size;
  final String? semanticsLabel;

  const MinimoLoader({super.key, this.size = 52, this.semanticsLabel});

  @override
  State<MinimoLoader> createState() => _MinimoLoaderState();
}

class _MinimoLoaderState extends State<MinimoLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Semantics(
      label: widget.semanticsLabel,
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: widget.size,
          child: CustomPaint(
            painter: _HandDrawnLoaderPainter(
              animation: _controller,
              lineColor: theme.iconColor,
              accentColor: theme.accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _HandDrawnLoaderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color lineColor;
  final Color accentColor;

  _HandDrawnLoaderPainter({
    required this.animation,
    required this.lineColor,
    required this.accentColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.36;
    final rotation = animation.value * math.pi * 2;
    final path = Path();

    const startAngle = 0.28;
    const sweepAngle = math.pi * 1.62;
    const segments = 48;

    for (var index = 0; index <= segments; index++) {
      final progress = index / segments;
      final angle = startAngle + sweepAngle * progress + rotation;
      final wobble =
          math.sin(progress * math.pi * 6) * size.shortestSide * 0.008;
      final pointRadius = radius + wobble;
      final point = Offset(
        center.dx + math.cos(angle) * pointRadius,
        center.dy + math.sin(angle) * pointRadius,
      );

      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final strokeWidth = size.shortestSide * 0.042;
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final endAngle = startAngle + sweepAngle + rotation;
    final endPoint = Offset(
      center.dx + math.cos(endAngle) * radius,
      center.dy + math.sin(endAngle) * radius,
    );
    canvas.drawCircle(
      endPoint,
      strokeWidth * 1.35,
      Paint()..color = accentColor,
    );
  }

  @override
  bool shouldRepaint(covariant _HandDrawnLoaderPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.accentColor != accentColor;
  }
}
