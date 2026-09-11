import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/t_app_theme.dart';

Widget buildNavExchangeButton({
  required bool isDark,
  required VoidCallback? onExchangePressed,
}) {
  final exchangeColor = isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue;

  return Semantics(
    button: true,
    label: 'Add Exchange',
    child: Tooltip(
      message: 'Add Exchange',
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [exchangeColor, exchangeColor.withValues(alpha: 0.88)],
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
              color: exchangeColor.withValues(alpha: isDark ? 0.45 : 0.35),
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
            key: const ValueKey('nav_exchange_button'),
            onTap: () {
              HapticFeedback.lightImpact();
              onExchangePressed?.call();
            },
            customBorder: const CircleBorder(),
            splashColor: Colors.white.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.12),
            child: const Icon(Icons.sync_alt_rounded, color: Colors.white, size: 23),
          ),
        ),
      ),
    ),
  );
}
