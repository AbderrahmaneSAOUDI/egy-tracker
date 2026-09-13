import 'package:flutter/material.dart';
import '../../animations/a_fade_slide_transition.dart';
import '../../theme/t_app_theme.dart';
import 'c_expense_dialog_models.dart';

/// Live animated warning / error hint when an entered expense amount exceeds available cash or split share.
class ExpenseCashWarning extends StatelessWidget {
  final TextEditingController amountController;
  final String paidBy;
  final ExpenseDialogBalances balances;
  final ExpenseDialogSplitState splitState;
  final String selectedCurrency;
  final bool isDark;

  const ExpenseCashWarning({
    super.key,
    required this.amountController,
    required this.paidBy,
    required this.balances,
    required this.splitState,
    required this.selectedCurrency,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: amountController,
      builder: (context, _) {
        final currentAmount =
            double.tryParse(amountController.text.trim()) ?? 0.0;
        final errorText = balances.getOverdraftError(
          amount: currentAmount,
          splitType: splitState.splitType,
          customMePercentage: splitState.customMePercentage,
          customFriendPercentage: splitState.customFriendPercentage,
          paidBy: paidBy,
          currency: selectedCurrency,
        );

        final errorColor = isDark ? AppTheme.googleRedDark : AppTheme.googleRed;

        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeSlideTransition(
              animation: animation,
              beginOffset: const Offset(0, -0.15),
              endOffset: Offset.zero,
              child: child,
            ),
            child: errorText == null
                ? const SizedBox.shrink(key: ValueKey('empty_cash_warning'))
                : Padding(
                    key: ValueKey(errorText),
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: errorColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: errorColor.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 15, color: errorColor),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              errorText,
                              style: TextStyle(
                                fontSize: 11,
                                color: errorColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
