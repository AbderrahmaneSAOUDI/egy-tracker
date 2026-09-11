import 'package:flutter/material.dart';
import 'c_exchange_amount_inputs.dart';
import 'c_exchange_date_picker.dart';
import 'c_exchange_direction_selector.dart';

/// Form body layout for the exchange dialog.
class ExchangeDialogContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String fromCurrency;
  final String toCurrency;
  final bool isDark;
  final TextEditingController fromAmountController;
  final TextEditingController toAmountController;
  final double effectiveAvailable;
  final bool isSubmitting;
  final DateTime selectedDate;
  final void Function(String from, String to) onDirectionChanged;
  final ValueChanged<DateTime> onDateChanged;

  const ExchangeDialogContent({
    super.key,
    required this.formKey,
    required this.fromCurrency,
    required this.toCurrency,
    required this.isDark,
    required this.fromAmountController,
    required this.toAmountController,
    required this.effectiveAvailable,
    required this.isSubmitting,
    required this.selectedDate,
    required this.onDirectionChanged,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExchangeDirectionSelector(
              fromCurrency: fromCurrency,
              isDark: isDark,
              onDirectionChanged: onDirectionChanged,
            ),
            const SizedBox(height: 14),
            ExchangeAmountInputs(
              fromAmountController: fromAmountController,
              toAmountController: toAmountController,
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              effectiveAvailable: effectiveAvailable,
              isSubmitting: isSubmitting,
              isDark: isDark,
            ),
            const SizedBox(height: 14),
            ExchangeDatePicker(
              selectedDate: selectedDate,
              onDateChanged: onDateChanged,
            ),
          ],
        ),
      ),
    );
  }
}
