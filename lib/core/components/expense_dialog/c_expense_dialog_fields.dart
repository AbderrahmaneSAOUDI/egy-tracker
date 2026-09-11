import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/t_app_theme.dart';
import '../../utils/m_validators.dart';
import 'c_expense_dialog_widgets.dart';

/// Title, amount, and currency toggle inputs for expense dialog.
class ExpenseDialogFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final bool isSubmitting;
  final String selectedCurrency;
  final Color currencyColor;
  final bool isDark;
  final ValueChanged<String> onCurrencyChanged;

  const ExpenseDialogFields({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.isSubmitting,
    required this.selectedCurrency,
    required this.currencyColor,
    required this.isDark,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          textCapitalization: TextCapitalization.sentences,
          enabled: !isSubmitting,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'e.g. Taxi, Dinner, Museum',
            prefixIcon: Icon(Icons.edit_outlined),
          ),
          validator: (val) => Validators.validateRequired(val, 'Title'),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: amountController,
                textAlign: TextAlign.right,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                enabled: !isSubmitting,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  prefixIcon: Icon(
                    selectedCurrency == 'USD'
                        ? Icons.attach_money_rounded
                        : Icons.payments_outlined,
                    color: currencyColor,
                  ),
                ),
                validator: (val) =>
                    Validators.validatePositiveAmount(val, selectedCurrency),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Container(
                height: 52,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.04),
                  border: Border.all(color: currencyColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    buildCurrencyOption(
                      label: 'EGP',
                      isSelected: selectedCurrency == 'EGP',
                      color: isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight,
                      onTap: () => onCurrencyChanged('EGP'),
                    ),
                    buildCurrencyOption(
                      label: 'USD',
                      isSelected: selectedCurrency == 'USD',
                      color: isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight,
                      onTap: () => onCurrencyChanged('USD'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
