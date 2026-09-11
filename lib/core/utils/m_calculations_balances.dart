import '../models/mod_borrow.dart';
import '../models/mod_exchange.dart';
import '../models/mod_expense.dart';
import '../models/mod_initial_balance.dart';
import 'm_calculations_shares.dart';

/// Calculates the physical cash balance for a given [userId] and [currency] ('USD' or 'EGP').
double calculateCashBalanceInternal({
  required String userId,
  required String currency,
  required InitialBalance? initialBalance,
  required List<Exchange> exchanges,
  required List<Expense> expenses,
  List<Borrow> borrows = const [],
  String? userEmail,
  bool isPrimaryUser = true,
}) {
  final normCurrency = currency.toUpperCase().trim();
  double balance = 0.0;

  bool matchesUser(String candidateId) {
    final c = candidateId.toLowerCase().trim();
    if (c.isEmpty) return false;
    if (c == userId.toLowerCase().trim()) return true;
    if (userEmail != null && userEmail.isNotEmpty && c == userEmail.toLowerCase().trim()) {
      return true;
    }
    return false;
  }

  // 1. Starting cash from configuration
  if (initialBalance != null) {
    if (normCurrency == 'USD') {
      balance += initialBalance.usdAmount;
    } else if (normCurrency == 'EGP') {
      balance += initialBalance.egpAmount;
    }
  }

  // 2. Exchanges: Balance transfers for this user
  for (final exchange in exchanges) {
    if (!matchesUser(exchange.userId)) continue;
    if (exchange.toCurrency.toUpperCase().trim() == normCurrency) {
      balance += exchange.toAmount;
    }
    if (exchange.fromCurrency.toUpperCase().trim() == normCurrency) {
      balance -= exchange.fromAmount;
    }
  }

  // 3. Expenses: Reduce money depending on percentage of each user when split, or payer when not split
  for (final expense in expenses) {
    if (expense.currency.toUpperCase().trim() != normCurrency) continue;
    final isSplit = (expense.splitType == 'fifty_fifty') ||
        (expense.splitType == 'custom' &&
            expense.mePercentage > 0 &&
            expense.friendPercentage > 0);

    if (isSplit) {
      final pct = getUserPercentageInternal(
        expense: expense,
        isPrimaryUser: isPrimaryUser,
        userId: userId,
        userEmail: userEmail,
      );
      balance -= expense.amount * (pct / 100.0);
    } else {
      if (matchesUser(expense.paidBy)) {
        balance -= expense.amount;
      }
    }
  }

  // 4. Borrows: Physical cash transferred between users in real life
  for (final borrow in borrows) {
    final isBorrower = matchesUser(borrow.borrowerId);
    final isLender = matchesUser(borrow.lenderId);
    if (normCurrency == 'USD') {
      if (isBorrower) balance += borrow.usdAmount;
      if (isLender) balance -= borrow.usdAmount;
    } else if (normCurrency == 'EGP') {
      if (isBorrower) balance += borrow.egpAmount;
      if (isLender) balance -= borrow.egpAmount;
    }
  }

  return balance;
}
