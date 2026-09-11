import 'package:flutter/material.dart';

BoxDecoration buildSectionCardDecoration({
  required bool isDark,
  Color? borderColor,
}) {
  return BoxDecoration(
    color: isDark
        ? const Color(0xFF17191E).withValues(alpha: 0.92)
        : Colors.white.withValues(alpha: 0.95),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: borderColor ??
          (isDark ? const Color(0xFF2A2E37) : const Color(0xFFE5E7EB)),
      width: 1.1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
      if (isDark)
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.03),
          blurRadius: 0,
          offset: const Offset(0, -1),
        ),
    ],
  );
}
