import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';
import 'c_expense_dialog_models.dart';

/// Reactive save button that validates form inputs for expense dialog.
class ExpenseSaveButton extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final ExpenseDialogSplitState splitState;
  final bool isSubmitting;
  final bool isDark;
  final VoidCallback onSave;

  const ExpenseSaveButton({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.splitState,
    required this.isSubmitting,
    required this.isDark,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([titleController, amountController]),
      builder: (context, _) {
        final hasTitle = titleController.text.trim().isNotEmpty;
        final enteredAmt = double.tryParse(amountController.text.trim()) ?? 0.0;
        final isCustomValid = splitState.splitType != 'custom' ||
            ((splitState.customMePercentage + splitState.customFriendPercentage - 100.0).abs() <= 0.01);
        final canSubmit = hasTitle && enteredAmt > 0 && isCustomValid && !isSubmitting;

        return FilledButton(
          onPressed: canSubmit ? onSave : null,
          style: FilledButton.styleFrom(
            backgroundColor: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          child: isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Save', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        );
      },
    );
  }
}
