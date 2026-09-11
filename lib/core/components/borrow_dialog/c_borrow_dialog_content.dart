import 'package:flutter/material.dart';
import 'c_borrow_amount_inputs.dart';
import 'c_borrow_date_picker.dart';
import 'c_borrow_dialog_models.dart';
import 'c_borrow_direction_selector.dart';

/// Form body layout for the borrow dialog.
class BorrowDialogContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String borrowMode;
  final String friendName;
  final bool isDark;
  final Color borrowColor;
  final TextEditingController usdController;
  final TextEditingController egpController;
  final bool isSubmitting;
  final BorrowLimits limits;
  final DateTime selectedDate;
  final ValueChanged<String> onModeChanged;
  final VoidCallback onChanged;
  final ValueChanged<DateTime> onDateChanged;

  const BorrowDialogContent({
    super.key,
    required this.formKey,
    required this.borrowMode,
    required this.friendName,
    required this.isDark,
    required this.borrowColor,
    required this.usdController,
    required this.egpController,
    required this.isSubmitting,
    required this.limits,
    required this.selectedDate,
    required this.onModeChanged,
    required this.onChanged,
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
            BorrowDirectionSelector(
              borrowMode: borrowMode,
              friendName: friendName,
              isDark: isDark,
              borrowColor: borrowColor,
              onModeChanged: onModeChanged,
            ),
            const SizedBox(height: 16),
            BorrowAmountInputs(
              usdController: usdController,
              egpController: egpController,
              isSubmitting: isSubmitting,
              isOverUsd: limits.isOverUsd,
              isOverEgp: limits.isOverEgp,
              isBorrowMode: borrowMode == 'borrow',
              sourceUsdBalance: limits.sourceUsdBalance,
              sourceEgpBalance: limits.sourceEgpBalance,
              effectiveLimitUsd: limits.effectiveLimitUsd,
              effectiveLimitEgp: limits.effectiveLimitEgp,
              isDark: isDark,
              onChanged: onChanged,
            ),
            const SizedBox(height: 14),
            BorrowDatePicker(
              selectedDate: selectedDate,
              onDateChanged: onDateChanged,
            ),
          ],
        ),
      ),
    );
  }
}
