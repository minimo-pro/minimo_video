import 'package:flutter/material.dart';
import 'package:reel_text/reel_text.dart';

class RollingCounterText extends StatefulWidget {
  final num value;
  final String Function(num value) formatter;
  final TextStyle style;

  const RollingCounterText({
    super.key,
    required this.value,
    required this.formatter,
    required this.style,
  });

  @override
  State<RollingCounterText> createState() => _RollingCounterTextState();
}

class _RollingCounterTextState extends State<RollingCounterText> {
  num? _previousValue;

  @override
  void didUpdateWidget(covariant RollingCounterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    _previousValue ??= widget.value;

    final up = widget.value >= _previousValue!;
    _previousValue = widget.value;

    final fontSize = widget.style.fontSize ?? 14;
    final height = fontSize * 1.8;

    return ClipRect(
      child: SizedBox(
        height: height,
        child: Center(
          child: ReelText(
            widget.formatter(widget.value),
            options: ReelTextOptions(
              direction: up ? ReelTextDirection.up : ReelTextDirection.down,
            ),
            style: widget.style,
          ),
        ),
      ),
    );
  }
}
