import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildNavAddButton({
  required ThemeData theme,
  required bool isDark,
  required VoidCallback? onAddPressed,
}) {
  final primaryColor = theme.colorScheme.primary;

  return Semantics(
    button: true,
    label: 'Add',
    child: Tooltip(
      message: 'Add',
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.16)
                : Colors.black.withValues(alpha: 0.08),
            width: 1.2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const ValueKey('nav_add_button'),
            onTap: () {
              HapticFeedback.lightImpact();
              onAddPressed?.call();
            },
            customBorder: const CircleBorder(),
            splashColor: Colors.white.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.12),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
          ),
        ),
      ),
    ),
  );
}
