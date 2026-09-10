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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (isCurrentUser
                            ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
                            : (isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED)))
                        .withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: UserAvatar(
                  photoUrl: photoUrl,
                  name: name,
                  email: email,
                  radius: 17,
                  backgroundColor: isCurrentUser
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  foregroundColor: isCurrentUser
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
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
                        const SizedBox(width: 6),
                        StatusBadge(
                          label: isCurrentUser ? 'You' : 'Friend',
                          color: isCurrentUser
                              ? (isDark
                                  ? AppTheme.usdColorDark
                                  : AppTheme.usdColorLight)
                              : (isDark
                                  ? const Color(0xFFA78BFA)
                                  : const Color(0xFF7C3AED)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
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
              // Edit button (only available for current user)
              if (isCurrentUser && onEdit != null)
                TextButton.icon(
                  key: const ValueKey('edit_balance_you'),
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 13),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor:
                        isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
                    backgroundColor: (isDark
                            ? AppTheme.googleBlueDark
                            : AppTheme.googleBlue)
                        .withValues(alpha: isDark ? 0.14 : 0.08),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
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
