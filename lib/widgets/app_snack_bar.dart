import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppSnackBarType { info, success, error }

abstract final class AppSnackBar {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 280),
  }) {
    _currentEntry?.remove();

    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _AppSnackBarOverlay(
        message: message,
        type: type,
        duration: duration,
        animationDuration: animationDuration,
        onDismissed: () {
          if (entry.mounted) entry.remove();
          if (identical(_currentEntry, entry)) _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _AppSnackBarOverlay extends StatefulWidget {
  final String message;
  final AppSnackBarType type;
  final Duration duration;
  final Duration animationDuration;
  final VoidCallback onDismissed;

  const _AppSnackBarOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.animationDuration,
    required this.onDismissed,
  });

  @override
  State<_AppSnackBarOverlay> createState() => _AppSnackBarOverlayState();
}

class _AppSnackBarOverlayState extends State<_AppSnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;
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
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(curvedAnimation);

    _controller.forward();
    _dismissTimer = Timer(widget.duration, _dismiss);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Positioned(
      left: 18,
      right: 18,
      bottom: mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom + 14,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            alignment: Alignment.bottomCenter,
            child: _SnackBarCard(
              message: widget.message,
              type: widget.type,
              onTap: _dismiss,
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
