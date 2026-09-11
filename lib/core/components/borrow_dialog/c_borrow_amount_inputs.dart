import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/t_app_theme.dart';
import '../../utils/m_formatters.dart';

/// USD and EGP input fields with balance limit warnings for borrow dialog.
class BorrowAmountInputs extends StatelessWidget {
  final TextEditingController usdController;
  final TextEditingController egpController;
  final bool isSubmitting;
  final bool isOverUsd;
  final bool isOverEgp;
  final bool isBorrowMode;
  final double sourceUsdBalance;
  final double sourceEgpBalance;
  final double effectiveLimitUsd;
  final double effectiveLimitEgp;
  final bool isDark;
  final VoidCallback onChanged;

  const BorrowAmountInputs({
    super.key,
    required this.usdController,
    required this.egpController,
    required this.isSubmitting,
    required this.isOverUsd,
    required this.isOverEgp,
    required this.isBorrowMode,
    required this.sourceUsdBalance,
    required this.sourceEgpBalance,
    required this.effectiveLimitUsd,
    required this.effectiveLimitEgp,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        TextFormField(
          controller: usdController,
          textAlign: TextAlign.right,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          enabled: !isSubmitting,
          onChanged: (_) => onChanged(),
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
              fontWeight: isOverUsd ? FontWeight.w600 : FontWeight.normal,
            ),
            prefixIcon: const Icon(Icons.attach_money_rounded),
            prefixIconColor: isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: egpController,
          textAlign: TextAlign.right,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          enabled: !isSubmitting,
          onChanged: (_) => onChanged(),
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
              fontWeight: isOverEgp ? FontWeight.w600 : FontWeight.normal,
            ),
            prefixIcon: const Icon(Icons.payments_outlined),
            prefixIconColor: isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight,
            suffixText: 'EGP',
          ),
        ),
      ],
    );
  }
}
