import 'package:flutter/material.dart';

/// Representation of an action card triggered by swiping left or right.
class SlideActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTrigger;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color foregroundColor;
  final BorderRadius? borderRadius;

  const SlideActionItem({
    required this.icon,
    required this.label,
    required this.onTrigger,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderRadius,
  });
}
