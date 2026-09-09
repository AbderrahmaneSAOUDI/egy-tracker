import 'package:flutter/material.dart';
import '../../../core/animations/a_animated_amount.dart';
import '../../../core/components/c_icon_badge.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_formatters.dart';

/// Modern Fintech Hero Card showing current independent USD and EGP cash balances.
///
/// Features:
/// - Distinct, elevated surfaces for both travelers.
/// - Dynamic rolling number animations via [AnimatedAmount].
/// - Invariant: Zero combined totals and strict currency separation.
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

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1D22) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2E37) : const Color(0xFFE5E7EB),
          width: 1.2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon badge + Title + Live indicator
          Row(
            children: [
              const IconBadge(
                icon: Icons.account_balance_wallet_rounded,
                size: 34,
                iconSize: 19,
                borderRadius: 12,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Current Balances',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              // Subtle pulse live dot
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen)
                      .withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Current User ("You") Hero Block
          _buildUserCard(
            context: context,
            name: myName,
            photoUrl: myPhotoUrl,
            email: myEmail,
            isCurrentUser: true,
            usdAmount: myUsd,
            egpAmount: myEgp,
            usdColor: usdColor,
            egpColor: egpColor,
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // 2. Travel Partner Block
          if (friendEmail != null)
            _buildUserCard(
              context: context,
              name: friendName ?? 'Friend',
              photoUrl: friendPhotoUrl,
              email: friendEmail!,
              isCurrentUser: false,
              usdAmount: friendUsd,
              egpAmount: friendEgp,
              usdColor: usdColor,
              egpColor: egpColor,
              isDark: isDark,
            )
          else
            _buildEmptyFriendCard(context, isDark),
        ],
      ),
    );
  }

  Widget _buildUserCard({
    required BuildContext context,
    required String name,
    required String? photoUrl,
    required String email,
    required bool isCurrentUser,
    required double usdAmount,
    required double egpAmount,
    required Color usdColor,
    required Color egpColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF22252C) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF323642) : const Color(0xFFEEF0F2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar + Name + Tag
          Row(
            children: [
              UserAvatar(
                photoUrl: photoUrl,
                name: name,
                email: email,
                radius: 14,
                backgroundColor: isCurrentUser
                    ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                        .withValues(alpha: 0.15)
                    : (isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0)),
                foregroundColor: isCurrentUser
                    ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                          .withValues(alpha: 0.15)
                      : (isDark ? const Color(0xFF2F333E) : const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCurrentUser ? 'You' : 'Partner',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isCurrentUser
                        ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Currencies Side-by-Side with Animated Digits
          Row(
            children: [
              // USD Balance Pill
              Expanded(
                child: _buildCurrencyPill(
                  label: 'USD',
                  amount: usdAmount,
                  color: usdColor,
                  isDark: isDark,
                  isUsd: true,
                ),
              ),
              const SizedBox(width: 10),

              // EGP Balance Pill
              Expanded(
                child: _buildCurrencyPill(
                  label: 'EGP',
                  amount: egpAmount,
                  color: egpColor,
                  isDark: isDark,
                  isUsd: false,
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
    required double amount,
    required Color color,
    required bool isDark,
    required bool isUsd,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.28 : 0.18),
          width: 1,
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
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              isUsd
                  ? Formatters.formatUsd(amount)
                  : Formatters.formatEgp(amount),
              key: ValueKey('${label}_$amount'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFriendCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF22252C) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF323642) : const Color(0xFFEEF0F2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_add_alt_1_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No travel partner added yet in Settings',
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
