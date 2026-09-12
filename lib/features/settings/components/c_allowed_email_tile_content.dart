import 'package:flutter/material.dart';
import 'c_allowed_email_tile_info.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/models/mod_allowed_email.dart';

/// Inner card content for an allowed email tile.
class AllowedEmailTileContent extends StatelessWidget {
  final AllowedEmail allowedEmail;
  final bool isCurrentUser;
  final String? photoUrl;
  final String? displayName;
  final VoidCallback? onEdit;
  final Color accentColor;
  final bool canDelete;

  const AllowedEmailTileContent({
    super.key,
    required this.allowedEmail,
    required this.isCurrentUser,
    this.photoUrl,
    this.displayName,
    this.onEdit,
    required this.accentColor,
    this.canDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            child: AllowedEmailTileInfo(
              displayName: displayName,
              email: allowedEmail.email,
              isCurrentUser: isCurrentUser,
              accentColor: accentColor,
            ),
          ),
          if (!isCurrentUser && onEdit != null)
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: colorScheme.outline.withValues(alpha: 0.8),
              ),
              tooltip: 'Edit email',
              onPressed: onEdit,
              visualDensity: VisualDensity.compact,
            ),
          if (canDelete)
            Icon(
              Icons.chevron_left_rounded,
              size: 20,
              color: colorScheme.outline.withValues(alpha: 0.4),
            ),
        ],
      ),
    );
  }
}
