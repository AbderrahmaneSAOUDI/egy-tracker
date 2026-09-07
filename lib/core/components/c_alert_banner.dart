import 'package:flutter/material.dart';

/// Visual severity of the alert banner.
enum AlertSeverity {
  info,
  warning,
  error,
}

/// Reusable alert / banner component for errors, warnings, and notifications.
class AlertBanner extends StatelessWidget {
  final String message;
  final AlertSeverity severity;
  final IconData? customIcon;
  final EdgeInsetsGeometry margin;

  const AlertBanner({
    super.key,
    required this.message,
    this.severity = AlertSeverity.error,
    this.customIcon,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    Color bg;
    Color border;
    Color fg;
    IconData icon;

    switch (severity) {
      case AlertSeverity.error:
        bg = colorScheme.errorContainer.withValues(alpha: isDark ? 0.7 : 0.85);
        border = colorScheme.error.withValues(alpha: isDark ? 0.35 : 0.25);
        fg = colorScheme.onErrorContainer;
        icon = customIcon ?? Icons.error_outline_rounded;
        break;
      case AlertSeverity.warning:
        bg = Colors.amber.withValues(alpha: isDark ? 0.2 : 0.15);
        border = Colors.amber.withValues(alpha: isDark ? 0.4 : 0.3);
        fg = isDark ? Colors.amber.shade200 : Colors.amber.shade900;
        icon = customIcon ?? Icons.warning_amber_rounded;
        break;
      case AlertSeverity.info:
        bg = colorScheme.primaryContainer.withValues(alpha: isDark ? 0.2 : 0.15);
        border = colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.25);
        fg = isDark ? colorScheme.primary : colorScheme.onPrimaryContainer;
        icon = customIcon ?? Icons.info_outline_rounded;
        break;
    }

    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: fg),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
