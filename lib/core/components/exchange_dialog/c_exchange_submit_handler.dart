import 'package:flutter/material.dart';
import '../../models/mod_exchange.dart';
import '../../utils/m_formatters.dart';
import '../../utils/m_validators.dart';

/// Submit logic and validation for currency exchange dialog.
class ExchangeSubmitHandler {
  static Future<void> submit({
    required BuildContext context,
    required BuildContext dialogContext,
    required GlobalKey<FormState> formKey,
    required TextEditingController fromAmountController,
    required TextEditingController toAmountController,
    required String fromCurrency,
    required String toCurrency,
    required DateTime selectedDate,
    required Exchange? initialExchange,
    required String currentUserId,
    required Future<bool> Function(Exchange) onSave,
    required void Function(bool) setSubmitting,
  }) async {
    if (!formKey.currentState!.validate()) return;
    final currErr = Validators.validateExchangeCurrencies(fromCurrency, toCurrency);
    if (currErr != null) return;

    final fromAmt = double.tryParse(fromAmountController.text.trim()) ?? 0.0;
    final toAmt = double.tryParse(toAmountController.text.trim()) ?? 0.0;
    final rate = fromAmt > 0
        ? (fromCurrency == 'USD'
            ? (toAmt / fromAmt)
            : (toAmt > 0 ? fromAmt / toAmt : 1.0))
        : 1.0;

    setSubmitting(true);

    final exchange = Exchange(
      id: initialExchange?.id.isNotEmpty == true ? initialExchange!.id : '',
      userId: currentUserId,
      fromCurrency: fromCurrency,
      fromAmount: fromAmt,
      toCurrency: toCurrency,
      toAmount: toAmt,
      exchangeRate: rate,
      date: selectedDate,
      createdAt: initialExchange?.createdAt ?? DateTime.now(),
    );

    final success = await onSave(exchange);
    if (dialogContext.mounted && success) {
      Navigator.of(dialogContext).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            initialExchange != null
                ? 'Updated exchange: ${Formatters.formatCurrency(fromAmt, fromCurrency)} → ${Formatters.formatCurrency(toAmt, toCurrency)}'
                : 'Recorded exchange: ${Formatters.formatCurrency(fromAmt, fromCurrency)} → ${Formatters.formatCurrency(toAmt, toCurrency)}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (dialogContext.mounted) {
      setSubmitting(false);
    }
  }
}
