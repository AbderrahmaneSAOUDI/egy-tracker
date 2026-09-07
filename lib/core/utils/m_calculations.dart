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
  static double calculateCashBalance({
    required String userId,
    required String currency,
    required InitialBalance? initialBalance,
    required List<Exchange> exchanges,
    required List<Expense> expenses,
  }) {
    final normCurrency = currency.toUpperCase().trim();
    double balance = 0.0;

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
      if (exchange.userId != userId) continue;

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
          expense.paidBy == userId) {
        balance -= expense.amount;
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
}
