import 'mod_borrow.dart';
import 'mod_exchange.dart';
import 'mod_expense.dart';

/// Unified model representing a single chronological activity item
/// (an [Expense], an [Exchange], or a [Borrow]) across Home and My Tracker feeds.
class ActivityItem {
  final Expense? expense;
  final Exchange? exchange;
  final Borrow? borrow;

  const ActivityItem.expense(Expense this.expense)
      : exchange = null,
        borrow = null;

  const ActivityItem.exchange(Exchange this.exchange)
      : expense = null,
        borrow = null;

  const ActivityItem.borrow(Borrow this.borrow)
      : expense = null,
        exchange = null;

  bool get isExpense => expense != null;
  bool get isExchange => exchange != null;
  bool get isBorrow => borrow != null;

  String get id => expense?.id ?? exchange?.id ?? borrow!.id;
  DateTime get date => expense?.date ?? exchange?.date ?? borrow!.date;
  DateTime get createdAt =>
      expense?.createdAt ?? exchange?.createdAt ?? borrow!.createdAt;
}
