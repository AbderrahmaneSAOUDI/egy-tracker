import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_formatters.dart';
import '../../../core/utils/m_validators.dart';

/// Shows modal dialog for recording a currency exchange transfer between USD and EGP.
Future<void> showAddExchangeDialog({
  required BuildContext context,
  required String currentUserId,
  required String currentUserName,
  double myUsdBalance = 0.0,
  double myEgpBalance = 0.0,
  required Future<bool> Function(Exchange) onSave,
}) {
  final formKey = GlobalKey<FormState>();
  final fromAmountController = TextEditingController();
  final toAmountController = TextEditingController();

  String fromCurrency = 'USD'; // Default USD -> EGP exchange
  String toCurrency = 'EGP';
  DateTime selectedDate = DateTime.now();
  bool isSubmitting = false;

  return showAnimatedDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final isDark = theme.brightness == Brightness.dark;

          final availableOwned =
              fromCurrency == 'USD' ? myUsdBalance : myEgpBalance;

          return AppDialog(
            icon: Icons.sync_alt_rounded,
            iconColor: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
            title: 'Add Exchange',
            actionLabel: 'Save',
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: () async {
              if (!formKey.currentState!.validate()) return;

              final fromAmt =
                  double.tryParse(fromAmountController.text.trim()) ?? 0.0;
              final toAmt =
                  double.tryParse(toAmountController.text.trim()) ?? 0.0;
              final rate = fromAmt > 0
                  ? (fromCurrency == 'USD'
                      ? (toAmt / fromAmt)
                      : (fromAmt / toAmt))
                  : 1.0;

              setDialogState(() => isSubmitting = true);

              final exchange = Exchange(
                id: '',
                userId: currentUserId,
                fromCurrency: fromCurrency,
                fromAmount: fromAmt,
                toCurrency: toCurrency,
                toAmount: toAmt,
                exchangeRate: rate,
                date: selectedDate,
                createdAt: DateTime.now(),
              );

              final success = await onSave(exchange);
              if (dialogContext.mounted && success) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Recorded exchange: ${Formatters.formatCurrency(fromAmt, fromCurrency)} → ${Formatters.formatCurrency(toAmt, toCurrency)}',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (dialogContext.mounted) {
                setDialogState(() => isSubmitting = false);
              }
            },
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Currency Direction Selector
                    Row(
                      children: [
                        Expanded(
                          child: _buildDirectionChip(
                            label: 'USD → EGP',
                            isSelected: fromCurrency == 'USD',
                            onTap: () {
                              setDialogState(() {
                                fromCurrency = 'USD';
                                toCurrency = 'EGP';
                              });
                            },
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDirectionChip(
                            label: 'EGP → USD',
                            isSelected: fromCurrency == 'EGP',
                            onTap: () {
                              setDialogState(() {
                                fromCurrency = 'EGP';
                                toCurrency = 'USD';
                              });
                            },
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Amount Given (with owned money validation)
                    TextFormField(
                      controller: fromAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        labelText: 'Amount Given ($fromCurrency)',
                        hintText: '0.00',
                        helperText:
                            'Owned: ${Formatters.formatCurrency(availableOwned, fromCurrency)}',
                        helperStyle: TextStyle(
                          fontSize: 11,
                          color: colorScheme.outline,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.03),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (val) {
                        final err = Validators.validatePositiveAmount(
                            val, fromCurrency);
                        if (err != null) return err;
                        final amt = double.tryParse(val!.trim()) ?? 0.0;
                        if (amt > availableOwned) {
                          return 'Exceeds owned money (${Formatters.formatCurrency(availableOwned, fromCurrency)})';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Amount Received
                    TextFormField(
                      controller: toAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        labelText: 'Amount Received ($toCurrency)',
                        hintText: '0.00',
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.03),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      validator: (val) =>
                          Validators.validatePositiveAmount(val, toCurrency),
                    ),
                    const SizedBox(height: 14),

                    // Date selector with Reset to now button
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: dialogContext,
                                initialDate: selectedDate,
                                firstDate: DateTime(2025),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null && dialogContext.mounted) {
                                setDialogState(() {
                                  selectedDate = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    selectedDate.hour,
                                    selectedDate.minute,
                                  );
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded,
                                      size: 16,
                                      color: colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 8),
                                  Text(
                                    Formatters.formatDate(selectedDate),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Change',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.restore_rounded, size: 18),
                          tooltip: 'Reset to now',
                          onPressed: () {
                            setDialogState(() {
                              selectedDate = DateTime.now();
                            });
                          },
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 32, minHeight: 32),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildDirectionChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  required bool isDark,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                .withValues(alpha: 0.18)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
              : (isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0)),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected
              ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
              : null,
        ),
      ),
    ),
  );
}
