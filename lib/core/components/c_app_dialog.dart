import 'package:flutter/material.dart';
import 'c_dialog_actions.dart';
import 'c_dialog_header.dart';

export '../animations/a_dialog_transition.dart';
export 'c_dialog_actions.dart';
export 'c_dialog_header.dart';

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
  final String cancelLabel;
  final Color? actionColor;
  final Color? actionForegroundColor;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback? onAction;
  final Widget? customAction;

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
    this.cancelLabel = 'Cancel',
    this.actionColor,
    this.actionForegroundColor,
    this.isSubmitting = false,
    required this.onCancel,
    required this.onAction,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: borderColor ??
              (isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0)),
          width: 1.2,
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF202124) : const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      title: AppDialogHeader(
        icon: icon,
        iconColor: iconColor ?? colorScheme.primary,
        title: title,
        subtitle: subtitle,
        subtitleColor: subtitleColor,
      ),
      content: content,
      actions: [
        AppDialogActions(
          cancelLabel: cancelLabel,
          actionLabel: actionLabel,
          actionColor: actionColor,
          actionForegroundColor: actionForegroundColor,
          isSubmitting: isSubmitting,
          isDark: isDark,
          onCancel: onCancel,
          onAction: onAction,
          customAction: customAction,
        ),
      ],
    );
  }
}
