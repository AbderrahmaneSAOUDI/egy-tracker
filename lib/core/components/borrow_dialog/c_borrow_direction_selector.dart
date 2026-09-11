import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';
import 'c_borrow_direction_chip.dart';

/// Direction toggle and summary banner for borrow dialog.
class BorrowDirectionSelector extends StatelessWidget {
  final String borrowMode;
  final String friendName;
  final bool isDark;
  final Color borrowColor;
  final ValueChanged<String> onModeChanged;

  const BorrowDirectionSelector({
    super.key,
    required this.borrowMode,
    required this.friendName,
    required this.isDark,
    required this.borrowColor,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBorrowMode = borrowMode == 'borrow';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer Direction',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: BorrowDirectionChip(
                label: 'I borrowed',
                subtitle: 'From $friendName',
                icon: Icons.arrow_downward_rounded,
                isSelected: isBorrowMode,
                color: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
                onTap: () => onModeChanged('borrow'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: BorrowDirectionChip(
                label: 'I lent',
                subtitle: 'To $friendName',
                icon: Icons.arrow_upward_rounded,
                isSelected: !isBorrowMode,
                color: isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen,
                onTap: () => onModeChanged('lend'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: borrowColor.withValues(alpha: isDark ? 0.15 : 0.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borrowColor.withValues(alpha: isDark ? 0.30 : 0.20)),
          ),
          child: Row(
            children: [
              Icon(
                isBorrowMode ? Icons.person_rounded : Icons.arrow_outward_rounded,
                size: 16,
                color: borrowColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isBorrowMode
                      ? 'Borrowing cash from $friendName'
                      : 'Lending cash to $friendName',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
