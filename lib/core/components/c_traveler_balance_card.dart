import 'package:flutter/material.dart';
import '../theme/t_app_theme.dart';
import '../utils/m_formatters.dart';
import 'balance/c_balance_card_decoration.dart';
import 'balance/c_balance_currency_section.dart';
import 'balance/c_traveler_identity_bar.dart';

export 'balance/c_balance_card_decoration.dart';
export 'balance/c_balance_currency_section.dart';
export 'balance/c_empty_traveler_card.dart';
export 'balance/c_traveler_identity_bar.dart';

/// Premium balance card showing a user's independent USD and EGP balances side-by-side.
class TravelerBalanceCard extends StatelessWidget {
  final String? userId;
  final String name;
  final String? email;
  final bool isCurrentUser;
  final double usdAmount;
  final double egpAmount;
  final String? roleLabel;
  final String? photoUrl;

  const TravelerBalanceCard({
    super.key,
    this.userId,
    required this.name,
    this.email,
    required this.isCurrentUser,
    required this.usdAmount,
    required this.egpAmount,
    this.roleLabel,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final usdColor = isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight;
    final egpColor = isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight;
    final accentColor = isCurrentUser
        ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
        : (isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED));
    final badge = roleLabel ?? (isCurrentUser ? 'You' : 'Friend');

    return Container(
      decoration: buildBalanceCardDecoration(
        isDark: isDark,
        isCurrentUser: isCurrentUser,
        accentColor: accentColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          buildTravelerIdentityBar(
            context: context,
            name: name,
            email: email,
            photoUrl: photoUrl,
            isCurrentUser: isCurrentUser,
            accentColor: accentColor,
            badge: badge,
            isDark: isDark,
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: isDark ? const Color(0xFF232732) : const Color(0xFFEEF2F6),
          ),
          Row(
            children: [
              Expanded(
                child: buildCurrencySection(
                  currencyCode: 'USD',
                  amount: usdAmount,
                  amountFormatted: Formatters.formatUsd(usdAmount),
                  color: usdColor,
                  isDark: isDark,
                  keyPrefix: isCurrentUser ? 'my_usd' : 'friend_usd',
                ),
              ),
              Container(
                width: 1.2,
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: isDark ? const Color(0xFF262C38) : const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: buildCurrencySection(
                  currencyCode: 'EGP',
                  amount: egpAmount,
                  amountFormatted: Formatters.formatEgp(egpAmount),
                  color: egpColor,
                  isDark: isDark,
                  keyPrefix: isCurrentUser ? 'my_egp' : 'friend_egp',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
