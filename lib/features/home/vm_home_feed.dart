import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/models/mod_activity_item.dart';
import '../../core/models/mod_allowed_email.dart';
import '../../core/models/mod_borrow.dart';
import '../../core/models/mod_exchange.dart';
import '../../core/models/mod_expense.dart';
import '../../core/models/mod_initial_balance.dart';
import '../../core/models/mod_user_profile.dart';
import '../../core/services/f_firestore.dart';
import '../../core/utils/m_calculations.dart';
import 'feed/vm_home_feed_activity_builder.dart';
import 'feed/vm_home_feed_balance_calculator.dart';
import 'feed/vm_home_feed_filter.dart';
import 'feed/vm_home_feed_mutations.dart';
import 'feed/vm_home_feed_profiles.dart';
import 'feed/vm_home_feed_state.dart';

export 'feed/vm_home_feed_filter.dart';

/// ViewModel managing data subscriptions, calculations, and mutations for the Home feed.
class HomeFeedViewModel extends ChangeNotifier with HomeFeedMutationsMixin {
  final User user;
  final FirestoreService firestoreService;
  late final HomeFeedState _state;
  late final HomeFeedMutations _mutations;

  HomeFeedFilter _filter = HomeFeedFilter.all;
  List<ActivityItem> _cachedAll = [];
  List<ActivityItem> _cachedFriend = [];
  List<ActivityItem> _cachedSplit = [];
  List<ActivityItem> _cachedMine = [];
  HomeBalancesResult _balances = const HomeBalancesResult(myUsd: 0, myEgp: 0, friendUsd: 0, friendEgp: 0);

  HomeFeedViewModel({required this.user, required this.firestoreService}) {
    _mutations = HomeFeedMutations(firestoreService: firestoreService);
    _state = HomeFeedState(firestoreService: firestoreService);
    _state.initSubscriptions(_scheduleNotify);
    _recalculate();
  }

  void _scheduleNotify() {
    _recalculate();
    notifyListeners();
  }

  void _recalculate() {
    _cachedAll = HomeFeedActivityBuilder.buildAll(expenses: _state.expenses, exchanges: _state.exchanges, borrows: _state.borrows);
    _cachedFriend = HomeFeedActivityBuilder.buildFriend(allActivities: _cachedAll, userPctCalculator: calculateUserPercentage, myUid: user.uid, myEmail: user.email);
    _cachedSplit = HomeFeedActivityBuilder.buildSplit(allActivities: _cachedAll, userPctCalculator: calculateUserPercentage);
    _cachedMine = HomeFeedActivityBuilder.buildMine(allActivities: _cachedAll, userPctCalculator: calculateUserPercentage, myUid: user.uid, myEmail: user.email);
    _balances = HomeFeedBalanceCalculator.calculate(
      myUid: user.uid, myEmail: user.email, isPrimaryUser: isPrimaryUser,
      myInitialBalance: myInitialBalance, friendInitialBalance: friendInitialBalance,
      friendProfile: friendProfile, friendEmail: friendEmailDoc?.email,
      expenses: _state.expenses, exchanges: _state.exchanges, borrows: _state.borrows,
    );
  }

  List<Expense> get expenses => _state.expenses;
  List<Exchange> get exchanges => _state.exchanges;
  List<Borrow> get borrows => _state.borrows;
  List<InitialBalance> get balances => _state.balances;
  List<UserProfile> get users => _state.users;
  List<AllowedEmail> get allowedEmails => _state.allowedEmails;

  double calculateUserPercentage(Expense e) => Calculations.getUserPercentage(expense: e, isPrimaryUser: isPrimaryUser, userId: user.uid);

  List<ActivityItem> get activities => _cachedAll;
  List<ActivityItem> get allActivities => _cachedAll;
  List<ActivityItem> get friendActivities => _cachedFriend;
  List<ActivityItem> get splitActivities => _cachedSplit;
  List<ActivityItem> get mineActivities => _cachedMine;
  List<ActivityItem> get sharedActivities => _cachedSplit;

  HomeFeedFilter get filter => _filter;
  void setFilter(HomeFeedFilter f) { if (_filter != f) { _filter = f; notifyListeners(); } }

  List<ActivityItem> get filteredActivities => switch (_filter) {
    HomeFeedFilter.all => allActivities,
    HomeFeedFilter.friend => friendActivities,
    HomeFeedFilter.split => splitActivities,
  };

  bool get isPrimaryUser => HomeFeedProfiles.checkIsPrimaryUser(user, _state.allowedEmails);
  AllowedEmail? get friendEmailDoc => HomeFeedProfiles.resolveFriendEmailDoc(user, _state.allowedEmails);
  UserProfile? get friendProfile => HomeFeedProfiles.resolveFriendProfile(friendEmailDoc, _state.users);
  UserProfile? get myProfile => HomeFeedProfiles.resolveMyProfile(user, _state.users);
  InitialBalance? get myInitialBalance => HomeFeedProfiles.resolveMyInitialBalance(user, _state.balances);
  InitialBalance? get friendInitialBalance => HomeFeedProfiles.resolveFriendInitialBalance(friendProfile, friendEmailDoc, _state.balances);

  double get myUsdBalance => _balances.myUsd;
  double get myEgpBalance => _balances.myEgp;
  double get friendUsdBalance => _balances.friendUsd;
  double get friendEgpBalance => _balances.friendEgp;

  bool get isProcessing => false;
  String? get errorMessage => null;

  Future<void> refresh() async {
    _recalculate();
    notifyListeners();
  }

  @override
  HomeFeedMutations get mutations => _mutations;

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }
}
