import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'c_app_dialog.dart';
import '../models/mod_borrow.dart';
import '../theme/t_app_theme.dart';
import '../utils/m_formatters.dart';

/// Shows modal dialog for borrowing or lending cash between travel partners.
///
/// Both users are together in real life, so no remote confirmation is required.
Future<void> showBorrowDialog({
  required BuildContext context,
  required String currentUserId,
  required String currentUserName,
  String? currentUserEmail,
  String? friendUserId,
  String? friendUserName,
  double myUsdBalance = 0.0,
  double myEgpBalance = 0.0,
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

  // Determine initial mode: 'borrow' (You received cash) or 'lend' (You gave cash)
  String borrowMode = 'borrow';
  if (initialBorrow != null) {
    final bId = initialBorrow.borrowerId.toLowerCase().trim();
    final cId = currentUserId.toLowerCase().trim();
    final cEmail = currentUserEmail?.toLowerCase().trim();
    if (bId == cId || (cEmail != null && bId == cEmail)) {
      borrowMode = 'borrow';
    } else {
      borrowMode = 'lend';
    }
  }

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

          final isBorrowMode = borrowMode == 'borrow';

          final usd = double.tryParse(usdController.text.trim()) ?? 0.0;
          final egp = double.tryParse(egpController.text.trim()) ?? 0.0;

          // Compute effective limits based on whether current user or friend is the lender
          final effectiveLimitUsd = isBorrowMode
              ? (friendUsdBalance +
                  (initialBorrow != null && initialBorrow.lenderId == friendId
                      ? initialBorrow.usdAmount
                      : 0.0))
              : (myUsdBalance +
                  (initialBorrow != null && initialBorrow.lenderId == currentUserId
                      ? initialBorrow.usdAmount
                      : 0.0));

          final effectiveLimitEgp = isBorrowMode
              ? (friendEgpBalance +
                  (initialBorrow != null && initialBorrow.lenderId == friendId
                      ? initialBorrow.egpAmount
                      : 0.0))
              : (myEgpBalance +
                  (initialBorrow != null && initialBorrow.lenderId == currentUserId
                      ? initialBorrow.egpAmount
                      : 0.0));

          final sourceUsdBalance = isBorrowMode ? friendUsdBalance : myUsdBalance;
          final sourceEgpBalance = isBorrowMode ? friendEgpBalance : myEgpBalance;

          final isOverUsd = sourceUsdBalance > 0 && usd > effectiveLimitUsd;
          final isOverEgp = sourceEgpBalance > 0 && egp > effectiveLimitEgp;

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
            onAction: canSubmit
                ? () async {
                    if (usd <= 0 && egp <= 0) return;

                    setDialogState(() => isSubmitting = true);

                    final actualBorrowerId = isBorrowMode ? currentUserId : friendId;
                    final actualLenderId = isBorrowMode ? friendId : currentUserId;

                    final borrow = Borrow(
                      id: initialBorrow?.id ?? '',
                      borrowerId: actualBorrowerId,
                      lenderId: actualLenderId,
                      usdAmount: usd,
                      egpAmount: egp,
                      date: selectedDate,
                      createdAt: initialBorrow?.createdAt ?? DateTime.now(),
                    );

                    final success = await onSave(borrow);
                    if (dialogContext.mounted && success) {
                      Navigator.of(dialogContext).pop();
                      final actionText = isBorrowMode
                          ? 'borrow from $friendName'
                          : 'loan to $friendName';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            initialBorrow != null
                                ? 'Updated $actionText: ${usd > 0 ? Formatters.formatUsd(usd) : ""}${usd > 0 && egp > 0 ? " and " : ""}${egp > 0 ? Formatters.formatEgp(egp) : ""}'
                                : 'Recorded $actionText: ${usd > 0 ? Formatters.formatUsd(usd) : ""}${usd > 0 && egp > 0 ? " and " : ""}${egp > 0 ? Formatters.formatEgp(egp) : ""}',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else if (dialogContext.mounted) {
                      setDialogState(() => isSubmitting = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to save borrow record. Please check your connection and try again.',
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                : null,
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Direction selection chips
                    Row(
                      children: [
                        Expanded(
                          child: _DirectionChip(
                            label: 'I borrowed',
                            subtitle: 'From $friendName',
                            icon: Icons.call_received_rounded,
                            isSelected: isBorrowMode,
                            color: borrowColor,
                            onTap: () => setDialogState(() => borrowMode = 'borrow'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _DirectionChip(
                            label: 'I lent',
                            subtitle: 'To $friendName',
                            icon: Icons.call_made_rounded,
                            isSelected: !isBorrowMode,
                            color: borrowColor,
                            onTap: () => setDialogState(() => borrowMode = 'lend'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Role indicator banner
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
                          Icon(
                            isBorrowMode
                                ? Icons.person_rounded
                                : Icons.arrow_outward_rounded,
                            size: 16,
                            color: borrowColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isBorrowMode
                                  ? 'Borrowing cash from $friendName'
                                  : 'Lending cash to $friendName',
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
                      textAlign: TextAlign.right,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      enabled: !isSubmitting,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'USD Amount',
                        hintText: '0.00',
                        helperText: isOverUsd
                            ? (isBorrowMode
                                ? 'Exceeds friend balance (${Formatters.formatUsd(effectiveLimitUsd)})'
                                : 'Exceeds your balance (${Formatters.formatUsd(effectiveLimitUsd)})')
                            : (sourceUsdBalance > 0
                                ? (isBorrowMode
                                    ? 'Friend has: ${Formatters.formatUsd(effectiveLimitUsd)}'
                                    : 'You have: ${Formatters.formatUsd(effectiveLimitUsd)}')
                                : null),
                        helperStyle: TextStyle(
                          fontSize: 11,
                          color: isOverUsd ? colorScheme.error : colorScheme.outline,
                          fontWeight:
                              isOverUsd ? FontWeight.w600 : FontWeight.normal,
                        ),
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                        prefixIconColor: isDark
                            ? AppTheme.usdColorDark
                            : AppTheme.usdColorLight,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // EGP Field
                    TextFormField(
                      controller: egpController,
                      textAlign: TextAlign.right,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      enabled: !isSubmitting,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: 'EGP Amount',
                        hintText: '0.00',
                        helperText: isOverEgp
                            ? (isBorrowMode
                                ? 'Exceeds friend balance (${Formatters.formatEgp(effectiveLimitEgp)})'
                                : 'Exceeds your balance (${Formatters.formatEgp(effectiveLimitEgp)})')
                            : (sourceEgpBalance > 0
                                ? (isBorrowMode
                                    ? 'Friend has: ${Formatters.formatEgp(effectiveLimitEgp)}'
                                    : 'You have: ${Formatters.formatEgp(effectiveLimitEgp)}')
                                : null),
                        helperStyle: TextStyle(
                          fontSize: 11,
                          color: isOverEgp ? colorScheme.error : colorScheme.outline,
                          fontWeight:
                              isOverEgp ? FontWeight.w600 : FontWeight.normal,
                        ),
                        prefixIcon: const Icon(Icons.payments_outlined),
                        prefixIconColor: isDark
                            ? AppTheme.egpColorDark
                            : AppTheme.egpColorLight,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: colorScheme.outlineVariant),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded,
                                      size: 18,
                                      color: colorScheme.onSurfaceVariant),
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

class _DirectionChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _DirectionChip({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.22 : 0.14)
                : (isDark ? const Color(0xFF282A2F) : const Color(0xFFF1F3F4)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.6)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? color
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? Colors.white : Colors.black87)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: theme.colorScheme.outline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
