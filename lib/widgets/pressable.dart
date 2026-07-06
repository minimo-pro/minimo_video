import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class Pressable extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const Pressable({super.key, required this.child, this.enabled = true});

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  double _scale = 1;

  void _setPressed(bool pressed) {
    if (!mounted) return;
    final scale = pressed && widget.enabled ? 0.96 : 1.0;
    if (scale != _scale) setState(() => _scale = scale);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: widget.enabled ? (_) => _setPressed(true) : null,
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: SingleMotionBuilder(
        motion: switch (defaultTargetPlatform) {
          TargetPlatform.iOS ||
          TargetPlatform.macOS => CupertinoMotion.smooth(),
          _ => MaterialSpringMotion.standardSpatialFast(),
        },
        value: reduceMotion ? 1 : _scale,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: widget.child,
      ),
    );
  }
}
