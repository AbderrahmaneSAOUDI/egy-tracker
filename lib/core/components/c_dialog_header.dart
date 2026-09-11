import 'package:flutter/material.dart';
import 'c_icon_badge.dart';

/// Standardized header for AppDialog with icon badge, title, and optional subtitle.
class AppDialogHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;

  const AppDialogHeader({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final outlineColor = Theme.of(context).colorScheme.outline;
    return Row(
      children: [
        IconBadge(
          icon: icon,
          color: iconColor,
          size: 44,
          iconSize: 22,
          borderRadius: 14,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor ?? outlineColor,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
