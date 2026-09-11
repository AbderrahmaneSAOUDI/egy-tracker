import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';

/// Reusable currency toggle option for the expense dialog.
Widget buildCurrencyOption({
  required String label,
  required bool isSelected,
  required Color color,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? color : null,
          ),
        ),
      ),
    ),
  );
}

/// Reusable choice chip for payer and split selection.
Widget buildChoiceChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  required bool isDark,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                .withValues(alpha: 0.18)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
              : (isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0)),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected
              ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
              : null,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
