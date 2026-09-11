import 'package:flutter/foundation.dart';
import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/services/f_firestore.dart';
import '../../home/vm_home_feed.dart';
import 'vm_my_tracker_state.dart';

/// Mixin providing CRUD mutations for MyTrackerViewModel.
mixin MyTrackerMutationsMixin on ChangeNotifier {
  HomeFeedViewModel? get feedViewModel;
  FirestoreService get firestoreService;
  MyTrackerState get state;

  Future<bool> addExpense(Expense e) => _run(
        feed: () => feedViewModel!.addExpense(e),
        fallback: () => firestoreService.addExpense(e),
      );

  Future<bool> updateExpense(Expense e) => _run(
        feed: () => feedViewModel!.updateExpense(e),
        fallback: () => firestoreService.addExpense(e),
      );

  Future<bool> deleteExpense(String id) => _run(
        feed: () => feedViewModel!.deleteExpense(id),
        fallback: () => firestoreService.deleteExpense(id),
      );

  Future<bool> addExchange(Exchange e) => _run(
        feed: () => feedViewModel!.addExchange(e),
        fallback: () => firestoreService.addExchange(e),
      );

  Future<bool> updateExchange(Exchange e) => _run(
        feed: () => feedViewModel!.updateExchange(e),
        fallback: () => firestoreService.addExchange(e),
      );

  Future<bool> deleteExchange(String id) => _run(
        feed: () => feedViewModel!.deleteExchange(id),
        fallback: () => firestoreService.deleteExchange(id),
      );

  Future<bool> addBorrow(Borrow b) => _run(
        feed: () => feedViewModel!.addBorrow(b),
        fallback: () => firestoreService.addBorrow(b),
      );

  Future<bool> updateBorrow(Borrow b) => _run(
        feed: () => feedViewModel!.updateBorrow(b),
        fallback: () => firestoreService.addBorrow(b),
      );

  Future<bool> deleteBorrow(String id) => _run(
        feed: () => feedViewModel!.deleteBorrow(id),
        fallback: () => firestoreService.deleteBorrow(id),
      );

  Future<bool> _run({
    required Future<bool> Function() feed,
    required Future<void> Function() fallback,
  }) async {
    if (feedViewModel != null) return feed();
    state.isProcessing = true;
    state.errorMessage = null;
    notifyListeners();
    try {
      await fallback();
      state.isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      state.isProcessing = false;
      state.errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
