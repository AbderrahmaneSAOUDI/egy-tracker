import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/utils/m_calculations.dart';

/// Calculations and filtering engine for My Tracker.
class MyTrackerCalculator {
  static void sortExpenses(List<Expense> list) {
    list.sort((a, b) {
      final cmp = b.date.compareTo(a.date);
      if (cmp != 0) return cmp;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  static double calculateUserPercentage(Expense expense, bool isPrimaryUser) {
    return Calculations.getUserPercentage(
      expense: expense,
      isPrimaryUser: isPrimaryUser,
    );
  }

  static double calculateUserShare(Expense expense, bool isPrimaryUser) {
    return Calculations.calculateUserExpenseShare(
      expense: expense,
      isPrimaryUser: isPrimaryUser,
    );
  }

  static List<Expense> filterMyExpenses(
    List<Expense> expenses,
    bool isPrimaryUser,
  ) {
    final list = expenses.where((e) {
      final pct = calculateUserPercentage(e, isPrimaryUser);
      return (pct - 100.0).abs() < 0.01;
    }).toList();
    sortExpenses(list);
    return list;
  }

  static List<Expense> filterSharedExpenses(
    List<Expense> expenses,
    bool isPrimaryUser,
  ) {
    final list = expenses.where((e) {
      final pct = calculateUserPercentage(e, isPrimaryUser);
      return pct > 0.01 && pct < 99.99;
    }).toList();
    sortExpenses(list);
    return list;
  }

  static List<Expense> filterAllPersonalExpenses(
    List<Expense> expenses,
    bool isPrimaryUser,
  ) {
    final list = expenses.where((e) {
      final pct = calculateUserPercentage(e, isPrimaryUser);
      return pct > 0.01;
    }).toList();
    sortExpenses(list);
    return list;
  }

  static double calculateCategoryTotal(
    List<Expense> list,
    String currency,
    bool isPrimaryUser,
  ) {
    final cur = currency.toUpperCase().trim();
    return list
        .where((e) => e.currency.toUpperCase().trim() == cur)
        .fold(0.0, (sum, e) => sum + calculateUserShare(e, isPrimaryUser));
  }

  static double calculateCashBalance({
    required String userId,
    required String currency,
    required InitialBalance? initialBalance,
    required List<Exchange> exchanges,
    required List<Expense> expenses,
    required List<Borrow> borrows,
    required String? userEmail,
    required bool isPrimaryUser,
  }) {
    return Calculations.calculateCashBalance(
      userId: userId,
      currency: currency,
      initialBalance: initialBalance,
      exchanges: exchanges,
      expenses: expenses,
      borrows: borrows,
      userEmail: userEmail,
      isPrimaryUser: isPrimaryUser,
    );
  }
}
