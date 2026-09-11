import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../../core/utils/m_calculations.dart';

/// Container for computed user and friend balances.
class HomeBalancesResult {
  final double myUsd;
  final double myEgp;
  final double friendUsd;
  final double friendEgp;

  const HomeBalancesResult({
    required this.myUsd,
    required this.myEgp,
    required this.friendUsd,
    required this.friendEgp,
  });
}

/// Balance calculator helper for HomeFeedViewModel.
class HomeFeedBalanceCalculator {
  static HomeBalancesResult calculate({
    required String myUid,
    required String? myEmail,
    required bool isPrimaryUser,
    required InitialBalance? myInitialBalance,
    required InitialBalance? friendInitialBalance,
    required UserProfile? friendProfile,
    required String? friendEmail,
    required List<Expense> expenses,
    required List<Exchange> exchanges,
    required List<Borrow> borrows,
  }) {
    final myUsd = Calculations.calculateCashBalance(
      userId: myUid,
      currency: 'USD',
      initialBalance: myInitialBalance,
      exchanges: exchanges,
      expenses: expenses,
      borrows: borrows,
      userEmail: myEmail,
      isPrimaryUser: isPrimaryUser,
    );

    final myEgp = Calculations.calculateCashBalance(
      userId: myUid,
      currency: 'EGP',
      initialBalance: myInitialBalance,
      exchanges: exchanges,
      expenses: expenses,
      borrows: borrows,
      userEmail: myEmail,
      isPrimaryUser: isPrimaryUser,
    );

    final fId = friendProfile?.id ?? friendEmail?.toLowerCase().trim();
    if (fId == null) {
      return HomeBalancesResult(myUsd: myUsd, myEgp: myEgp, friendUsd: 0.0, friendEgp: 0.0);
    }

    final friendUsd = Calculations.calculateCashBalance(
      userId: fId,
      currency: 'USD',
      initialBalance: friendInitialBalance,
      exchanges: exchanges,
      expenses: expenses,
      borrows: borrows,
      userEmail: friendEmail ?? friendProfile?.email,
      isPrimaryUser: !isPrimaryUser,
    );

    final friendEgp = Calculations.calculateCashBalance(
      userId: fId,
      currency: 'EGP',
      initialBalance: friendInitialBalance,
      exchanges: exchanges,
      expenses: expenses,
      borrows: borrows,
      userEmail: friendEmail ?? friendProfile?.email,
      isPrimaryUser: !isPrimaryUser,
    );

    return HomeBalancesResult(myUsd: myUsd, myEgp: myEgp, friendUsd: friendUsd, friendEgp: friendEgp);
  }
}
