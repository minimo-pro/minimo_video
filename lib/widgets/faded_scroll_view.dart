import 'package:flutter/material.dart';

class FadedScrollView extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final double fadeExtent;

  const FadedScrollView({
    super.key,
    required this.child,
    this.padding,
    this.physics,
    this.fadeExtent = 0.1,
  });

  @override
  State<FadedScrollView> createState() => _FadedScrollViewState();
}

class _FadedScrollViewState extends State<FadedScrollView> {
  final _controller = ScrollController();
  bool _fadeStart = false;
  bool _fadeEnd = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateFades);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFades());
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_updateFades)
      ..dispose();
    super.dispose();
  }

  void _updateFades() {
    if (!_controller.hasClients) return;
    _updateFadesFor(_controller.position);
  }

  void _updateFadesFor(ScrollMetrics metrics) {
    final fadeStart = metrics.pixels > metrics.minScrollExtent + 1;
    final fadeEnd = metrics.pixels < metrics.maxScrollExtent - 1;
    if (fadeStart == _fadeStart && fadeEnd == _fadeEnd) return;
    setState(() {
      _fadeStart = fadeStart;
      _fadeEnd = fadeEnd;
    });
  }

  @override
  Widget build(BuildContext context) {
    final extent = widget.fadeExtent.clamp(0.0, 0.45);

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _fadeStart ? Colors.transparent : Colors.white,
            Colors.white,
            Colors.white,
            _fadeEnd ? Colors.transparent : Colors.white,
          ],
          stops: [0, extent, 1 - extent, 1],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          _updateFadesFor(notification.metrics);
          return false;
        },
        child: SingleChildScrollView(
          controller: _controller,
          padding: widget.padding,
          physics: widget.physics,
          child: widget.child,
        ),
      ),
    );
  }
}
