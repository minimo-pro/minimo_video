import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppSnackBarType { info, success, error }

abstract final class AppSnackBar {
  static final List<_SnackBarEntry> _entries = [];

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 280),
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    _entries.removeWhere((entry) => !entry.overlayEntry.mounted);

    final duplicate = _findEntry(message, type);
    if (duplicate != null) {
      if (identical(_entries.last, duplicate)) {
        duplicate.key.currentState?.replay(duration);
        return;
      }

      duplicate.overlayEntry.remove();
      _entries.remove(duplicate);
      _insert(
        overlay,
        message: message,
        type: type,
        duration: duration,
        animationDuration: animationDuration,
        shakeOnShow: true,
      );
      return;
    }

    _insert(
      overlay,
      message: message,
      type: type,
      duration: duration,
      animationDuration: animationDuration,
    );
  }

  static _SnackBarEntry? _findEntry(String message, AppSnackBarType type) {
    for (final entry in _entries) {
      if (entry.message == message && entry.type == type) return entry;
    }
    return null;
  }

  static void _insert(
    OverlayState overlay, {
    required String message,
    required AppSnackBarType type,
    required Duration duration,
    required Duration animationDuration,
    bool shakeOnShow = false,
  }) {
    final snackBarEntry = _SnackBarEntry(message: message, type: type);
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _AppSnackBarOverlay(
        key: snackBarEntry.key,
        message: message,
        type: type,
        duration: duration,
        animationDuration: animationDuration,
        shakeOnShow: shakeOnShow,
        onDismissed: () {
          if (overlayEntry.mounted) overlayEntry.remove();
          _entries.remove(snackBarEntry);
        },
      ),
    );

    snackBarEntry.overlayEntry = overlayEntry;
    _entries.add(snackBarEntry);
    overlay.insert(overlayEntry);
  }
}

class _SnackBarEntry {
  final String message;
  final AppSnackBarType type;
  final key = GlobalKey<_AppSnackBarOverlayState>();
  late final OverlayEntry overlayEntry;

  _SnackBarEntry({required this.message, required this.type});
}

class _AppSnackBarOverlay extends StatefulWidget {
  final String message;
  final AppSnackBarType type;
  final Duration duration;
  final Duration animationDuration;
  final bool shakeOnShow;
  final VoidCallback onDismissed;

  const _AppSnackBarOverlay({
    super.key,
    required this.message,
    required this.type,
    required this.duration,
    required this.animationDuration,
    this.shakeOnShow = false,
    required this.onDismissed,
  });

  @override
  State<_AppSnackBarOverlay> createState() => _AppSnackBarOverlayState();
}

class _AppSnackBarOverlayState extends State<_AppSnackBarOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _shakeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _shakeAnimation;
  Timer? _dismissTimer;
  late Duration _duration;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: const Duration(milliseconds: 210),
    );
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _fadeAnimation = curvedAnimation;
    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(curvedAnimation);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(curvedAnimation);
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _shakeAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
        TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 8.0, end: -5.0), weight: 2),
        TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0), weight: 1),
      ],
    ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));

    _controller.forward();
    _duration = widget.duration;
    _restartTimer();
    if (widget.shakeOnShow) _shakeController.forward();
  }

  void replay(Duration duration) {
    if (!mounted) return;
    _duration = duration;
    _isDismissing = false;
    _controller.forward();
    _shakeController.forward(from: 0);
    _restartTimer();
  }

  void _restartTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(_duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted || _isDismissing) return;
    _isDismissing = true;
    _dismissTimer?.cancel();
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Positioned(
      left: 18,
      right: 18,
      top: mediaQuery.padding.top + 14,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              final dx = mediaQuery.disableAnimations
                  ? 0.0
                  : _shakeAnimation.value;
              return Transform.translate(offset: Offset(dx, 0), child: child);
            },
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.topCenter,
              child: _SnackBarCard(
                message: widget.message,
                type: widget.type,
                onTap: _dismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SnackBarCard extends StatelessWidget {
  final String message;
  final AppSnackBarType type;
  final VoidCallback onTap;

  const _SnackBarCard({
    required this.message,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (type) {
      AppSnackBarType.info => Colors.black,
      AppSnackBarType.success => LightModeColors.success,
      AppSnackBarType.error => LightModeColors.accent,
    };

    return Semantics(
      container: true,
      liveRegion: true,
      label: message,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: LightModeColors.onAccent,
                fontSize: 17,
                height: 1.15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
