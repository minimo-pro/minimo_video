import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../../../../generated/l10n.dart';
import '../../../../widgets/pressable.dart';

enum CompressionOptionsMode { simple, advanced }

class CompressionModeSwitch extends StatefulWidget {
  final CompressionOptionsMode value;
  final ValueChanged<CompressionOptionsMode> onChanged;

  const CompressionModeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CompressionModeSwitch> createState() => _CompressionModeSwitchState();
}

class _CompressionModeSwitchState extends State<CompressionModeSwitch>
    with SingleTickerProviderStateMixin {
  static const _spring = SpringDescription(
    mass: 0.55,
    stiffness: 260,
    damping: 19,
  );

  late final AnimationController _controller;

  double get _target => widget.value == CompressionOptionsMode.simple ? 0 : 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this, value: _target);
  }

  @override
  void didUpdateWidget(covariant CompressionModeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) return;

    _controller.animateWith(
      SpringSimulation(
        _spring,
        _controller.value,
        _target,
        _controller.velocity,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(segmentWidth * _controller.value, 0),
                    child: child,
                  );
                },
                child: SizedBox(
                  width: segmentWidth,
                  height: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _ModeButton(
                    label: strings.simpleOptions,
                    mode: CompressionOptionsMode.simple,
                    selected: widget.value == CompressionOptionsMode.simple,
                    onTap: widget.onChanged,
                  ),
                  _ModeButton(
                    label: strings.advancedOptions,
                    mode: CompressionOptionsMode.advanced,
                    selected: widget.value == CompressionOptionsMode.advanced,
                    onTap: widget.onChanged,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final CompressionOptionsMode mode;
  final bool selected;
  final ValueChanged<CompressionOptionsMode> onTap;

  const _ModeButton({
    required this.label,
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Pressable(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(mode),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: selected ? 14.5 : 14,
                height: 1,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
