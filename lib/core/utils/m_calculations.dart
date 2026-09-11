import '../models/mod_borrow.dart';
import '../models/mod_exchange.dart';
import '../models/mod_expense.dart';
import '../models/mod_initial_balance.dart';
import 'm_calculations_balances.dart';
import 'm_calculations_shares.dart';

export 'm_calculations_balances.dart';
export 'm_calculations_shares.dart';

/// Calculation engine strictly enforcing the independent two-currency domain rules.
class Calculations {
  Calculations._();

  /// Calculates the physical cash balance for a given [userId] and [currency] ('USD' or 'EGP').
  static double calculateCashBalance({
    required String userId,
    required String currency,
    required InitialBalance? initialBalance,
    required List<Exchange> exchanges,
    required List<Expense> expenses,
    List<Borrow> borrows = const [],
    String? userEmail,
    bool isPrimaryUser = true,
  }) =>
      calculateCashBalanceInternal(
        userId: userId,
        currency: currency,
        initialBalance: initialBalance,
        exchanges: exchanges,
        expenses: expenses,
        borrows: borrows,
        userEmail: userEmail,
        isPrimaryUser: isPrimaryUser,
      );

  /// Calculates the personal consumption share for a specific [userPercentage].
  static double calculatePersonalShare({
    required double amount,
    required double userPercentage,
  }) =>
      calculatePersonalShareInternal(
        amount: amount,
        userPercentage: userPercentage,
      );

  /// Returns the personal percentage for the given user on an [expense].
  static double getUserPercentage({
    required Expense expense,
    required bool isPrimaryUser,
    String? userId,
    String? userEmail,
  }) =>
      getUserPercentageInternal(
        expense: expense,
        isPrimaryUser: isPrimaryUser,
        userId: userId,
        userEmail: userEmail,
      );

  /// Calculates the exact personal consumption share for the given user on an [expense].
  static double calculateUserExpenseShare({
    required Expense expense,
    required bool isPrimaryUser,
    String? userId,
    String? userEmail,
  }) =>
      calculateUserExpenseShareInternal(
        expense: expense,
        isPrimaryUser: isPrimaryUser,
        userId: userId,
        userEmail: userEmail,
      );
}
