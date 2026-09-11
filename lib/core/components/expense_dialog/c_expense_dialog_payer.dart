import 'package:flutter/material.dart';
import 'c_expense_dialog_widgets.dart';

/// Selector for expense payer (You vs. Friend).
class ExpensePayerSelector extends StatelessWidget {
  final String paidBy;
  final String friendName;
  final bool isDark;
  final ValueChanged<String> onPayerChanged;

  const ExpensePayerSelector({
    super.key,
    required this.paidBy,
    required this.friendName,
    required this.isDark,
    required this.onPayerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paid By',
          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: buildChoiceChip(
                label: 'You',
                isSelected: paidBy == 'you',
                onTap: () => onPayerChanged('you'),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildChoiceChip(
                label: friendName,
                isSelected: paidBy == 'friend',
                onTap: () => onPayerChanged('friend'),
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
