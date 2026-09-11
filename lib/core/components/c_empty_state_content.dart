import 'package:flutter/material.dart';
import 'c_empty_state_icon.dart';

/// Column layout for empty state with icon, title, subtitle, and action.
class EmptyStateContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final bool isDark;
  final Widget? action;

  const EmptyStateContent({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.iconColor,
    required this.isDark,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final outlineColor = Theme.of(context).colorScheme.outline;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptyStateIcon(
          icon: icon,
          color: iconColor,
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(fontSize: 12, color: outlineColor),
            textAlign: TextAlign.center,
          ),
        ],
        if (action != null) ...[
          const SizedBox(height: 16),
          action!,
        ],
      ],
    );
  }
}
