import 'package:flutter/material.dart';
import '../models/mod_exchange.dart';
import '../theme/t_app_theme.dart';
import 'c_app_dialog.dart';
import 'exchange_dialog/c_exchange_dialog_content.dart';
import 'exchange_dialog/c_exchange_save_action.dart';
import 'exchange_dialog/c_exchange_submit_handler.dart';

export 'exchange_dialog/c_exchange_amount_inputs.dart';
export 'exchange_dialog/c_exchange_date_picker.dart';
export 'exchange_dialog/c_exchange_dialog_content.dart';
export 'exchange_dialog/c_exchange_direction_chip.dart';
export 'exchange_dialog/c_exchange_direction_selector.dart';
export 'exchange_dialog/c_exchange_save_action.dart';
export 'exchange_dialog/c_exchange_submit_handler.dart';

/// Shows modal dialog for recording a currency exchange transfer between USD and EGP.
Future<void> showAddExchangeDialog({
  required BuildContext context,
  required String currentUserId,
  required String currentUserName,
  double myUsdBalance = 0.0,
  double myEgpBalance = 0.0,
  Exchange? initialExchange,
  required Future<bool> Function(Exchange) onSave,
}) async {
  final formKey = GlobalKey<FormState>();
  final fromAmountController = TextEditingController(
    text: initialExchange != null ? initialExchange.fromAmount.toStringAsFixed(2) : '',
  );
  final toAmountController = TextEditingController(
    text: initialExchange != null ? initialExchange.toAmount.toStringAsFixed(2) : '',
  );

  String fromCurrency = initialExchange?.fromCurrency ?? 'USD';
  String toCurrency = initialExchange?.toCurrency ?? 'EGP';
  DateTime selectedDate = initialExchange?.date ?? DateTime.now();
  bool isSubmitting = false;

  await showAnimatedDialog<void>(
    context: context,
    disposables: [fromAmountController, toAmountController],
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final availableOwned = fromCurrency == 'USD' ? myUsdBalance : myEgpBalance;
          final effectiveAvailable = availableOwned +
              (initialExchange != null && initialExchange.fromCurrency == fromCurrency
                  ? initialExchange.fromAmount
                  : 0.0);

          void doSubmit() => ExchangeSubmitHandler.submit(
                context: context,
                dialogContext: dialogContext,
                formKey: formKey,
                fromAmountController: fromAmountController,
                toAmountController: toAmountController,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                selectedDate: selectedDate,
                initialExchange: initialExchange,
                currentUserId: currentUserId,
                onSave: onSave,
                setSubmitting: (val) => setDialogState(() => isSubmitting = val),
              );

          return AppDialog(
            icon: Icons.sync_alt_rounded,
            iconColor: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
            title: initialExchange != null ? 'Edit Exchange' : 'Add Exchange',
            actionLabel: 'Save',
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: isSubmitting ? null : doSubmit,
            customAction: ExchangeSaveButton(
              fromAmountController: fromAmountController,
              toAmountController: toAmountController,
              isSubmitting: isSubmitting,
              isDark: isDark,
              onSave: doSubmit,
            ),
            content: ExchangeDialogContent(
              formKey: formKey,
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              isDark: isDark,
              fromAmountController: fromAmountController,
              toAmountController: toAmountController,
              effectiveAvailable: effectiveAvailable,
              isSubmitting: isSubmitting,
              selectedDate: selectedDate,
              onDirectionChanged: (from, to) => setDialogState(() {
                fromCurrency = from;
                toCurrency = to;
              }),
              onDateChanged: (d) => setDialogState(() => selectedDate = d),
            ),
          );
        },
      );
    },
  );
}
