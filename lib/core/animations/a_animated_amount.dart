import 'package:flutter/material.dart';

/// Smoothly animates numeric currency changes (e.g. balance updates or counter increments).
class AnimatedAmount extends StatelessWidget {
  final double amount;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final int fractionDigits;

  const AnimatedAmount({
    super.key,
    required this.amount,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    this.fractionDigits = 2,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: amount),
      duration: duration,
      curve: curve,
      builder: (context, value, _) {
        final formatted = (fractionDigits == 0 || (value % 1 == 0 && fractionDigits <= 2))
            ? value.toStringAsFixed(value % 1 == 0 ? 0 : fractionDigits)
            : value.toStringAsFixed(fractionDigits);

        return Text(
          '$prefix$formatted$suffix',
          style: style,
        );
      },
    );
  }
}
