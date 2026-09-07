import 'package:flutter/material.dart';
import '../theme/t_app_theme.dart';

/// Reusable currency display pill adhering strictly to currency independence.
/// USD is bound to Google Green; EGP is bound to Google Yellow.
class CurrencyPill extends StatelessWidget {
  final String currency; // 'USD' or 'EGP'
  final String formattedAmount;

  const CurrencyPill({
    super.key,
    required this.currency,
    required this.formattedAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUsd = currency.toUpperCase().trim() == 'USD';

    final currencyColor = isUsd
        ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
        : (isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: currencyColor.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: currencyColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currency.toUpperCase().trim(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: currencyColor,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            formattedAmount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: currencyColor,
            ),
          ),
        ],
      ),
    );
  }
}
