import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'c_app_dialog.dart';
import '../models/mod_borrow.dart';
import '../theme/t_app_theme.dart';
import '../utils/m_formatters.dart';

/// Shows modal dialog for borrowing currency from the travel partner.
///
/// Both users are together in real life, so no remote confirmation is required.
Future<void> showBorrowDialog({
  required BuildContext context,
  required String currentUserId,
  required String currentUserName,
  String? friendUserId,
  String? friendUserName,
  double friendUsdBalance = 0.0,
  double friendEgpBalance = 0.0,
  Borrow? initialBorrow,
  required Future<bool> Function(Borrow) onSave,
}) {
  final formKey = GlobalKey<FormState>();
  final usdController = TextEditingController(
    text: initialBorrow != null && initialBorrow.usdAmount > 0
        ? initialBorrow.usdAmount.toStringAsFixed(2)
        : '',
  );
  final egpController = TextEditingController(
    text: initialBorrow != null && initialBorrow.egpAmount > 0
        ? initialBorrow.egpAmount.toStringAsFixed(2)
        : '',
  );
  DateTime selectedDate = initialBorrow?.date ?? DateTime.now();
  bool isSubmitting = false;

  final friendId = friendUserId ?? 'friend';
  final friendName = friendUserName ?? 'Friend';

  return showAnimatedDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final isDark = theme.brightness == Brightness.dark;

          final borrowColor =
              isDark ? AppTheme.googleYellowDark : AppTheme.googleYellow;

          final usd = double.tryParse(usdController.text.trim()) ?? 0.0;
          final egp = double.tryParse(egpController.text.trim()) ?? 0.0;

          final effectiveFriendUsd = friendUsdBalance +
              (initialBorrow != null ? initialBorrow.usdAmount : 0.0);
          final effectiveFriendEgp = friendEgpBalance +
              (initialBorrow != null ? initialBorrow.egpAmount : 0.0);

          final isOverUsd = friendUsdBalance > 0 && usd > effectiveFriendUsd;
          final isOverEgp = friendEgpBalance > 0 && egp > effectiveFriendEgp;

          final canSubmit = (usd > 0 || egp > 0) &&
              usd >= 0 &&
              egp >= 0 &&
              !isOverUsd &&
              !isOverEgp &&
              !isSubmitting;

          return AppDialog(
            icon: Icons.handshake_outlined,
            iconColor: borrowColor,
            title: initialBorrow != null ? 'Edit Borrow Record' : 'Borrow Currency',
            actionLabel: 'Save',
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: canSubmit ? () async {
              if (usd <= 0 && egp <= 0) {
                return;
              }

              setDialogState(() => isSubmitting = true);

              final borrow = Borrow(
                id: initialBorrow?.id ?? '',
                borrowerId: currentUserId,
                lenderId: friendId,
                usdAmount: usd,
                egpAmount: egp,
                date: selectedDate,
                createdAt: initialBorrow?.createdAt ?? DateTime.now(),
              );

              final success = await onSave(borrow);
              if (dialogContext.mounted && success) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      initialBorrow != null
                          ? 'Updated borrow from $friendName: ${usd > 0 ? Formatters.formatUsd(usd) : ""}${usd > 0 && egp > 0 ? " and " : ""}${egp > 0 ? Formatters.formatEgp(egp) : ""}'
                          : 'Recorded borrow from $friendName: ${usd > 0 ? Formatters.formatUsd(usd) : ""}${usd > 0 && egp > 0 ? " and " : ""}${egp > 0 ? Formatters.formatEgp(egp) : ""}',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (dialogContext.mounted) {
                setDialogState(() => isSubmitting = false);
              }
            } : null,
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Lender indicator banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: borrowColor.withValues(alpha: isDark ? 0.15 : 0.10),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borrowColor.withValues(alpha: isDark ? 0.30 : 0.20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person_rounded, size: 16, color: borrowColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Borrowing cash from $friendName',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // USD Field
                    TextFormField(
                      controller: usdController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      enabled: !isSubmitting,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'USD Amount',
                        hintText: '0.00',
                        helperText: isOverUsd
                            ? 'Exceeds friend balance (${Formatters.formatUsd(effectiveFriendUsd)})'
                            : (friendUsdBalance > 0
                                ? 'Friend has: ${Formatters.formatUsd(effectiveFriendUsd)}'
                                : null),
                        helperStyle: TextStyle(
                          fontSize: 11,
                          color: isOverUsd ? colorScheme.error : colorScheme.outline,
                          fontWeight: isOverUsd ? FontWeight.w600 : FontWeight.normal,
                        ),
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                        prefixIconColor: isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // EGP Field
                    TextFormField(
                      controller: egpController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      enabled: !isSubmitting,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'EGP Amount',
                        hintText: '0.00',
                        helperText: isOverEgp
                            ? 'Exceeds friend balance (${Formatters.formatEgp(effectiveFriendEgp)})'
                            : (friendEgpBalance > 0
                                ? 'Friend has: ${Formatters.formatEgp(effectiveFriendEgp)}'
                                : null),
                        helperStyle: TextStyle(
                          fontSize: 11,
                          color: isOverEgp ? colorScheme.error : colorScheme.outline,
                          fontWeight: isOverEgp ? FontWeight.w600 : FontWeight.normal,
                        ),
                        prefixIcon: const Icon(Icons.payments_outlined),
                        prefixIconColor: isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight,
                        suffixText: 'EGP',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Date Picker Row with Reset to now button
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: dialogContext,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null && dialogContext.mounted) {
                                final time = await showTimePicker(
                                  context: dialogContext,
                                  initialTime:
                                      TimeOfDay.fromDateTime(selectedDate),
                                );
                                if (dialogContext.mounted) {
                                  setDialogState(() {
                                    selectedDate = DateTime(
                                      picked.year,
                                      picked.month,
                                      picked.day,
                                      time?.hour ?? selectedDate.hour,
                                      time?.minute ?? selectedDate.minute,
                                    );
                                  });
                                }
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: colorScheme.outlineVariant),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded,
                                      size: 18, color: colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 10),
                                  Text(
                                    Formatters.formatDate(selectedDate),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.restore_rounded, size: 20),
                          tooltip: 'Reset to now',
                          onPressed: () {
                            setDialogState(() {
                              selectedDate = DateTime.now();
                            });
                          },
                          visualDensity: VisualDensity.compact,
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
