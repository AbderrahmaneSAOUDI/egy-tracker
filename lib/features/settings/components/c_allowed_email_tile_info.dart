import 'package:flutter/material.dart';
import '../../../core/components/c_badge.dart';

/// Text info and badge for an allowed email tile.
class AllowedEmailTileInfo extends StatelessWidget {
  final String? displayName;
  final String email;
  final bool isCurrentUser;
  final Color accentColor;

  const AllowedEmailTileInfo({
    super.key,
    required this.displayName,
    required this.email,
    required this.isCurrentUser,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasName = displayName?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                hasName ? displayName! : email,
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
        if (hasName && displayName != email) ...[
          const SizedBox(height: 2),
          Text(
            email,
            style: TextStyle(fontSize: 12, color: colorScheme.outline),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
