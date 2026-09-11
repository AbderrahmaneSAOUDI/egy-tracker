import 'package:flutter/material.dart';
import '../c_user_avatar.dart';

Widget buildTravelerIdentityBar({
  required BuildContext context,
  required String name,
  required String? email,
  required String? photoUrl,
  required bool isCurrentUser,
  required Color accentColor,
  required String badge,
  required bool isDark,
}) {
  final theme = Theme.of(context);

  return Row(
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
              : (isDark ? const Color(0xFF2D323E) : const Color(0xFFEDE9FE)),
          foregroundColor: isCurrentUser ? accentColor : theme.colorScheme.onSurface,
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
  );
}
