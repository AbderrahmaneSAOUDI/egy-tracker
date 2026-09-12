import 'package:flutter/material.dart';
import '../../../core/components/c_slide_action_card.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/theme/t_app_theme.dart';
import 'c_allowed_email_tile_content.dart';

/// Reusable list tile component displaying an allowed whitelist email.
/// Supports left slide to remove access for non-current users.
class AllowedEmailTile extends StatelessWidget {
  final AllowedEmail allowedEmail;
  final bool isCurrentUser;
  final String? photoUrl;
  final String? displayName;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const AllowedEmailTile({
    super.key,
    required this.allowedEmail,
    required this.isCurrentUser,
    this.photoUrl,
    this.displayName,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = isCurrentUser
        ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
        : (isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue);

    final canDelete = !isCurrentUser && onDelete != null;

    final cardFace = AllowedEmailTileContent(
      allowedEmail: allowedEmail,
      isCurrentUser: isCurrentUser,
      photoUrl: photoUrl,
      displayName: displayName,
      onEdit: onEdit,
      canDelete: canDelete,
      accentColor: accentColor,
    );

    if (!canDelete) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: cardFace,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SlideActionCard(
        endAction: SlideActionItem(
          icon: Icons.delete_outline_rounded,
          label: 'Remove',
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF7F1D1D), Color(0xFFDC2626)]
                : const [Color(0xFFDC2626), Color(0xFFF87171)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          onTrigger: onDelete!,
        ),
        child: cardFace,
      ),
    );
  }
}
