import 'package:flutter/material.dart';
import '../../models/mod_exchange.dart';
import '../../theme/t_app_theme.dart';
import '../../utils/m_formatters.dart';

Widget buildExchangeTile({
  required BuildContext context,
  required Exchange exchange,
  required bool isDark,
  required String currentUserId,
  required String? friendName,
}) {
  final exchangeColor = isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue;
  final isByMe = exchange.userId == currentUserId;
  final userLabel = isByMe ? 'By You' : 'By ${friendName ?? "Friend"}';

  final fromFormatted = Formatters.formatCurrency(exchange.fromAmount, exchange.fromCurrency);
  final toFormatted = Formatters.formatCurrency(exchange.toAmount, exchange.toCurrency);

  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1B1D22) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: exchangeColor.withValues(alpha: isDark ? 0.35 : 0.22),
        width: 1.1,
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: exchangeColor.withValues(alpha: isDark ? 0.16 : 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: exchangeColor.withValues(alpha: isDark ? 0.30 : 0.20),
              width: 1,
            ),
          ),
          child: Icon(Icons.sync_alt_rounded, color: exchangeColor, size: 22),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$fromFormatted → $toFormatted',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                '$userLabel · Rate: ${exchange.exchangeRate.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                Formatters.formatDate(exchange.date),
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: exchangeColor.withValues(alpha: isDark ? 0.20 : 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Exchange',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: exchangeColor),
          ),
        ),
      ],
    ),
  );
}
