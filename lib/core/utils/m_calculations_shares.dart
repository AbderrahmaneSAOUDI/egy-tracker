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
  String? userEmail,
}) {
  if (expense.splitType == 'fifty_fifty') return 50.0;

  if (expense.createdBy.isNotEmpty && ((userId != null && userId.isNotEmpty) || (userEmail != null && userEmail.isNotEmpty))) {
    final creator = expense.createdBy.toLowerCase().trim();
    final isCreator = (userId != null && creator == userId.toLowerCase().trim()) ||
        (userEmail != null && creator == userEmail.toLowerCase().trim());
    return isCreator ? expense.mePercentage : expense.friendPercentage;
  }

  return isPrimaryUser ? expense.mePercentage : expense.friendPercentage;
}

/// Calculates the exact personal consumption share for the given user on an [expense].
double calculateUserExpenseShareInternal({
  required Expense expense,
  required bool isPrimaryUser,
  String? userId,
  String? userEmail,
}) {
  final pct = getUserPercentageInternal(
    expense: expense,
    isPrimaryUser: isPrimaryUser,
    userId: userId,
    userEmail: userEmail,
  );
  return calculatePersonalShareInternal(amount: expense.amount, userPercentage: pct);
}
