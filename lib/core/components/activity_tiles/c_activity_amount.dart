import 'package:flutter/material.dart';
import '../../utils/m_formatters.dart';

Widget buildExpenseAmount({
  required BuildContext context,
  required double amount,
  required String currency,
  required Color color,
  required bool isMyTrackerView,
  required double? personalShare,
}) {
  if (isMyTrackerView && personalShare != null) {
    final pct = amount > 0 ? (personalShare / amount * 100) : 0.0;
    final pctStr = (pct % 1 == 0) ? '${pct.toInt()}%' : '${pct.toStringAsFixed(1)}%';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Formatters.formatCurrency(personalShare, currency),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'My share: $pctStr',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
  return Text(
    Formatters.formatCurrency(amount, currency),
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.3,
      color: color,
    ),
  );
}
