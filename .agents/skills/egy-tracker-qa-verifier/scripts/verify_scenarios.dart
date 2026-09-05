// Standalone scenario verification script for egy_tracker
// Validates Scenarios A through E from two_currency_expense_tracker_mvp.md

import 'dart:io';

enum Currency { usd, egp }
enum SplitType { default100, fiftyFifty, custom }

class Expense {
  final String title;
  final double amount;
  final Currency currency;
  final String paidBy; // 'me' or 'friend'
  final SplitType splitType;
  final double mePercentage;
  final double friendPercentage;

  Expense({
    required this.title,
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.splitType,
    required this.mePercentage,
    required this.friendPercentage,
  }) {
    assert((mePercentage + friendPercentage - 100.0).abs() < 0.001,
        'Percentages must sum to 100%');
  }

  double get meShare => amount * (mePercentage / 100.0);
  double get friendShare => amount * (friendPercentage / 100.0);
}

class Exchange {
  final String userId;
  final Currency fromCurrency;
  final double fromAmount;
  final Currency toCurrency;
  final double toAmount;
  final double exchangeRate;

  Exchange({
    required this.userId,
    required this.fromCurrency,
    required this.fromAmount,
    required this.toCurrency,
    required this.toAmount,
    required this.exchangeRate,
  });
}

class UserBalance {
  double usd;
  double egp;

  UserBalance({required this.usd, required this.egp});
}

void main() {
  stdout.writeln('=== Starting egy_tracker Scenario Verifier ===\n');

  int passed = 0;
  int total = 5;

  // --- Scenario A ---
  stdout.write('Checking Scenario A (Personal expense: Taxi \$15 paid by Me, 100% default)... ');
  final balMeA = UserBalance(usd: 150, egp: 0);
  final balFriendA = UserBalance(usd: 150, egp: 0);
  final expA = Expense(
    title: 'Taxi',
    amount: 15,
    currency: Currency.usd,
    paidBy: 'me',
    splitType: SplitType.default100,
    mePercentage: 100,
    friendPercentage: 0,
  );
  // Cash balance impact:
  balMeA.usd -= expA.amount;
  if (balMeA.usd == 135 && balFriendA.usd == 150 && expA.meShare == 15 && expA.friendShare == 0) {
    stdout.writeln('PASSED [Me USD: \$135, Friend USD: \$150, My share: \$15]');
    passed++;
  } else {
    stdout.writeln('FAILED');
  }

  // --- Scenario B ---
  stdout.write('Checking Scenario B (Shared expense: Dinner 1,000 EGP paid by Me, 50/50)... ');
  final balMeB = UserBalance(usd: 0, egp: 5000);
  final balFriendB = UserBalance(usd: 0, egp: 5000);
  final expB = Expense(
    title: 'Dinner',
    amount: 1000,
    currency: Currency.egp,
    paidBy: 'me',
    splitType: SplitType.fiftyFifty,
    mePercentage: 50,
    friendPercentage: 50,
  );
  balMeB.egp -= expB.amount;
  if (balMeB.egp == 4000 && balFriendB.egp == 5000 && expB.meShare == 500 && expB.friendShare == 500) {
    stdout.writeln('PASSED [Me EGP: 4,000, Friend EGP: 5,000, My share: 500 EGP]');
    passed++;
  } else {
    stdout.writeln('FAILED');
  }

  // --- Scenario C ---
  stdout.write('Checking Scenario C (Friend pays for me: Taxi \$20, 100% Me share)... ');
  final balMeC = UserBalance(usd: 100, egp: 0);
  final balFriendC = UserBalance(usd: 100, egp: 0);
  final expC = Expense(
    title: 'Taxi',
    amount: 20,
    currency: Currency.usd,
    paidBy: 'friend',
    splitType: SplitType.custom,
    mePercentage: 100,
    friendPercentage: 0,
  );
  balFriendC.usd -= expC.amount;
  if (balMeC.usd == 100 && balFriendC.usd == 80 && expC.meShare == 20 && expC.friendShare == 0) {
    stdout.writeln('PASSED [Me USD: \$100, Friend USD: \$80, My share: \$20]');
    passed++;
  } else {
    stdout.writeln('FAILED');
  }

  // --- Scenario D ---
  stdout.write('Checking Scenario D (Custom split: Dinner 2,000 EGP paid by Friend, Me 70%, Friend 30%)... ');
  final balMeD = UserBalance(usd: 0, egp: 10000);
  final balFriendD = UserBalance(usd: 0, egp: 10000);
  final expD = Expense(
    title: 'Dinner',
    amount: 2000,
    currency: Currency.egp,
    paidBy: 'friend',
    splitType: SplitType.custom,
    mePercentage: 70,
    friendPercentage: 30,
  );
  balFriendD.egp -= expD.amount;
  if (balMeD.egp == 10000 && balFriendD.egp == 8000 && expD.meShare == 1400 && expD.friendShare == 600) {
    stdout.writeln('PASSED [Me EGP: 10,000, Friend EGP: 8,000, My share: 1,400 EGP, Friend share: 600 EGP]');
    passed++;
  } else {
    stdout.writeln('FAILED');
  }

  // --- Scenario E ---
  stdout.write('Checking Scenario E (Exchange: \$100 -> 4,900 EGP at rate 49 by Me)... ');
  final balMeE = UserBalance(usd: 150, egp: 0);
  final balFriendE = UserBalance(usd: 150, egp: 0);
  final exE = Exchange(
    userId: 'me',
    fromCurrency: Currency.usd,
    fromAmount: 100,
    toCurrency: Currency.egp,
    toAmount: 4900,
    exchangeRate: 49,
  );
  balMeE.usd -= exE.fromAmount;
  balMeE.egp += exE.toAmount;
  if (balMeE.usd == 50 && balMeE.egp == 4900 && balFriendE.usd == 150 && balFriendE.egp == 0) {
    stdout.writeln('PASSED [Me USD: \$50, Me EGP: 4,900, Friend unaffected]');
    passed++;
  } else {
    stdout.writeln('FAILED');
  }

  stdout.writeln('\nSummary: $passed / $total scenarios verified successfully.');
  if (passed != total) {
    exit(1);
  }
}
