import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/c_action_icon_button.dart';
import '../../../core/components/c_user_avatar.dart';
import 'c_profile_info.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_auth_helpers.dart';

/// User profile hero card displaying avatar, display name, email, and sign out button.
class ProfileCard extends StatelessWidget {
  final User user;
  final VoidCallback onSignOut;
  final String? photoUrl;
  final String? displayName;

  const ProfileCard({
    super.key,
    required this.user,
    required this.onSignOut,
    this.photoUrl,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final resolvedPhoto = resolveUserPhoto(user, photoUrl);
    final resolvedName = resolveUserName(user, displayName);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  Color(0xFF1B202A),
                  Color(0xFF13161C),
                ]
              : const [
                  Colors.white,
                  Color(0xFFF8FAFC),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2B3242) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue)
                    .withValues(alpha: 0.55),
                width: 2,
              ),
            ),
            child: UserAvatar(
              photoUrl: resolvedPhoto,
              name: resolvedName,
              email: user.email,
              radius: 22,
              backgroundColor: isDark
                  ? const Color(0xFF262B36)
                  : const Color(0xFFF1F5F9),
              foregroundColor:
                  isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ProfileInfoColumn(
              name: resolvedName,
              email: user.email,
              isDark: isDark,
              colorScheme: colorScheme,
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
