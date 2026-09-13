import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../animations/a_fade_slide_transition.dart';
import '../../utils/m_formatters.dart';
import '../../utils/m_validators.dart';

/// From and To amount inputs with budget warnings for exchange dialog.
class ExchangeAmountInputs extends StatelessWidget {
  final TextEditingController fromAmountController;
  final TextEditingController toAmountController;
  final String fromCurrency;
  final String toCurrency;
  final double effectiveAvailable;
  final bool isSubmitting;
  final bool isDark;
  final VoidCallback? onSubmit;

  const ExchangeAmountInputs({
    super.key,
    required this.fromAmountController,
    required this.toAmountController,
    required this.fromCurrency,
    required this.toCurrency,
    required this.effectiveAvailable,
    required this.isSubmitting,
    required this.isDark,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ListenableBuilder(
          listenable: fromAmountController,
          builder: (context, _) {
            final currentFromAmt =
                double.tryParse(fromAmountController.text.trim()) ?? 0.0;
            final isOverBudget = currentFromAmt > effectiveAvailable;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fromAmountController,
                  textAlign: TextAlign.right,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  enabled: !isSubmitting,
                  decoration: InputDecoration(
                    labelText: 'Amount Given ($fromCurrency)',
                    hintText: '0.00',
                    helperText: isOverBudget
                        ? 'Exceeds owned money (${Formatters.formatCurrency(effectiveAvailable, fromCurrency)})'
                        : 'Owned: ${Formatters.formatCurrency(effectiveAvailable, fromCurrency)}',
                    helperStyle: TextStyle(
                      fontSize: 11,
                      color: isOverBudget ? colorScheme.error : colorScheme.outline,
                      fontWeight: isOverBudget ? FontWeight.w600 : FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) {
                    final posErr = Validators.validatePositiveAmount(val, fromCurrency);
                    if (posErr != null) return posErr;
                    final parsed = double.tryParse(val!.trim()) ?? 0.0;
                    if (parsed > effectiveAvailable) {
                      return 'Amount exceeds available $fromCurrency (${Formatters.formatCurrency(effectiveAvailable, fromCurrency)})';
                    }
                    return null;
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => FadeSlideTransition(
                      animation: animation,
                      beginOffset: const Offset(0, -0.15),
                      endOffset: Offset.zero,
                      child: child,
                    ),
                    child: isOverBudget
                        ? Padding(
                            key: const ValueKey('exchange_overdraft_hint'),
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: colorScheme.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colorScheme.error.withValues(alpha: 0.35)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline_rounded, size: 15, color: colorScheme.error),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Amount exceeds available $fromCurrency (${Formatters.formatCurrency(effectiveAvailable, fromCurrency)})',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: colorScheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('empty_exchange_hint')),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: toAmountController,
          textAlign: TextAlign.right,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: onSubmit != null ? (_) => onSubmit!() : null,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          enabled: !isSubmitting,
          decoration: InputDecoration(
            labelText: 'Amount Received ($toCurrency)',
            hintText: '0.00',
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: (val) => Validators.validatePositiveAmount(val, toCurrency),
        ),
      ],
    );
  }
}
