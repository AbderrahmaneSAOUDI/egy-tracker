import 'package:flutter/material.dart';

/// Reusable combined fade and slide transition widget.
class FadeSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Offset beginOffset;
  final Offset endOffset;
  final Widget child;

  const FadeSlideTransition({
    super.key,
    required this.animation,
    this.beginOffset = const Offset(0, 0.10),
    this.endOffset = Offset.zero,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final slide = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(animation);

    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
