import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/models/mod_allowed_email.dart';
import '../../core/models/mod_borrow.dart';
import '../../core/models/mod_exchange.dart';
import '../../core/models/mod_expense.dart';
import '../../core/models/mod_initial_balance.dart';
import '../../core/models/mod_user_profile.dart';
import '../../core/services/f_firestore.dart';
import '../../core/utils/m_calculations.dart';
import '../home/vm_home_feed.dart';

/// Available filter tabs for My Tracker expense feed.
enum MyTrackerFilter {
  all,
  myExpenses,
  sharedExpenses,
}

/// ViewModel managing calculations, filtering, and data streams for "My Tracker".
///
/// Strictly enforces domain invariants:
/// 1. USD and EGP balances and spendings are completely separate (no conversions, no combined sums).
/// 2. Physical cash balance (from paid_by) is separated from personal consumption share.
/// 3. My Expenses: user's calculated share is 100%.
/// 4. Shared Expenses: user's calculated share is > 0% and < 100%.
class MyTrackerViewModel extends ChangeNotifier {
  final User user;
  final FirestoreService firestoreService;
  final HomeFeedViewModel? feedViewModel;

  bool _isProcessing = false;
  String? _errorMessage;
  MyTrackerFilter _filter = MyTrackerFilter.all;

  // Local state if standalone (without feedViewModel)
  List<Expense> _localExpenses = [];
  List<Exchange> _localExchanges = [];
  List<Borrow> _localBorrows = [];
  List<InitialBalance> _localBalances = [];
  List<UserProfile> _localUsers = [];
  List<AllowedEmail> _localAllowedEmails = [];

  StreamSubscription? _expensesSub;
  StreamSubscription? _exchangesSub;
  StreamSubscription? _borrowsSub;
  StreamSubscription? _balancesSub;
  StreamSubscription? _usersSub;
  StreamSubscription? _emailsSub;

  MyTrackerViewModel({
    required this.user,
    required this.firestoreService,
    this.feedViewModel,
  }) {
    if (feedViewModel != null) {
      feedViewModel!.addListener(_onFeedUpdated);
    } else {
      _initStandaloneSubscriptions();
    }
  }

  void _onFeedUpdated() {
    notifyListeners();
  }

  void _initStandaloneSubscriptions() {
    _expensesSub = firestoreService.getExpensesStream().listen((data) {
      _localExpenses = data;
      notifyListeners();
    });
    _exchangesSub = firestoreService.getExchangesStream().listen((data) {
      _localExchanges = data;
      notifyListeners();
    });
    _borrowsSub = firestoreService.getBorrowsStream().listen((data) {
      _localBorrows = data;
      notifyListeners();
    });
    _balancesSub = firestoreService.getInitialBalancesStream().listen((data) {
      _localBalances = data;
      notifyListeners();
    });
    _usersSub = firestoreService.getUsersStream().listen((data) {
      _localUsers = data;
      notifyListeners();
    });
    _emailsSub = firestoreService.getAllowedEmailsStream().listen((data) {
      _localAllowedEmails = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    feedViewModel?.removeListener(_onFeedUpdated);
    _expensesSub?.cancel();
    _exchangesSub?.cancel();
    _borrowsSub?.cancel();
    _balancesSub?.cancel();
    _usersSub?.cancel();
    _emailsSub?.cancel();
    super.dispose();
  }

  // --- Getters ---

  bool get isProcessing => feedViewModel?.isProcessing ?? _isProcessing;
  String? get errorMessage => feedViewModel?.errorMessage ?? _errorMessage;
  MyTrackerFilter get filter => _filter;

  List<Expense> get expenses => feedViewModel?.expenses ?? _localExpenses;
  List<Exchange> get exchanges => feedViewModel?.exchanges ?? _localExchanges;
  List<Borrow> get borrows => feedViewModel?.borrows ?? _localBorrows;
  List<InitialBalance> get balances => feedViewModel?.balances ?? _localBalances;
  List<UserProfile> get users => feedViewModel?.users ?? _localUsers;
  List<AllowedEmail> get allowedEmails => feedViewModel?.allowedEmails ?? _localAllowedEmails;

  AllowedEmail? get friendEmailDoc => feedViewModel?.friendEmailDoc ?? _findFriendEmailDoc();
  UserProfile? get friendProfile => feedViewModel?.friendProfile ?? _findFriendProfile();
  UserProfile? get myProfile => feedViewModel?.myProfile ?? _findMyProfile();

  AllowedEmail? _findFriendEmailDoc() {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final e in allowedEmails) {
      if (e.email.toLowerCase().trim() != myEmail) return e;
    }
    return null;
  }

  UserProfile? _findFriendProfile() {
    final doc = friendEmailDoc;
    if (doc == null) return null;
    final fe = doc.email.toLowerCase().trim();
    for (final u in users) {
      if (u.email.toLowerCase().trim() == fe) return u;
    }
    return null;
  }

  UserProfile? _findMyProfile() {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final u in users) {
      if (u.id == user.uid || u.email.toLowerCase().trim() == myEmail) return u;
    }
    return null;
  }

