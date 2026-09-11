import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';

/// Reactive save button for exchange dialog.
class ExchangeSaveButton extends StatelessWidget {
  final TextEditingController fromAmountController;
  final TextEditingController toAmountController;
  final bool isSubmitting;
  final bool isDark;
  final VoidCallback onSave;

  const ExchangeSaveButton({
    super.key,
    required this.fromAmountController,
    required this.toAmountController,
    required this.isSubmitting,
    required this.isDark,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([fromAmountController, toAmountController]),
      builder: (context, _) {
        final currentFromAmt =
            double.tryParse(fromAmountController.text.trim()) ?? 0.0;
        final currentToAmt =
            double.tryParse(toAmountController.text.trim()) ?? 0.0;
        final canSubmit = currentFromAmt > 0 && currentToAmt > 0 && !isSubmitting;

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
              : const Text(
                  'Save',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
        );
      },
    );
  }
}
