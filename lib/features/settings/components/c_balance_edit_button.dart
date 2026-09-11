import 'package:flutter/material.dart';
import '../../../core/theme/t_app_theme.dart';

/// Compact edit button for starting balances.
class BalanceEditButton extends StatelessWidget {
  final VoidCallback onEdit;

  const BalanceEditButton({
    super.key,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blue = isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue;

    return TextButton.icon(
      key: const ValueKey('edit_balance_you'),
      onPressed: onEdit,
      icon: const Icon(Icons.edit_outlined, size: 13),
      label: const Text('Edit'),
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        foregroundColor: blue,
        backgroundColor: blue.withValues(alpha: isDark ? 0.14 : 0.08),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
