import 'package:flutter/material.dart';
import '../../../core/theme/t_app_theme.dart';

/// Shows a bottom sheet allowing the user to choose between Add Expense, Add Exchange, and Borrow Currency.
Future<void> showAddActionSheet({
  required BuildContext context,
  required VoidCallback onAddExpense,
  required VoidCallback onAddExchange,
  required VoidCallback onBorrowCurrency,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? const Color(0xFF202124) : const Color(0xFFFFFFFF),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF5F6368) : const Color(0xFFDADCE0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Option 1: Add Expense
              _ActionTile(
                icon: Icons.receipt_long_rounded,
                iconColor: isDark ? AppTheme.googleRedDark : AppTheme.googleRed,
                title: 'Add Expense',
                onTap: () {
                  Navigator.of(context).pop();
                  onAddExpense();
                },
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              // Option 2: Add Exchange
              _ActionTile(
                icon: Icons.sync_alt_rounded,
                iconColor: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
                title: 'Add Exchange',
                onTap: () {
                  Navigator.of(context).pop();
                  onAddExchange();
                },
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              // Option 3: Borrow Currency
              _ActionTile(
                icon: Icons.handshake_outlined,
                iconColor: isDark ? AppTheme.googleYellowDark : AppTheme.googleYellow,
                title: 'Borrow Currency',
                onTap: () {
                  Navigator.of(context).pop();
                  onBorrowCurrency();
                },
                isDark: isDark,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
