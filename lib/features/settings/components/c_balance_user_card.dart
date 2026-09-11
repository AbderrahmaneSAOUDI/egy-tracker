import 'package:flutter/material.dart';
import '../../../core/components/c_currency_pill.dart';
import 'c_balance_user_header.dart';

/// Card showing starting cash (USD and EGP) for a single user (You or Friend).
class BalanceUserCard extends StatelessWidget {
  final bool isCurrentUser;
  final String name;
  final String email;
  final String? photoUrl;
  final double usdAmount;
  final double egpAmount;
  final VoidCallback? onEdit;

  const BalanceUserCard({
    super.key,
    required this.isCurrentUser,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.usdAmount,
    required this.egpAmount,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final usdFormatted =
        '\$${usdAmount.toStringAsFixed(usdAmount % 1 == 0 ? 0 : 2)}';
    final egpFormatted =
        '${egpAmount.toStringAsFixed(egpAmount % 1 == 0 ? 0 : 2)} EGP';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13161C) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? (isCurrentUser
                  ? const Color(0xFF2E3545)
                  : const Color(0xFF262A34))
              : (isCurrentUser
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFEDF0F5)),
          width: 1.1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          BalanceUserHeader(
            isCurrentUser: isCurrentUser,
            name: name,
            email: email,
            photoUrl: photoUrl,
            onEdit: onEdit,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CurrencyPill(
                  currency: 'USD',
                  formattedAmount: usdFormatted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CurrencyPill(
                  currency: 'EGP',
                  formattedAmount: egpFormatted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
