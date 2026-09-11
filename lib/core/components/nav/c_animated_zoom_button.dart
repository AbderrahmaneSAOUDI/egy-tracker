import 'package:flutter/material.dart';

/// Zoom in/out animated button wrapper for bottom nav action buttons.
class AnimatedZoomButton extends StatefulWidget {
  final bool visible;
  final bool isLeft;
  final Widget child;

  const AnimatedZoomButton({
    super.key,
    required this.visible,
    required this.isLeft,
    required this.child,
  });

  @override
  State<AnimatedZoomButton> createState() => _AnimatedZoomButtonState();
}

class _AnimatedZoomButtonState extends State<AnimatedZoomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.visible ? 1.0 : 0.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedZoomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      widget.visible ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hiddenKey = ValueKey(
      widget.isLeft ? 'nav_exchange_button_hidden' : 'nav_add_button_hidden',
    );
    final containerKey = ValueKey(
      widget.isLeft ? 'nav_exchange_button_container' : 'nav_add_button_container',
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.isDismissed && !widget.visible) {
          return SizedBox.shrink(key: hiddenKey);
        }
        return ClipRect(
          child: Align(
            alignment: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
            widthFactor: _scaleAnimation.value.clamp(0.0, 1.0),
            heightFactor: 1.0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  key: containerKey,
                  padding: EdgeInsets.only(
                    right: widget.isLeft ? 8 : 0,
                    left: widget.isLeft ? 0 : 8,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
