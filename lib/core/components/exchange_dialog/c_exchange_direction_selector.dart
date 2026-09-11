import 'package:flutter/material.dart';
import 'c_exchange_direction_chip.dart';

/// Direction selector row for exchange dialog (USD -> EGP or EGP -> USD).
class ExchangeDirectionSelector extends StatelessWidget {
  final String fromCurrency;
  final bool isDark;
  final void Function(String from, String to) onDirectionChanged;

  const ExchangeDirectionSelector({
    super.key,
    required this.fromCurrency,
    required this.isDark,
    required this.onDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildExchangeDirectionChip(
            label: 'USD → EGP',
            isSelected: fromCurrency == 'USD',
            onTap: () => onDirectionChanged('USD', 'EGP'),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: buildExchangeDirectionChip(
            label: 'EGP → USD',
            isSelected: fromCurrency == 'EGP',
            onTap: () => onDirectionChanged('EGP', 'USD'),
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
