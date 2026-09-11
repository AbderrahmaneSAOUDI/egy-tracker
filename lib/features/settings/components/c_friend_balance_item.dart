import 'package:flutter/material.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';
import 'c_balance_user_card.dart';

/// Renders either the friend balance card or the placeholder prompt.
class FriendBalanceItem extends StatelessWidget {
  final AllowedEmail? friendEmailDoc;
  final String? friendDisplayName;
  final UserProfile? friendProfile;
  final InitialBalance? friendBalance;
  final VoidCallback? onEdit;

  const FriendBalanceItem({
    super.key,
    required this.friendEmailDoc,
    required this.friendDisplayName,
    required this.friendProfile,
    required this.friendBalance,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (friendEmailDoc != null) {
      return BalanceUserCard(
        isCurrentUser: false,
        name: friendDisplayName!,
        email: friendEmailDoc!.email,
        photoUrl: friendProfile?.photoUrl,
        usdAmount: friendBalance?.usdAmount ?? 0.0,
        egpAmount: friendBalance?.egpAmount ?? 0.0,
        onEdit: onEdit,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.02)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_add_alt_1_outlined,
            size: 20,
            color: colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Add your travel partner in Allowed Emails below to configure their starting cash.',
              style: TextStyle(fontSize: 12, color: colorScheme.outline),
            ),
          ),
        ],
      ),
    );
  }
}
