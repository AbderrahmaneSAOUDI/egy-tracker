import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';

/// Direction chip for switching between USD->EGP and EGP->USD in exchange dialog.
Widget buildExchangeDirectionChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  required bool isDark,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
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
      ),
    ),
  );
}
