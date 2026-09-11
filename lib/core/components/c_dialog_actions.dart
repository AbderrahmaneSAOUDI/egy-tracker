import 'package:flutter/material.dart';

/// Standardized action buttons (Cancel + Action) for AppDialog.
class AppDialogActions extends StatelessWidget {
  final String cancelLabel;
  final String actionLabel;
  final Color? actionColor;
  final Color? actionForegroundColor;
  final bool isSubmitting;
  final bool isDark;
  final VoidCallback onCancel;
  final VoidCallback? onAction;
  final Widget? customAction;

  const AppDialogActions({
    super.key,
    required this.cancelLabel,
    required this.actionLabel,
    this.actionColor,
    this.actionForegroundColor,
    required this.isSubmitting,
    required this.isDark,
    required this.onCancel,
    required this.onAction,
    this.customAction,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isSubmitting ? null : onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFFE8EAED) : const Color(0xFF3C4043),
              side: BorderSide(
                color: isDark ? const Color(0xFF5F6368) : const Color(0xFFDADCE0),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: Text(
              cancelLabel,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: customAction ??
              FilledButton(
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
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
              ),
        ),
      ],
    );
  }
}
