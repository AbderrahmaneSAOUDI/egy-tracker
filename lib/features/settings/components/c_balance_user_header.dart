import 'package:flutter/material.dart';
import '../../../core/components/c_badge.dart';
import '../../../core/components/c_user_avatar.dart';
import '../../../core/theme/t_app_theme.dart';
import 'c_balance_edit_button.dart';

/// Header row for BalanceUserCard showing avatar, name, badge, and edit action.
class BalanceUserHeader extends StatelessWidget {
  final bool isCurrentUser;
  final String name;
  final String email;
  final String? photoUrl;
  final VoidCallback? onEdit;

  const BalanceUserHeader({
    super.key,
    required this.isCurrentUser,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isCurrentUser
        ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
        : (isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED));

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          ),
          child: UserAvatar(
            photoUrl: photoUrl,
            name: name,
            email: email,
            radius: 17,
            backgroundColor: isCurrentUser
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
            foregroundColor: isCurrentUser
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  StatusBadge(
                    label: isCurrentUser ? 'You' : 'Friend',
                    color: color,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: TextStyle(fontSize: 11, color: colorScheme.outline),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isCurrentUser && onEdit != null)
          BalanceEditButton(onEdit: onEdit!),
      ],
    );
  }
}
