import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';
import 'c_expense_dialog_custom_slider.dart';
import 'c_expense_dialog_widgets.dart';

/// Selector for expense split type and custom percentage sliders.
class ExpenseSplitSelector extends StatelessWidget {
  final String splitType;
  final double customMePercentage;
  final double customFriendPercentage;
  final String friendName;
  final bool isDark;
  final ValueChanged<String> onSplitTypeChanged;
  final void Function(double mePct, double friendPct) onCustomPercentageChanged;

  const ExpenseSplitSelector({
    super.key,
    required this.splitType,
    required this.customMePercentage,
    required this.customFriendPercentage,
    required this.friendName,
    required this.isDark,
    required this.onSplitTypeChanged,
    required this.onCustomPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blueColor = isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Split',
          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: buildChoiceChip(
                label: '100% Payer',
                isSelected: splitType == 'default_100',
                onTap: () => onSplitTypeChanged('default_100'),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: buildChoiceChip(
                label: '50 / 50',
                isSelected: splitType == 'fifty_fifty',
                onTap: () => onSplitTypeChanged('fifty_fifty'),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: buildChoiceChip(
                label: 'Custom',
                isSelected: splitType == 'custom',
                onTap: () => onSplitTypeChanged('custom'),
                isDark: isDark,
              ),
            ),
          ],
        ),
        if (splitType == 'custom')
          ExpenseCustomSplitSlider(
            customMePercentage: customMePercentage,
            customFriendPercentage: customFriendPercentage,
            friendName: friendName,
            blueColor: blueColor,
            outlineColor: theme.colorScheme.outline,
            onCustomPercentageChanged: onCustomPercentageChanged,
          ),
      ],
    );
  }
}
