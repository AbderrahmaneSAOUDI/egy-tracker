import 'package:flutter/material.dart';
import '../../models/mod_expense.dart';
import '../../theme/t_app_theme.dart';
import '../../utils/m_calculations.dart';
import '../../utils/m_formatters.dart';
import 'c_activity_amount.dart';

Widget buildExpenseTile({
  required BuildContext context,
  required Expense expense,
  required bool isDark,
  required String currentUserId,
  required String? currentUserEmail,
  required String? friendName,
  required bool isPrimaryUser,
  required bool isMyTrackerView,
  required double? personalShare,
}) {
  final isUsd = expense.currency.toUpperCase().trim() == 'USD';
  final currencyColor = isUsd
      ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
      : (isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight);

  final payerId = expense.paidBy.toLowerCase().trim();
  final isPaidByMe = payerId == currentUserId.toLowerCase().trim() ||
      (currentUserEmail != null && payerId == currentUserEmail.toLowerCase().trim());
  final cleanFriendName = (friendName != null && friendName.trim().isNotEmpty)
      ? (friendName.contains('@') ? friendName.split('@').first : friendName.trim())
      : 'Friend';
  final payerLabel = isPaidByMe ? 'Paid by You' : 'Paid by $cleanFriendName';

  final myPct = Calculations.getUserPercentage(
    expense: expense,
    isPrimaryUser: isPrimaryUser,
    userId: currentUserId,
    userEmail: currentUserEmail,
  );
  final friendPct = 100.0 - myPct;

  String splitLabel;
  if (myPct == 100.0) {
    splitLabel = '100% You';
  } else if (friendPct == 100.0) {
    splitLabel = '100% $cleanFriendName';
  } else if (expense.splitType == 'fifty_fifty' || (expense.mePercentage == 50.0 && expense.friendPercentage == 50.0)) {
    splitLabel = '50/50';
  } else {
    splitLabel = '${myPct.toInt()}% / ${friendPct.toInt()}%';
  }

  return Container(
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1B1D22) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark ? const Color(0xFF2A2E37) : const Color(0xFFE5E7EB),
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
            color: currencyColor.withValues(alpha: isDark ? 0.16 : 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: currencyColor.withValues(alpha: isDark ? 0.25 : 0.18),
              width: 1,
            ),
          ),
          child: Icon(Icons.receipt_long_rounded, color: currencyColor, size: 22),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                expense.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                '$payerLabel · $splitLabel',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                Formatters.formatDate(expense.date),
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        buildExpenseAmount(
          context: context,
          amount: expense.amount,
          currency: expense.currency,
          color: currencyColor,
          isMyTrackerView: isMyTrackerView,
          personalShare: personalShare,
        ),
      ],
    ),
  );
}
