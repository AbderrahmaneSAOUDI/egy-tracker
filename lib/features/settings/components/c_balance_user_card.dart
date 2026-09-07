import 'package:flutter/material.dart';
import '../../../core/components/c_badge.dart';
import '../../../core/components/c_currency_pill.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/theme/t_app_theme.dart';

/// Card showing starting cash (USD and EGP) for a single user (You or Friend).
class BalanceUserCard extends StatelessWidget {
  final bool isCurrentUser;
  final String name;
  final String email;
  final String? photoUrl;
  final double usdAmount;
  final double egpAmount;
  final VoidCallback onEdit;

  const BalanceUserCard({
    super.key,
    required this.isCurrentUser,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.usdAmount,
    required this.egpAmount,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final usdFormatted =
        '\$${usdAmount.toStringAsFixed(usdAmount % 1 == 0 ? 0 : 2)}';
    final egpFormatted =
        '${egpAmount.toStringAsFixed(egpAmount % 1 == 0 ? 0 : 2)} EGP';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentUser
              ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
                  .withValues(alpha: 0.4)
              : (isDark
                  ? const Color(0xFF3C4043)
                  : const Color(0xFFE8EAED)),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(
                photoUrl: photoUrl,
                name: name,
                email: email,
                radius: 16,
                backgroundColor: isCurrentUser
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                foregroundColor: isCurrentUser
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 6),
                          StatusBadge(
                            label: 'You',
                            color: isDark
                                ? AppTheme.usdColorDark
                                : AppTheme.usdColorLight,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.outline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Edit button
              TextButton.icon(
                key: ValueKey(
                  'edit_balance_${isCurrentUser ? "you" : "friend"}',
                ),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor:
                      isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
