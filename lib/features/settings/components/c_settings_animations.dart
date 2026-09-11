import 'package:flutter/material.dart';

/// Staggered animations manager for the settings screen.
class SettingsAnimations {
  final AnimationController controller;
  late final Animation<double> profile;
  late final Animation<double> theme;
  late final Animation<double> balances;
  late final Animation<double> emails;
  late final Animation<double> data;

  SettingsAnimations(TickerProvider vsync)
      : controller = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 750),
        ) {
    profile = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.40, curve: Curves.easeOutCubic),
    );
    theme = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
    );
    balances = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.30, 0.70, curve: Curves.easeOutCubic),
    );
    emails = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
    );
    data = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.60, 1.0, curve: Curves.easeOutCubic),
    );
  }

  void forward() => controller.forward();
  void dispose() => controller.dispose();
}
