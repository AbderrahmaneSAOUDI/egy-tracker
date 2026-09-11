import '../models/mod_expense.dart';

/// Calculates the personal consumption share for a specific [userPercentage].
double calculatePersonalShareInternal({
  required double amount,
  required double userPercentage,
}) {
  return amount * (userPercentage / 100.0);
}

/// Returns the personal percentage for the given user on an [expense].
double getUserPercentageInternal({
  required Expense expense,
  required bool isPrimaryUser,
  String? userId,
}) {
  if (expense.splitType == 'fifty_fifty') return 50.0;

  if (expense.createdBy.isNotEmpty && userId != null && userId.isNotEmpty) {
    final isCreator = expense.createdBy == userId;
    return isCreator ? expense.mePercentage : expense.friendPercentage;
  }

  return isPrimaryUser ? expense.mePercentage : expense.friendPercentage;
}

/// Calculates the exact personal consumption share for the given user on an [expense].
double calculateUserExpenseShareInternal({
  required Expense expense,
  required bool isPrimaryUser,
  String? userId,
}) {
  final pct = getUserPercentageInternal(
    expense: expense,
    isPrimaryUser: isPrimaryUser,
    userId: userId,
  );
  return calculatePersonalShareInternal(amount: expense.amount, userPercentage: pct);
}
