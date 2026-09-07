import 'package:flutter/material.dart';

/// Smoothly animates expansion and collapse of content (e.g. split percentage sliders, details).
class AnimatedExpandable extends StatelessWidget {
  final bool isExpanded;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedExpandable({
    super.key,
    required this.isExpanded,
    required this.child,
    this.duration = const Duration(milliseconds: 260),
    this.curve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox(width: double.infinity, height: 0),
      secondChild: child,
      crossFadeState: isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: duration,
      sizeCurve: curve,
      firstCurve: curve,
      secondCurve: curve,
    );
  }
}
