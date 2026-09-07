import 'package:flutter/material.dart';
import '../../../core/components/c_badge.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/theme/t_app_theme.dart';

/// Reusable list tile component displaying an allowed whitelist email.
class AllowedEmailTile extends StatelessWidget {
  final AllowedEmail allowedEmail;
  final bool isCurrentUser;
  final String? currentUserPhotoUrl;
  final String? currentUserName;
  final VoidCallback onDelete;

  const AllowedEmailTile({
    super.key,
    required this.allowedEmail,
    required this.isCurrentUser,
    this.currentUserPhotoUrl,
    this.currentUserName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = isCurrentUser
        ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
        : (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentUser
              ? accentColor.withValues(alpha: 0.4)
              : (isDark ? const Color(0xFF3C4043) : const Color(0xFFE8EAED)),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          UserAvatar(
            photoUrl: isCurrentUser ? currentUserPhotoUrl : null,
            name: isCurrentUser ? currentUserName : null,
            email: allowedEmail.email,
            radius: 17,
            backgroundColor: isCurrentUser
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
            foregroundColor: isCurrentUser
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        allowedEmail.email,
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
                        color: accentColor,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isCurrentUser
                      ? 'Active Account • Admin'
                      : 'Authorized Traveler',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 19,
              color: colorScheme.error.withValues(alpha: 0.75),
            ),
            tooltip: 'Remove',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
