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
  static const _upOptions = ReelTextOptions(
    direction: ReelTextDirection.up,
    duration: Duration(milliseconds: 220),
    stagger: Duration(milliseconds: 18),
    exitOffset: Duration(milliseconds: 24),
    curve: Cubic(0.22, 1, 0.36, 1),
    bounce: 0.08,
  );
  static const _downOptions = ReelTextOptions(
    direction: ReelTextDirection.down,
    duration: Duration(milliseconds: 220),
    stagger: Duration(milliseconds: 18),
    exitOffset: Duration(milliseconds: 24),
    curve: Cubic(0.22, 1, 0.36, 1),
    bounce: 0.08,
  );

  late String _text;
  late num _displayedValue;
  var _direction = ReelTextDirection.up;

  @override
  void initState() {
    super.initState();
    _text = widget.formatter(widget.value);
    _displayedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant RollingCounterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextText = widget.formatter(widget.value);
    if (nextText == _text) return;

    _direction = widget.value >= _displayedValue
        ? ReelTextDirection.up
        : ReelTextDirection.down;
    _displayedValue = widget.value;
    _text = nextText;
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.style.fontSize ?? 14;
    final height = fontSize * 1.8;

    return ClipRect(
      child: SizedBox(
        height: height,
        child: Center(
          child: ReelText(
            _text,
            options: _direction == ReelTextDirection.up
                ? _upOptions
                : _downOptions,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}
