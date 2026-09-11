import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../home/vm_home_feed.dart';
import 'vm_my_tracker_calculator.dart';
import 'vm_my_tracker_filter.dart';
import 'vm_my_tracker_profiles.dart';
import 'vm_my_tracker_state.dart';

/// Mixin providing reactive getters and computed metrics for My Tracker.
mixin MyTrackerGettersMixin {
  User get user;
  HomeFeedViewModel? get feedViewModel;
  MyTrackerState get state;

  bool get isProcessing => feedViewModel?.isProcessing ?? state.isProcessing;
  String? get errorMessage => feedViewModel?.errorMessage ?? state.errorMessage;
  MyTrackerFilter get filter => state.filter;

  List<Expense> get expenses => feedViewModel?.expenses ?? state.localExpenses;
  List<Exchange> get exchanges => feedViewModel?.exchanges ?? state.localExchanges;
  List<Borrow> get borrows => feedViewModel?.borrows ?? state.localBorrows;
  List<InitialBalance> get balances => feedViewModel?.balances ?? state.localBalances;
  List<UserProfile> get users => feedViewModel?.users ?? state.localUsers;
  List<AllowedEmail> get allowedEmails =>
      feedViewModel?.allowedEmails ?? state.localAllowedEmails;

  AllowedEmail? get friendEmailDoc => feedViewModel?.friendEmailDoc ??
      MyTrackerProfiles.findFriendEmailDoc(allowedEmails, user.email ?? '');
  UserProfile? get friendProfile => feedViewModel?.friendProfile ??
      MyTrackerProfiles.findFriendProfile(users, friendEmailDoc);
  UserProfile? get myProfile => feedViewModel?.myProfile ??
      MyTrackerProfiles.findMyProfile(users, user.uid, user.email ?? '');
  InitialBalance? get myInitialBalance =>
      MyTrackerProfiles.findMyInitialBalance(balances, user.uid, user.email ?? '');

  bool get isPrimaryUser =>
      MyTrackerProfiles.checkIsPrimaryUser(user.email ?? '', allowedEmails);

  double get myUsdBalance => _bal('USD');
  double get myEgpBalance => _bal('EGP');

  double _bal(String cur) => MyTrackerCalculator.calculateCashBalance(
        userId: user.uid,
        currency: cur,
        initialBalance: myInitialBalance,
        exchanges: exchanges,
        expenses: expenses,
        borrows: borrows,
        userEmail: user.email,
        isPrimaryUser: isPrimaryUser,
      );

  double calculateUserPercentage(Expense e) =>
      MyTrackerCalculator.calculateUserPercentage(e, isPrimaryUser);
  double calculateUserShare(Expense e) =>
      MyTrackerCalculator.calculateUserShare(e, isPrimaryUser);

  List<Expense> get myExpenses =>
      MyTrackerCalculator.filterMyExpenses(expenses, isPrimaryUser);
  List<Expense> get sharedExpenses =>
      MyTrackerCalculator.filterSharedExpenses(expenses, isPrimaryUser);
  List<Expense> get allPersonalExpenses =>
      MyTrackerCalculator.filterAllPersonalExpenses(expenses, isPrimaryUser);

  double get totalMyExpensesUsd => _tot(myExpenses, 'USD');
  double get totalMyExpensesEgp => _tot(myExpenses, 'EGP');
  double get totalSharedExpensesUsd => _tot(sharedExpenses, 'USD');
  double get totalSharedExpensesEgp => _tot(sharedExpenses, 'EGP');

  double _tot(List<Expense> l, String c) =>
      MyTrackerCalculator.calculateCategoryTotal(l, c, isPrimaryUser);

  double get totalPersonalSpendingUsd =>
      totalMyExpensesUsd + totalSharedExpensesUsd;
  double get totalPersonalSpendingEgp =>
      totalMyExpensesEgp + totalSharedExpensesEgp;
}
