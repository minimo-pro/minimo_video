import 'dart:ui';

import 'package:flutter/material.dart';

class RollingCounterText extends StatefulWidget {
  final num value;
  final String Function(num value) formatter;
  final TextStyle style;
  final Duration duration;

  const RollingCounterText({
    super.key,
    required this.value,
    required this.formatter,
    required this.style,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  State<RollingCounterText> createState() => _RollingCounterTextState();
}

class _RollingCounterTextState extends State<RollingCounterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _startValue;
  late double _targetValue;

  double get _displayedValue {
    return lerpDouble(
          _startValue,
          _targetValue,
          Curves.easeOutCubic.transform(_controller.value),
        ) ??
        _targetValue;
  }

  @override
  void initState() {
    super.initState();
    _startValue = widget.value.toDouble();
    _targetValue = widget.value.toDouble();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..value = 1;
  }

  @override
  void didUpdateWidget(covariant RollingCounterText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.value == widget.value) return;

    _startValue = _displayedValue;
    _targetValue = widget.value.toDouble();
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.formatter(widget.value),
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Text(
              widget.formatter(_displayedValue),
              maxLines: 1,
              style: widget.style,
            );
          },
        ),
      ),
    );
  }
}
