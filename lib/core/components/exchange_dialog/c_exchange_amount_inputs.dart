import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/m_formatters.dart';
import '../../utils/m_validators.dart';

/// From and To amount inputs with budget warnings for exchange dialog.
class ExchangeAmountInputs extends StatelessWidget {
  final TextEditingController fromAmountController;
  final TextEditingController toAmountController;
  final String fromCurrency;
  final String toCurrency;
  final double effectiveAvailable;
  final bool isSubmitting;
  final bool isDark;

  const ExchangeAmountInputs({
    super.key,
    required this.fromAmountController,
    required this.toAmountController,
    required this.fromCurrency,
    required this.toCurrency,
    required this.effectiveAvailable,
    required this.isSubmitting,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ListenableBuilder(
          listenable: fromAmountController,
          builder: (context, _) {
            final currentFromAmt =
                double.tryParse(fromAmountController.text.trim()) ?? 0.0;
            final isOverBudget = currentFromAmt > effectiveAvailable;

            return TextFormField(
              controller: fromAmountController,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              enabled: !isSubmitting,
              decoration: InputDecoration(
                labelText: 'Amount Given ($fromCurrency)',
                hintText: '0.00',
                helperText: isOverBudget
                    ? 'Exceeds owned money (${Formatters.formatCurrency(effectiveAvailable, fromCurrency)})'
                    : 'Owned: ${Formatters.formatCurrency(effectiveAvailable, fromCurrency)}',
                helperStyle: TextStyle(
                  fontSize: 11,
                  color: isOverBudget ? colorScheme.error : colorScheme.outline,
                  fontWeight: isOverBudget ? FontWeight.w600 : FontWeight.normal,
                ),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              validator: (val) => Validators.validatePositiveAmount(val, fromCurrency),
            );
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: toAmountController,
          textAlign: TextAlign.right,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          enabled: !isSubmitting,
          decoration: InputDecoration(
            labelText: 'Amount Received ($toCurrency)',
            hintText: '0.00',
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: (val) => Validators.validatePositiveAmount(val, toCurrency),
        ),
      ],
    );
  }
}
