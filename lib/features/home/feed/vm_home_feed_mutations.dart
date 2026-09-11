import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/services/f_firestore.dart';

/// Mutation operations for the home feed view model.
class HomeFeedMutations {
  final FirestoreService firestoreService;

  const HomeFeedMutations({required this.firestoreService});

  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addExpense(Expense expense) => _run(() => firestoreService.addExpense(expense));
  Future<bool> updateExpense(Expense expense) => _run(() => firestoreService.addExpense(expense));
  Future<bool> deleteExpense(String id) => _run(() => firestoreService.deleteExpense(id));
  Future<bool> addExchange(Exchange exchange) => _run(() => firestoreService.addExchange(exchange));
  Future<bool> updateExchange(Exchange exchange) => _run(() => firestoreService.addExchange(exchange));
  Future<bool> deleteExchange(String id) => _run(() => firestoreService.deleteExchange(id));
  Future<bool> addBorrow(Borrow borrow) => _run(() => firestoreService.addBorrow(borrow));
  Future<bool> updateBorrow(Borrow borrow) => _run(() => firestoreService.addBorrow(borrow));
  Future<bool> deleteBorrow(String id) => _run(() => firestoreService.deleteBorrow(id));
}

/// Mixin exposing mutation methods directly on a HomeFeedViewModel.
mixin HomeFeedMutationsMixin {
  HomeFeedMutations get mutations;

  Future<bool> addExpense(Expense e) => mutations.addExpense(e);
  Future<bool> updateExpense(Expense e) => mutations.updateExpense(e);
  Future<bool> deleteExpense(String id) => mutations.deleteExpense(id);
  Future<bool> addExchange(Exchange e) => mutations.addExchange(e);
  Future<bool> updateExchange(Exchange e) => mutations.updateExchange(e);
  Future<bool> deleteExchange(String id) => mutations.deleteExchange(id);
  Future<bool> addBorrow(Borrow b) => mutations.addBorrow(b);
  Future<bool> updateBorrow(Borrow b) => mutations.updateBorrow(b);
  Future<bool> deleteBorrow(String id) => mutations.deleteBorrow(id);
}
