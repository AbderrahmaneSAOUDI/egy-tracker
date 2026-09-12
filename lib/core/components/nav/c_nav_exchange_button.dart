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
          color: exchangeColor,
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
