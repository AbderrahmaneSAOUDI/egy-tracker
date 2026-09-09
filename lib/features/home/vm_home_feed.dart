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
import 'models/mod_activity_item.dart';

/// ViewModel managing data subscriptions, calculations, and mutations for the Home feed.
class HomeFeedViewModel extends ChangeNotifier {
  final User user;
  final FirestoreService firestoreService;

  bool _isProcessing = false;
  String? _errorMessage;

  List<Expense> _expenses = [];
  List<Exchange> _exchanges = [];
  List<Borrow> _borrows = [];
  List<InitialBalance> _balances = [];
  List<UserProfile> _users = [];
  List<AllowedEmail> _allowedEmails = [];

  StreamSubscription? _expensesSub;
  StreamSubscription? _exchangesSub;
  StreamSubscription? _borrowsSub;
  StreamSubscription? _balancesSub;
  StreamSubscription? _usersSub;
  StreamSubscription? _emailsSub;

  HomeFeedViewModel({
    required this.user,
    required this.firestoreService,
  }) {
    _expensesSub = firestoreService.getExpensesStream().listen((data) {
      _expenses = data;
      notifyListeners();
    });
    _exchangesSub = firestoreService.getExchangesStream().listen((data) {
      _exchanges = data;
      notifyListeners();
    });
    _borrowsSub = firestoreService.getBorrowsStream().listen((data) {
      _borrows = data;
      notifyListeners();
    });
    _balancesSub = firestoreService.getInitialBalancesStream().listen((data) {
      _balances = data;
      notifyListeners();
    });
    _usersSub = firestoreService.getUsersStream().listen((data) {
      _users = data;
      notifyListeners();
    });
    _emailsSub = firestoreService.getAllowedEmailsStream().listen((data) {
      _allowedEmails = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _expensesSub?.cancel();
    _exchangesSub?.cancel();
    _borrowsSub?.cancel();
    _balancesSub?.cancel();
    _usersSub?.cancel();
    _emailsSub?.cancel();
    super.dispose();
  }

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  List<Expense> get expenses => _expenses;
  List<Exchange> get exchanges => _exchanges;
  List<InitialBalance> get balances => _balances;
  List<UserProfile> get users => _users;
  List<AllowedEmail> get allowedEmails => _allowedEmails;

  /// Returns all expenses, exchanges, and borrows combined in descending order.
  List<ActivityItem> get activities {
    final list = <ActivityItem>[
      ..._expenses.map((e) => ActivityItem.expense(e)),
      ..._exchanges.map((e) => ActivityItem.exchange(e)),
      ..._borrows.map((b) => ActivityItem.borrow(b)),
    ];
    list.sort((a, b) {
      final cmp = b.date.compareTo(a.date);
      if (cmp != 0) return cmp;
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  AllowedEmail? get friendEmailDoc {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final e in _allowedEmails) {
      if (e.email.toLowerCase().trim() != myEmail) {
        return e;
      }
    }
    return null;
  }

  UserProfile? get friendProfile {
    final doc = friendEmailDoc;
    if (doc == null) return null;
    final fe = doc.email.toLowerCase().trim();
    for (final u in _users) {
      if (u.email.toLowerCase().trim() == fe) {
        return u;
      }
    }
    return null;
  }

  UserProfile? get myProfile {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final u in _users) {
      if (u.id == user.uid || u.email.toLowerCase().trim() == myEmail) {
        return u;
      }
    }
    return null;
  }

  InitialBalance? get myInitialBalance {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final b in _balances) {
      if (b.userId == user.uid || b.userId.toLowerCase().trim() == myEmail) {
        return b;
      }
    }
    return null;
  }

  InitialBalance? get friendInitialBalance {
    final fp = friendProfile;
    final fe = friendEmailDoc?.email.toLowerCase().trim();
    for (final b in _balances) {
      if (b.userId == fp?.id || (fe != null && b.userId.toLowerCase().trim() == fe)) {
        return b;
      }
    }
    return null;
  }

  double get myUsdBalance => Calculations.calculateCashBalance(
        userId: user.uid,
        currency: 'USD',
        initialBalance: myInitialBalance,
        exchanges: _exchanges,
        expenses: _expenses,
        borrows: _borrows,
      );

  double get myEgpBalance => Calculations.calculateCashBalance(
        userId: user.uid,
        currency: 'EGP',
        initialBalance: myInitialBalance,
        exchanges: _exchanges,
        expenses: _expenses,
        borrows: _borrows,
      );

  double get friendUsdBalance {
    final fId = friendProfile?.id ?? friendEmailDoc?.email.toLowerCase().trim();
    if (fId == null) return 0.0;
    return Calculations.calculateCashBalance(
      userId: fId,
      currency: 'USD',
      initialBalance: friendInitialBalance,
      exchanges: _exchanges,
      expenses: _expenses,
      borrows: _borrows,
    );
  }

  double get friendEgpBalance {
    final fId = friendProfile?.id ?? friendEmailDoc?.email.toLowerCase().trim();
    if (fId == null) return 0.0;
    return Calculations.calculateCashBalance(
      userId: fId,
      currency: 'EGP',
      initialBalance: friendInitialBalance,
      exchanges: _exchanges,
      expenses: _expenses,
      borrows: _borrows,
    );
  }

  /// Adds a new expense to Firestore.
  Future<bool> addExpense(Expense expense) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await firestoreService.addExpense(expense);
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add expense: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Deletes an expense by its ID.
  Future<bool> deleteExpense(String id) async {
    try {
      await firestoreService.deleteExpense(id);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete expense: $e';
      notifyListeners();
      return false;
    }
  }

  /// Adds a new currency exchange transfer to Firestore.
  Future<bool> addExchange(Exchange exchange) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await firestoreService.addExchange(exchange);
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to record exchange: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Deletes an exchange by its ID.
  Future<bool> deleteExchange(String id) async {
    try {
      await firestoreService.deleteExchange(id);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete exchange: $e';
      notifyListeners();
      return false;
    }
  }

  /// Records money borrowed between users.
  Future<bool> addBorrow(Borrow borrow) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await firestoreService.addBorrow(borrow);
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to record borrow: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Deletes a borrow record by its ID.
  Future<bool> deleteBorrow(String id) async {
    try {
      await firestoreService.deleteBorrow(id);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete borrow: $e';
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing expense in Firestore.
  Future<bool> updateExpense(Expense expense) => addExpense(expense);

  /// Updates an existing exchange in Firestore.
  Future<bool> updateExchange(Exchange exchange) => addExchange(exchange);

  /// Updates an existing borrow record in Firestore.
  Future<bool> updateBorrow(Borrow borrow) => addBorrow(borrow);

  /// Forces a notification refresh for pull-to-refresh.
  Future<void> refresh() async {
    notifyListeners();
  }
}
