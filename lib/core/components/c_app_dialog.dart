import 'package:flutter/material.dart';
import 'c_icon_badge.dart';

export '../animations/a_dialog_transition.dart';

/// Reusable application dialog shell with unified styling,
/// title badge, content padding, and standardized Cancel + Action buttons.
class AppDialog extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? borderColor;
  final Widget content;
  final String actionLabel;
  final Color? actionColor;
  final Color? actionForegroundColor;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback? onAction;

  const AppDialog({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.borderColor,
    required this.content,
    required this.actionLabel,
    this.actionColor,
    this.actionForegroundColor,
    this.isSubmitting = false,
    required this.onCancel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: borderColor ??
              (isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0)),
          width: 1.2,
        ),
      ),
      backgroundColor: isDark
          ? const Color(0xFF202124)
          : const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      title: Row(
        children: [
          IconBadge(
            icon: icon,
            color: iconColor ?? colorScheme.primary,
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
                      color: subtitleColor ?? colorScheme.outline,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      content: content,
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? const Color(0xFFE8EAED)
                      : const Color(0xFF3C4043),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF5F6368)
                        : const Color(0xFFDADCE0),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: isSubmitting ? null : onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: actionColor ?? colorScheme.primary,
                  foregroundColor: actionForegroundColor ?? colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        actionLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
