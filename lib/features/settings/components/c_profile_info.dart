import 'package:flutter/material.dart';
import '../../../core/components/c_badge.dart';
import '../../../core/theme/t_app_theme.dart';

/// User info column displaying name, email, and Google Account badge.
class ProfileInfoColumn extends StatelessWidget {
  final String name;
  final String? email;
  final bool isDark;
  final ColorScheme colorScheme;

  const ProfileInfoColumn({
    super.key,
    required this.name,
    required this.email,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.isNotEmpty) ...[
          Text(
            name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
        ],
        Text(
          email ?? 'Unknown User',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        StatusBadge(
          label: 'Google Account',
          icon: Icons.verified_user_rounded,
          color: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
        ),
      ],
    );
  }
}
