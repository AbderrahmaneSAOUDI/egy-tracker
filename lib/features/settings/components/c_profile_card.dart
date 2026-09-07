import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/c_action_icon_button.dart';
import '../../../core/components/c_badge.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/theme/t_app_theme.dart';

/// User profile hero card displaying avatar, display name, email, and sign out button.
class ProfileCard extends StatelessWidget {
  final User user;
  final VoidCallback onSignOut;

  const ProfileCard({
    super.key,
    required this.user,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF202124) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                    .withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: UserAvatar(
              photoUrl: user.photoURL,
              name: user.displayName,
              email: user.email,
              radius: 26,
              backgroundColor: isDark
                  ? const Color(0xFF303134)
                  : const Color(0xFFF1F3F4),
              foregroundColor:
                  isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.displayName != null &&
                    user.displayName!.trim().isNotEmpty) ...[
                  Text(
                    user.displayName!.trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  user.email ?? 'Unknown User',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                StatusBadge(
                  label: 'Google Account',
                  icon: Icons.verified_user_rounded,
                  color: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ActionIconButton(
            icon: Icons.logout_rounded,
            color: colorScheme.error,
            tooltip: 'Sign Out',
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
