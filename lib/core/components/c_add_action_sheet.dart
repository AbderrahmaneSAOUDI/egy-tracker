import 'package:flutter/material.dart';
import '../config/feature_flags.dart';
import '../theme/t_app_theme.dart';
import 'c_action_sheet_item.dart';

export 'c_action_sheet_item.dart';

/// Shows a bottom sheet allowing the user to choose between Add Expense and Borrow Currency.
Future<void> showAddActionSheet({
  required BuildContext context,
  required VoidCallback onAddExpense,
  required VoidCallback onBorrowCurrency,
  VoidCallback? onAddExchange,
}) {
  if (!FeatureFlags.enableBorrow) {
    onAddExpense();
    return Future.value();
  }

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
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF5F6368) : const Color(0xFFDADCE0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ActionSheetTile(
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
              ActionSheetTile(
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
