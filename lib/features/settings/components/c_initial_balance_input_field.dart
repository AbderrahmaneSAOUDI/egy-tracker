import 'package:flutter/material.dart';

/// Styled input field for entering a single currency balance in initial balances.
class InitialBalanceInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String symbol;
  final Color colorLight;
  final Color colorDark;
  final bool isSubmitting;
  final bool isDark;

  const InitialBalanceInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.symbol,
    required this.colorLight,
    required this.colorDark,
    required this.isSubmitting,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: !isSubmitting,
      decoration: InputDecoration(
        labelText: label,
        hintText: '0.00',
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorLight.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              symbol,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: symbol.length > 1 ? 11 : 14,
                color: isDark ? colorDark : colorLight,
              ),
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      validator: (val) {
        final trimmed = val?.trim() ?? '';
        if (trimmed.isNotEmpty && double.tryParse(trimmed) == null) {
          return 'Enter a valid amount';
        }
        if (trimmed.isNotEmpty && (double.tryParse(trimmed) ?? 0) < 0) {
          return 'Amount must be positive';
        }
        return null;
      },
    );
  }
}
