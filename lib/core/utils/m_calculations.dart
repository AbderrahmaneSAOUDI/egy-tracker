import '../models/mod_borrow.dart';
import '../models/mod_exchange.dart';
import '../models/mod_expense.dart';
import '../models/mod_initial_balance.dart';

/// Calculation engine strictly enforcing the independent two-currency domain rules.
class Calculations {
  Calculations._();

  /// Calculates the physical cash balance for a given [userId] and [currency] ('USD' or 'EGP').
  ///
  /// Formula:
  /// Current Balance = Initial Balance
  ///                 + Exchanges In (as to_currency)
  ///                 - Exchanges Out (as from_currency)
  ///                 - Expenses Paid (where paid_by == user)
  ///                 + Borrows In (where borrower_id == user)
  ///                 - Borrows Out (where lender_id == user)
  static double calculateCashBalance({
    required String userId,
    required String currency,
    required InitialBalance? initialBalance,
    required List<Exchange> exchanges,
    required List<Expense> expenses,
    List<Borrow> borrows = const [],
    String? userEmail,
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

    // 3. Expenses: Physical cash subtracted strictly from the payer
    for (final expense in expenses) {
      if (expense.currency.toUpperCase().trim() == normCurrency &&
          matchesUser(expense.paidBy)) {
        balance -= expense.amount;
      }
    }

    // 4. Borrows: Physical cash transferred between users in real life
    for (final borrow in borrows) {
      final isBorrower = matchesUser(borrow.borrowerId);
      final isLender = matchesUser(borrow.lenderId);

      if (normCurrency == 'USD') {
        if (isBorrower) {
          balance += borrow.usdAmount;
        } else if (isLender) {
          balance -= borrow.usdAmount;
        }
      } else if (normCurrency == 'EGP') {
        if (isBorrower) {
          balance += borrow.egpAmount;
        } else if (isLender) {
          balance -= borrow.egpAmount;
        }
      }
    }

    return balance;
  }

  /// Calculates the personal consumption share for a specific [userPercentage].
  ///
  /// Formula:
  /// Personal Share = Expense Amount * (User Percentage / 100)
  static double calculatePersonalShare({
    required double amount,
    required double userPercentage,
  }) {
    return amount * (userPercentage / 100.0);
  }

  /// Returns the personal percentage for the given user on an [expense].
  ///
  /// For 'fifty_fifty', returns 50.0.
  /// For other split types, returns [expense.mePercentage] if [isPrimaryUser] is true,
  /// or [expense.friendPercentage] if [isPrimaryUser] is false.
  static double getUserPercentage({
    required Expense expense,
    required bool isPrimaryUser,
  }) {
    if (expense.splitType == 'fifty_fifty') return 50.0;
    return isPrimaryUser ? expense.mePercentage : expense.friendPercentage;
  }

  /// Calculates the exact personal consumption share for the given user on an [expense].
  static double calculateUserExpenseShare({
    required Expense expense,
    required bool isPrimaryUser,
  }) {
    final pct = getUserPercentage(expense: expense, isPrimaryUser: isPrimaryUser);
    return calculatePersonalShare(amount: expense.amount, userPercentage: pct);
  }
}
