import 'package:flutter/material.dart';
import '../theme/t_app_theme.dart';
import '../utils/m_formatters.dart';
import 'c_user_avatar.dart';

/// Reusable modern fintech card displaying a traveler's physical cash balances (USD and EGP).
///
/// Can be used standalone in "My Tracker" for personal cash balances,
/// or composed for multiple travelers on the "Home" tab.
class TravelerBalanceCard extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final String email;
  final bool isCurrentUser;
  final double usdAmount;
  final double egpAmount;
  final String? roleLabel;

  const TravelerBalanceCard({
    super.key,
    required this.name,
    this.photoUrl,
    required this.email,
    required this.isCurrentUser,
    required this.usdAmount,
    required this.egpAmount,
    this.roleLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final usdColor = isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight;
    final egpColor = isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight;

    final accentColor = isCurrentUser
        ? (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
        : (isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED));

    final badge = roleLabel ?? (isCurrentUser ? 'You' : 'Friend');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  isCurrentUser
                      ? const Color(0xFF1B202A)
                      : const Color(0xFF191C24),
                  const Color(0xFF13161C),
                ]
              : [
                  Colors.white,
                  isCurrentUser
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFFFAF5FF),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? (isCurrentUser
                  ? const Color(0xFF2B3242)
                  : const Color(0xFF262A36))
              : (isCurrentUser
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFEDE9FE)),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          // Traveler Identity Bar
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: isDark ? 0.65 : 0.45),
                    width: 1.5,
                  ),
                ),
                child: UserAvatar(
                  photoUrl: photoUrl,
                  name: name,
                  email: email,
                  radius: 15,
                  backgroundColor: isCurrentUser
                      ? accentColor.withValues(alpha: 0.15)
                      : (isDark
                          ? const Color(0xFF2D323E)
                          : const Color(0xFFEDE9FE)),
                  foregroundColor: isCurrentUser
                      ? accentColor
                      : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Role Badge ("You", "Friend", etc.)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: accentColor.withValues(alpha: isDark ? 0.35 : 0.22),
                    width: 1,
                  ),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),

          // Soft Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: isDark ? const Color(0xFF232732) : const Color(0xFFEEF2F6),
          ),

          // Dual Currency Balances (Side-by-Side with Big Numbers)
          Row(
            children: [
              // USD Balance Column
              Expanded(
                child: _buildCurrencySection(
                  currencyCode: 'USD',
                  amountFormatted: Formatters.formatUsd(usdAmount),
                  color: usdColor,
                  isDark: isDark,
                  keyPrefix: isCurrentUser ? 'my_usd' : 'friend_usd',
                ),
              ),

              // Sleek Vertical Divider
              Container(
                width: 1.2,
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: isDark ? const Color(0xFF262C38) : const Color(0xFFE2E8F0),
              ),

              // EGP Balance Column
              Expanded(
                child: _buildCurrencySection(
                  currencyCode: 'EGP',
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

  Widget _buildCurrencySection({
    required String currencyCode,
    required String amountFormatted,
    required Color color,
    required bool isDark,
    required String keyPrefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Currency code header pill
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.20 : 0.12),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                currencyCode,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Cash',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Big Prominent Balance Number
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
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
              amountFormatted,
              key: ValueKey('${keyPrefix}_$amountFormatted'),
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
                color: color,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

/// Standalone empty card displayed when no partner has been configured.
class EmptyTravelerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyTravelerCard({
    super.key,
    this.title = 'No Travel Partner Yet',
    this.subtitle = 'No travel partner added yet in Settings',
    this.icon = Icons.person_add_alt_1_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161920) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF262932) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F232B) : const Color(0xFFEDF2F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
