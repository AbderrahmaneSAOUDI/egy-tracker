import 'dart:async';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../../core/services/f_firestore.dart';

/// Manages Firestore stream subscriptions for standalone My Tracker mode.
class MyTrackerSubscriptions {
  StreamSubscription? _expensesSub;
  StreamSubscription? _exchangesSub;
  StreamSubscription? _borrowsSub;
  StreamSubscription? _balancesSub;
  StreamSubscription? _usersSub;
  StreamSubscription? _emailsSub;

  void init({
    required FirestoreService firestoreService,
    required void Function(List<Expense>) onExpenses,
    required void Function(List<Exchange>) onExchanges,
    required void Function(List<Borrow>) onBorrows,
    required void Function(List<InitialBalance>) onBalances,
    required void Function(List<UserProfile>) onUsers,
    required void Function(List<AllowedEmail>) onEmails,
  }) {
    _expensesSub = firestoreService.getExpensesStream().listen(onExpenses);
    _exchangesSub = firestoreService.getExchangesStream().listen(onExchanges);
    _borrowsSub = firestoreService.getBorrowsStream().listen(onBorrows);
    _balancesSub = firestoreService.getInitialBalancesStream().listen(onBalances);
    _usersSub = firestoreService.getUsersStream().listen(onUsers);
    _emailsSub = firestoreService.getAllowedEmailsStream().listen(onEmails);
  }

  void dispose() {
    _expensesSub?.cancel();
    _exchangesSub?.cancel();
    _borrowsSub?.cancel();
    _balancesSub?.cancel();
    _usersSub?.cancel();
    _emailsSub?.cancel();
  }
}
