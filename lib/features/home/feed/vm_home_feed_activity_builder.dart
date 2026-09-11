import '../../../core/models/mod_activity_item.dart';
import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';

/// Pure functions to aggregate, sort, and categorize activities for home feed.
class HomeFeedActivityBuilder {
  static List<ActivityItem> buildAll({
    required List<Expense> expenses,
    required List<Exchange> exchanges,
    required List<Borrow> borrows,
  }) {
    final list = <ActivityItem>[
      ...expenses.map((e) => ActivityItem.expense(e)),
      ...exchanges.map((e) => ActivityItem.exchange(e)),
      ...borrows.map((b) => ActivityItem.borrow(b)),
    ];
    list.sort((a, b) {
      final cmp = b.date.compareTo(a.date);
      if (cmp != 0) return cmp;
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  static List<ActivityItem> buildFriend({
    required List<ActivityItem> allActivities,
    required double Function(Expense) userPctCalculator,
    required String myUid,
    required String? myEmail,
  }) {
    final email = myEmail?.toLowerCase().trim() ?? '';
    return allActivities.where((item) {
      if (item.isExpense) {
        return userPctCalculator(item.expense!) < 0.01;
      } else if (item.isExchange) {
        final exUser = item.exchange!.userId.toLowerCase().trim();
        return exUser != myUid && exUser != email;
      }
      return false;
    }).toList();
  }

  static List<ActivityItem> buildSplit({
    required List<ActivityItem> allActivities,
    required double Function(Expense) userPctCalculator,
  }) {
    return allActivities.where((item) {
      if (item.isExpense) {
        final pct = userPctCalculator(item.expense!);
        return pct > 0.01 && pct < 99.99;
      } else if (item.isBorrow) {
        return true;
      }
      return false;
    }).toList();
  }

  static List<ActivityItem> buildMine({
    required List<ActivityItem> allActivities,
    required double Function(Expense) userPctCalculator,
    required String myUid,
    required String? myEmail,
  }) {
    final email = myEmail?.toLowerCase().trim() ?? '';
    return allActivities.where((item) {
      if (item.isExpense) {
        return (userPctCalculator(item.expense!) - 100.0).abs() < 0.01;
      } else if (item.isExchange) {
        final exUser = item.exchange!.userId.toLowerCase().trim();
        return exUser == myUid || exUser == email;
      }
      return false;
    }).toList();
  }
}
