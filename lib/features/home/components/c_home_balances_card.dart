import 'package:flutter/material.dart';
import '../../../core/components/c_section_card.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_formatters.dart';

/// Card showing current independent USD and EGP balances grouped by user first.
/// Invariant: Zero combined totals and strict currency separation.
class HomeBalancesCard extends StatelessWidget {
  final String myName;
  final String? myPhotoUrl;
  final String myEmail;
  final double myUsd;
  final double myEgp;

  final String? friendName;
  final String? friendPhotoUrl;
  final String? friendEmail;
  final double friendUsd;
  final double friendEgp;

  const HomeBalancesCard({
    super.key,
    required this.myName,
    this.myPhotoUrl,
    required this.myEmail,
    required this.myUsd,
    required this.myEgp,
    this.friendName,
    this.friendPhotoUrl,
    this.friendEmail,
    required this.friendUsd,
    required this.friendEgp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final usdColor = isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight;
    final egpColor = isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight;

    return SectionCard(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Current Balances',
      child: Column(
        children: [
          // 1. Current User ("You") Block
          _buildUserBlock(
            context: context,
            name: myName,
            photoUrl: myPhotoUrl,
            email: myEmail,
            isCurrentUser: true,
            usdAmount: Formatters.formatUsd(myUsd),
            egpAmount: Formatters.formatEgp(myEgp),
            usdColor: usdColor,
            egpColor: egpColor,
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // 2. Friend Block
          if (friendEmail != null)
            _buildUserBlock(
              context: context,
              name: friendName ?? 'Friend',
              photoUrl: friendPhotoUrl,
              email: friendEmail!,
              isCurrentUser: false,
              usdAmount: Formatters.formatUsd(friendUsd),
              egpAmount: Formatters.formatEgp(friendEgp),
              usdColor: usdColor,
              egpColor: egpColor,
              isDark: isDark,
            )
          else
            _buildEmptyFriendBlock(context, isDark),
        ],
      ),
    );
  }

  Widget _buildUserBlock({
    required BuildContext context,
    required String name,
    required String? photoUrl,
    required String email,
    required bool isCurrentUser,
    required String usdAmount,
    required String egpAmount,
    required Color usdColor,
    required Color egpColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F22) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header: Avatar + Name + You Badge
          Row(
            children: [
              UserAvatar(
                photoUrl: photoUrl,
                name: name,
                email: email,
                radius: 13,
                backgroundColor: isCurrentUser
                    ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                        .withValues(alpha: 0.15)
                    : (isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0)),
                foregroundColor: isCurrentUser
                    ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCurrentUser)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isDark
                            ? AppTheme.googleBlueDark
                            : AppTheme.googleBlue)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'You',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.googleBlueDark
                          : AppTheme.googleBlue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Currencies Inside: USD and EGP
          Row(
            children: [
              // USD Balance Pill
              Expanded(
                child: _buildCurrencyPill(
                  label: 'USD',
                  amount: usdAmount,
                  color: usdColor,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),

              // EGP Balance Pill
              Expanded(
                child: _buildCurrencyPill(
                  label: 'EGP',
                  amount: egpAmount,
                  color: egpColor,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyPill({
    required String label,
    required String amount,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.30 : 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFriendBlock(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1F22) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline_rounded,
              size: 20, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No travel partner added yet',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