  InitialBalance? get myInitialBalance {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final b in balances) {
      if (b.userId == user.uid || b.userId.toLowerCase().trim() == myEmail) return b;
    }
    return null;
  }

  /// True if the current logged-in user is the primary traveler (first allowed email).
  bool get isPrimaryUser {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    if (myEmail == 'abderrahmane.saoudi.26@gmail.com') return true;
    if (allowedEmails.isEmpty) return true;
    return myEmail == allowedEmails.first.email.toLowerCase().trim();
  }

  /// Calculates the current user's physical cash balance in USD.
  double get myUsdBalance => Calculations.calculateCashBalance(
        userId: user.uid,
        currency: 'USD',
        initialBalance: myInitialBalance,
        exchanges: exchanges,
        expenses: expenses,
        borrows: borrows,
        userEmail: user.email,
        isPrimaryUser: isPrimaryUser,
      );

  /// Calculates the current user's physical cash balance in EGP.
  double get myEgpBalance => Calculations.calculateCashBalance(
        userId: user.uid,
        currency: 'EGP',
        initialBalance: myInitialBalance,
        exchanges: exchanges,
        expenses: expenses,
        borrows: borrows,
        userEmail: user.email,
        isPrimaryUser: isPrimaryUser,
      );

  /// Returns the user's split percentage for a given [expense].
  double calculateUserPercentage(Expense expense) {
    return Calculations.getUserPercentage(
      expense: expense,
      isPrimaryUser: isPrimaryUser,
    );
  }

  /// Calculates the exact personal consumption share for the given [expense].
  double calculateUserShare(Expense expense) {
    return Calculations.calculateUserExpenseShare(
      expense: expense,
      isPrimaryUser: isPrimaryUser,
    );
  }

  /// Returns sorted expenses where the user's calculated personal share is exactly 100%.
  List<Expense> get myExpenses {
    final list = expenses.where((e) {
      final pct = calculateUserPercentage(e);
      return (pct - 100.0).abs() < 0.01;
    }).toList();
    _sortExpenses(list);
    return list;
  }

  /// Returns sorted expenses where the user's calculated personal share is > 0% and < 100%.
  List<Expense> get sharedExpenses {
    final list = expenses.where((e) {
      final pct = calculateUserPercentage(e);
      return pct > 0.01 && pct < 99.99;
    }).toList();
    _sortExpenses(list);
    return list;
  }

  /// Returns all expenses where the user has any personal share (> 0%).
  List<Expense> get allPersonalExpenses {
    final list = expenses.where((e) {
      final pct = calculateUserPercentage(e);
      return pct > 0.01;
    }).toList();
    _sortExpenses(list);
    return list;
  }

  static void _sortExpenses(List<Expense> list) {
    list.sort((a, b) {
      final cmp = b.date.compareTo(a.date);
      if (cmp != 0) return cmp;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  // --- Total Personal Spending (USD and EGP separate, zero combined) ---

  /// Total USD spent across 100% personal expenses.
  double get totalMyExpensesUsd => myExpenses
      .where((e) => e.currency.toUpperCase().trim() == 'USD')
      .fold(0.0, (sum, e) => sum + calculateUserShare(e));

  /// Total EGP spent across 100% personal expenses.
  double get totalMyExpensesEgp => myExpenses
      .where((e) => e.currency.toUpperCase().trim() == 'EGP')
      .fold(0.0, (sum, e) => sum + calculateUserShare(e));

  /// Total USD spent as personal share of shared expenses.
  double get totalSharedExpensesUsd => sharedExpenses
      .where((e) => e.currency.toUpperCase().trim() == 'USD')
      .fold(0.0, (sum, e) => sum + calculateUserShare(e));

  /// Total EGP spent as personal share of shared expenses.
  double get totalSharedExpensesEgp => sharedExpenses
      .where((e) => e.currency.toUpperCase().trim() == 'EGP')
      .fold(0.0, (sum, e) => sum + calculateUserShare(e));

  /// Total personal consumption in USD (My Expenses + Shared Share).
  double get totalPersonalSpendingUsd => totalMyExpensesUsd + totalSharedExpensesUsd;

  /// Total personal consumption in EGP (My Expenses + Shared Share).
  double get totalPersonalSpendingEgp => totalMyExpensesEgp + totalSharedExpensesEgp;

  // --- Filter Mutation ---

  void setFilter(MyTrackerFilter newFilter) {
    if (_filter == newFilter) return;
    _filter = newFilter;
    notifyListeners();
  }

  // --- CRUD Actions ---

  Future<bool> addExpense(Expense expense) async {
    if (feedViewModel != null) return feedViewModel!.addExpense(expense);
    return _performMutation(() => firestoreService.addExpense(expense));
  }

  Future<bool> updateExpense(Expense expense) async {
    if (feedViewModel != null) return feedViewModel!.updateExpense(expense);
    return _performMutation(() => firestoreService.addExpense(expense));
  }

  Future<bool> deleteExpense(String expenseId) async {
    if (feedViewModel != null) return feedViewModel!.deleteExpense(expenseId);
    return _performMutation(() => firestoreService.deleteExpense(expenseId));
  }

  Future<bool> addExchange(Exchange exchange) async {
    if (feedViewModel != null) return feedViewModel!.addExchange(exchange);
    return _performMutation(() => firestoreService.addExchange(exchange));
  }

  Future<bool> updateExchange(Exchange exchange) async {
    if (feedViewModel != null) return feedViewModel!.updateExchange(exchange);
    return _performMutation(() => firestoreService.addExchange(exchange));
  }

  Future<bool> deleteExchange(String exchangeId) async {
    if (feedViewModel != null) return feedViewModel!.deleteExchange(exchangeId);
    return _performMutation(() => firestoreService.deleteExchange(exchangeId));
  }

  Future<bool> addBorrow(Borrow borrow) async {
    if (feedViewModel != null) return feedViewModel!.addBorrow(borrow);
    return _performMutation(() => firestoreService.addBorrow(borrow));
  }

  Future<bool> updateBorrow(Borrow borrow) async {
    if (feedViewModel != null) return feedViewModel!.updateBorrow(borrow);
    return _performMutation(() => firestoreService.addBorrow(borrow));
  }

  Future<bool> deleteBorrow(String borrowId) async {
    if (feedViewModel != null) return feedViewModel!.deleteBorrow(borrowId);
    return _performMutation(() => firestoreService.deleteBorrow(borrowId));
  }

  Future<bool> _performMutation(Future<void> Function() action) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isProcessing = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
