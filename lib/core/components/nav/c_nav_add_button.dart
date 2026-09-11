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
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withValues(alpha: 0.88)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.28) : Colors.white.withValues(alpha: 0.70),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: isDark ? 0.45 : 0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: isDark ? 0.20 : 0.45),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
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
            child: Icon(Icons.add_rounded, color: theme.colorScheme.onPrimary, size: 24),
          ),
        ),
      ),
    ),
  );
}
