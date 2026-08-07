import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pressable.dart';

class HoldToConfirmButton extends StatefulWidget {
  final String label;
  final String trailing;
  final bool enabled;
  final bool actionStyle;
  final double? fontSize;
  final VoidCallback onTap;
  final Future<void> Function() onCompleted;

  const HoldToConfirmButton({
    super.key,
    required this.label,
    this.trailing = '',
    required this.enabled,
    this.actionStyle = false,
    this.fontSize,
    required this.onTap,
    required this.onCompleted,
  });

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _completedHold = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1500),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) _complete();
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    _completedHold = true;
    await widget.onCompleted();
    if (mounted) _controller.reset();
  }

  void _tap() {
    if (_completedHold) {
      _completedHold = false;
      return;
    }
    widget.onTap();
  }

  Widget _content(Color textColor, Color trailingColor) {
    if (widget.actionStyle) {
      return Center(
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize ?? 25,
            height: 1,
            color: textColor,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize ?? 16,
                color: textColor,
              ),
            ),
          ),
          Text(widget.trailing, style: TextStyle(color: trailingColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final enabled = widget.enabled;

    return Pressable(
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _controller.forward(from: 0) : null,
        onTapUp: enabled ? (_) => _controller.reset() : null,
        onTapCancel: enabled
            ? () {
                _controller.reset();
                _completedHold = false;
              }
            : null,
        onTap: enabled ? _tap : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.actionStyle ? 13 : 18),
          child: SizedBox(
            height: widget.actionStyle ? 47 : 57,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: widget.actionStyle
                      ? BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        )
                      : BoxDecoration(
                          color: theme.frameBackgroundColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                  child: _content(
                    enabled ? theme.textColor : theme.secondaryTextColor,
                    enabled ? theme.accentColor : theme.secondaryTextColor,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => ClipRect(
                    clipper: _HorizontalProgressClipper(_controller.value),
                    child: ColoredBox(
                      color: theme.accentColor,
                      child: _content(theme.onAccentColor, theme.onAccentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalProgressClipper extends CustomClipper<Rect> {
  final double progress;

  const _HorizontalProgressClipper(this.progress);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * progress, size.height);

  @override
  bool shouldReclip(_HorizontalProgressClipper oldClipper) =>
      progress != oldClipper.progress;
}
