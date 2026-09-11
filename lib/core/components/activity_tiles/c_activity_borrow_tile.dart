import 'package:flutter/material.dart';
import '../../models/mod_borrow.dart';
import '../../theme/t_app_theme.dart';
import '../../utils/m_formatters.dart';

Widget buildBorrowTile({
  required BuildContext context,
  required Borrow borrow,
  required bool isDark,
  required String currentUserId,
  required String? currentUserEmail,
  required String? friendName,
}) {
  final borrowerId = borrow.borrowerId.toLowerCase().trim();
  final isBorrower = borrowerId == currentUserId.toLowerCase().trim() ||
      (currentUserEmail != null && borrowerId == currentUserEmail.toLowerCase().trim());
  final borrowColor = isDark ? AppTheme.googleYellowDark : AppTheme.googleYellow;

  final name = friendName ?? 'Friend';
  final actionTitle = isBorrower ? 'Borrowed from $name' : 'Lent to $name';

  final List<String> amounts = [];
  if (borrow.usdAmount > 0) {
    amounts.add(Formatters.formatUsd(borrow.usdAmount));
  }
  if (borrow.egpAmount > 0) {
    amounts.add(Formatters.formatEgp(borrow.egpAmount));
  }
  final amountsText = amounts.join(' · ');

  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1B1D22) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: borrowColor.withValues(alpha: isDark ? 0.35 : 0.22),
        width: 1.1,
      ),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: borrowColor.withValues(alpha: isDark ? 0.16 : 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borrowColor.withValues(alpha: isDark ? 0.30 : 0.20),
              width: 1,
            ),
          ),
          child: Icon(Icons.handshake_rounded, color: borrowColor, size: 22),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionTitle,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                amountsText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isBorrower
                      ? (isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen)
                      : (isDark ? AppTheme.googleRedDark : AppTheme.googleRed),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                Formatters.formatDate(borrow.date),
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: borrowColor.withValues(alpha: isDark ? 0.20 : 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isBorrower ? 'Borrowed' : 'Lent',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: borrowColor),
          ),
        ),
      ],
    ),
  );
}
