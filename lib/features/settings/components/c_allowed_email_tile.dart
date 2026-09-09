import 'package:flutter/material.dart';
import '../../../core/components/c_badge.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/theme/t_app_theme.dart';

/// Reusable list tile component displaying an allowed whitelist email.
class AllowedEmailTile extends StatelessWidget {
  final AllowedEmail allowedEmail;
  final bool isCurrentUser;
  final String? photoUrl;
  final String? displayName;
  final VoidCallback onDelete;

  const AllowedEmailTile({
    super.key,
    required this.allowedEmail,
    required this.isCurrentUser,
    this.photoUrl,
    this.displayName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = isCurrentUser
        ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
        : (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: UserAvatar(
              photoUrl: photoUrl,
              name: displayName ?? allowedEmail.email,
              email: allowedEmail.email,
              radius: 17,
              backgroundColor: isCurrentUser
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              foregroundColor: isCurrentUser
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName?.isNotEmpty == true
                            ? displayName!
                            : allowedEmail.email,
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
                if (displayName?.isNotEmpty == true &&
                    displayName != allowedEmail.email) ...[
                  const SizedBox(height: 2),
                  Text(
                    allowedEmail.email,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.outline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: colorScheme.error.withValues(alpha: 0.8),
            ),
            tooltip: 'Remove',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
