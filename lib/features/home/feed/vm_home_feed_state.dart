import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../../core/services/f_firestore.dart';

/// Manages Firestore stream subscriptions and raw state collections for the home feed.
class HomeFeedState {
  final FirestoreService firestoreService;

  List<Expense> expenses = [];
  List<Exchange> exchanges = [];
  List<Borrow> borrows = [];
  List<InitialBalance> balances = [];
  List<UserProfile> users = [];
  List<AllowedEmail> allowedEmails = [];

  StreamSubscription? _expensesSub;
  StreamSubscription? _exchangesSub;
  StreamSubscription? _borrowsSub;
  StreamSubscription? _balancesSub;
  StreamSubscription? _usersSub;
  StreamSubscription? _emailsSub;

  HomeFeedState({required this.firestoreService});

  void initSubscriptions(VoidCallback onUpdate) {
    _expensesSub = firestoreService.getExpensesStream().listen((data) {
      expenses = data;
      onUpdate();
    });
    _exchangesSub = firestoreService.getExchangesStream().listen((data) {
      exchanges = data;
      onUpdate();
    });
    _borrowsSub = firestoreService.getBorrowsStream().listen((data) {
      borrows = data;
      onUpdate();
    });
    _balancesSub = firestoreService.getInitialBalancesStream().listen((data) {
      balances = data;
      onUpdate();
    });
    _usersSub = firestoreService.getUsersStream().listen((data) {
      users = data;
      onUpdate();
    });
    _emailsSub = firestoreService.getAllowedEmailsStream().listen((data) {
      allowedEmails = data;
      onUpdate();
    });
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
