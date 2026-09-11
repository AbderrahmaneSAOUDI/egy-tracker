import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';
import '../../utils/m_formatters.dart';

/// Live warning hint when an entered expense amount exceeds available cash.
class ExpenseCashWarning extends StatelessWidget {
  final TextEditingController amountController;
  final String paidBy;
  final double effectiveMyAvailable;
  final double effectiveFriendAvailable;
  final double friendAvailableCash;
  final String friendName;
  final String selectedCurrency;
  final bool isDark;

  const ExpenseCashWarning({
    super.key,
    required this.amountController,
    required this.paidBy,
    required this.effectiveMyAvailable,
    required this.effectiveFriendAvailable,
    required this.friendAvailableCash,
    required this.friendName,
    required this.selectedCurrency,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: amountController,
      builder: (context, _) {
        final currentAmount = double.tryParse(amountController.text.trim()) ?? 0.0;
        final payerAvailable = paidBy == 'you' ? effectiveMyAvailable : effectiveFriendAvailable;
        final exceeds = currentAmount > 0 &&
            (paidBy == 'you' || friendAvailableCash > 0) &&
            currentAmount > payerAvailable;
        if (!exceeds) return const SizedBox.shrink();

        final warningText = paidBy == 'you'
            ? 'Amount exceeds available cash (${Formatters.formatCurrency(effectiveMyAvailable, selectedCurrency)}). You may need to exchange or borrow currency.'
            : 'Amount exceeds $friendName\'s available cash (${Formatters.formatCurrency(effectiveFriendAvailable, selectedCurrency)}).';

        final warnColor = isDark ? AppTheme.googleYellowDark : AppTheme.googleYellow;

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: warnColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: warnColor.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 15, color: warnColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    warningText,
                    style: TextStyle(
                      fontSize: 11,
                      color: warnColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
