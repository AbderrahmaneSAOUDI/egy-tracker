import 'package:flutter/material.dart';

BoxDecoration buildBalanceCardDecoration({
  required bool isDark,
  required bool isCurrentUser,
  required Color accentColor,
}) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: isDark
          ? [
              isCurrentUser ? const Color(0xFF1B202A) : const Color(0xFF191C24),
              const Color(0xFF13161C),
            ]
          : [
              Colors.white,
              isCurrentUser ? const Color(0xFFF8FAFC) : const Color(0xFFFAF5FF),
            ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: isDark
          ? (isCurrentUser ? const Color(0xFF2B3242) : const Color(0xFF262A36))
          : (isCurrentUser ? const Color(0xFFE2E8F0) : const Color(0xFFEDE9FE)),
      width: 1.2,
    ),
    boxShadow: [
      BoxShadow(
        color: isDark ? Colors.black.withValues(alpha: 0.35) : accentColor.withValues(alpha: 0.06),
        blurRadius: 14,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
