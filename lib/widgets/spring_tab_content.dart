import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringTabContent extends StatefulWidget {
  final Object value;
  final Widget child;

  const SpringTabContent({super.key, required this.value, required this.child});

  @override
  State<SpringTabContent> createState() => _SpringTabContentState();
}

class _SpringTabContentState extends State<SpringTabContent>
    with SingleTickerProviderStateMixin {
  static const _spring = SpringDescription(
    mass: 0.55,
    stiffness: 230,
    damping: 20,
  );

  late final AnimationController _controller;
  late Widget _currentChild;
  Widget? _previousChild;
  bool _forward = true;

  @override
  void initState() {
    super.initState();
    _currentChild = widget.child;
    _controller = AnimationController.unbounded(vsync: this, value: 1);
  }

  @override
  void didUpdateWidget(covariant SpringTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) {
      _currentChild = widget.child;
      return;
    }

    _forward = _indexOf(widget.value) >= _indexOf(oldWidget.value);
    _previousChild = oldWidget.child;
    _currentChild = widget.child;
    _controller.value = 0;
    _controller.animateWith(
      SpringSimulation(_spring, 0, 1, _controller.velocity),
    );
  }

  int _indexOf(Object value) {
    if (value is Enum) return value.index;
    return value.hashCode;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _controller.value;
            final direction = _forward ? 1.0 : -1.0;
            final incomingOffset = (1 - progress) * 28 * direction;
            final outgoingOffset = -progress * 18 * direction;

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                if (_previousChild != null && progress < 1)
                  Opacity(
                    opacity: (1 - progress).clamp(0, 1),
                    child: Transform.translate(
                      offset: Offset(outgoingOffset, 0),
                      child: Transform.scale(
                        scale: 1 - progress.clamp(0, 1) * 0.025,
                        alignment: Alignment.topCenter,
                        child: _previousChild,
                      ),
                    ),
                  ),
                Opacity(
                  opacity: progress.clamp(0, 1),
                  child: Transform.translate(
                    offset: Offset(incomingOffset, 0),
                    child: Transform.scale(
                      scale: 0.975 + progress.clamp(0, 1) * 0.025,
                      alignment: Alignment.topCenter,
                      child: _currentChild,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
