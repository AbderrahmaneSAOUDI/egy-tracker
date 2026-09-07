import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_formatters.dart';
import '../../../core/utils/m_validators.dart';

/// Shows modal dialog for creating a new expense with dynamic split visibility
/// and balance sufficiency hints.
Future<void> showAddExpenseDialog({
  required BuildContext context,
  required String currentUserId,
  required String currentUserName,
  String? friendUserId,
  String? friendUserName,
  double myUsdBalance = 0.0,
  double myEgpBalance = 0.0,
  double friendUsdBalance = 0.0,
  double friendEgpBalance = 0.0,
  required Future<bool> Function(Expense) onSave,
}) {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String selectedCurrency = 'EGP'; // Default to EGP for Egypt trip
  String paidByMode = 'you'; // 'you', 'both', 'friend'
  String billPayerId = currentUserId;
  String sharedSplitType = 'fifty_fifty'; // 'fifty_fifty' or 'custom'
  double customMePercentage = 50.0;
  double customFriendPercentage = 50.0;
  DateTime selectedDate = DateTime.now();
  bool isSubmitting = false;

  final friendId = friendUserId ?? 'friend';
  final friendName = friendUserName ?? 'Friend';

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final isDark = theme.brightness == Brightness.dark;

          final currencyColor = selectedCurrency == 'USD'
              ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
              : (isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight);

          // Payer ID calculation
          final actualPayerId = paidByMode == 'you'
              ? currentUserId
              : paidByMode == 'friend'
                  ? friendId
                  : billPayerId;

          // Available balance for the actual payer
          final isMePayer = actualPayerId == currentUserId;
          final availableCash = isMePayer
              ? (selectedCurrency == 'USD' ? myUsdBalance : myEgpBalance)
              : (selectedCurrency == 'USD' ? friendUsdBalance : friendEgpBalance);

          final enteredAmount = double.tryParse(amountController.text.trim()) ?? 0.0;
          final isOverBudget = enteredAmount > 0 && availableCash < enteredAmount;

          return AppDialog(
            icon: Icons.receipt_long_rounded,
            iconColor: isDark ? AppTheme.googleRedDark : AppTheme.googleRed,
            title: 'Add Expense',
            actionLabel: 'Save',
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: () async {
              if (!formKey.currentState!.validate()) return;

              final amount = double.tryParse(amountController.text.trim()) ?? 0.0;

              double mePct;
              double friendPct;
              String finalSplitType;

              if (paidByMode == 'you') {
                mePct = 100.0;
                friendPct = 0.0;
                finalSplitType = 'default_100';
              } else if (paidByMode == 'friend') {
                mePct = 0.0;
                friendPct = 100.0;
                finalSplitType = 'default_100';
              } else {
                // Both
                if (sharedSplitType == 'fifty_fifty') {
                  mePct = 50.0;
                  friendPct = 50.0;
                  finalSplitType = 'fifty_fifty';
                } else {
                  mePct = customMePercentage;
                  friendPct = customFriendPercentage;
                  finalSplitType = 'custom';
                  if ((mePct + friendPct - 100.0).abs() > 0.01) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Split percentages must sum to exactly 100%'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                }
              }

              setDialogState(() => isSubmitting = true);

              final expense = Expense(
                id: '',
                title: titleController.text.trim(),
                amount: amount,
                currency: selectedCurrency,
                paidBy: actualPayerId,
                splitType: finalSplitType,
                mePercentage: mePct,
                friendPercentage: friendPct,
                date: selectedDate,
                createdAt: DateTime.now(),
              );

              final success = await onSave(expense);
              if (dialogContext.mounted && success) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added expense: ${expense.title}'),
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
                    // 1. Title Field
                    TextFormField(
                      controller: titleController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g. Taxi, Dinner, Museum',
                        prefixIcon: Icon(Icons.edit_outlined),
                      ),
                      validator: (val) =>
                          Validators.validateRequired(val, 'Title'),
                    ),
                    const SizedBox(height: 12),

                    // 2. Amount & Currency
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount input
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (_) => setDialogState(() {}),
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
                                Validators.validatePositiveAmount(
                                    val, selectedCurrency),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Currency Toggle
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: currencyColor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                _buildCurrencyOption(
                                  label: 'EGP',
                                  isSelected: selectedCurrency == 'EGP',
                                  color: isDark
                                      ? AppTheme.egpColorDark
                                      : AppTheme.egpColorLight,
                                  onTap: () => setDialogState(
                                      () => selectedCurrency = 'EGP'),
                                ),
                                _buildCurrencyOption(
                                  label: 'USD',
                                  isSelected: selectedCurrency == 'USD',
                                  color: isDark
                                      ? AppTheme.usdColorDark
                                      : AppTheme.usdColorLight,
                                  onTap: () => setDialogState(
                                      () => selectedCurrency = 'USD'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Insufficient Cash Warning Hint
                    if (isOverBudget) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? AppTheme.googleYellowDark
                                  : AppTheme.googleYellow)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (isDark
                                    ? AppTheme.googleYellowDark
                                    : AppTheme.googleYellow)
                                .withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 15,
                                color: isDark
                                    ? AppTheme.googleYellowDark
                                    : AppTheme.googleYellow),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Amount exceeds available cash (${Formatters.formatCurrency(availableCash, selectedCurrency)}). You may need to exchange or borrow currency.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppTheme.googleYellowDark
                                      : AppTheme.googleYellow,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),

                    // 3. Paid By Selector (You / Both / Friend)
                    Text(
                      'Paid By',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _buildChoiceChip(
                            label: 'You',
                            isSelected: paidByMode == 'you',
                            onTap: () => setDialogState(() {
                              paidByMode = 'you';
                            }),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildChoiceChip(
                            label: 'Both',
                            isSelected: paidByMode == 'both',
                            onTap: () => setDialogState(() {
                              paidByMode = 'both';
                            }),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildChoiceChip(
                            label: friendName,
                            isSelected: paidByMode == 'friend',
                            onTap: () => setDialogState(() {
                              paidByMode = 'friend';
                            }),
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    // 4. Split section (ONLY visible when 'Both' is selected)
                    if (paidByMode == 'both') ...[
                      const SizedBox(height: 14),
                      Text(
                        'Who paid the bill?',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _buildChoiceChip(
                              label: 'You',
                              isSelected: billPayerId == currentUserId,
                              onTap: () => setDialogState(
                                  () => billPayerId = currentUserId),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildChoiceChip(
                              label: friendName,
                              isSelected: billPayerId == friendId,
                              onTap: () =>
                                  setDialogState(() => billPayerId = friendId),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Split',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _buildChoiceChip(
                              label: '50 / 50',
                              isSelected: sharedSplitType == 'fifty_fifty',
                              onTap: () => setDialogState(
                                  () => sharedSplitType = 'fifty_fifty'),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildChoiceChip(
                              label: 'Custom',
                              isSelected: sharedSplitType == 'custom',
                              onTap: () => setDialogState(
                                  () => sharedSplitType = 'custom'),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      if (sharedSplitType == 'custom') ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.black.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('You: ${customMePercentage.toInt()}%',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      '$friendName: ${customFriendPercentage.toInt()}%',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Slider(
                                value: customMePercentage,
                                min: 0,
                                max: 100,
                                divisions: 20,
                                onChanged: (val) {
                                  setDialogState(() {
                                    customMePercentage = val;
                                    customFriendPercentage = 100 - val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 14),

                    // 5. Date Selector
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
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

Widget _buildCurrencyOption({
  required String label,
  required bool isSelected,
  required Color color,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? color : null,
          ),
        ),
      ),
    ),
  );
}

Widget _buildChoiceChip({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
  required bool isDark,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
