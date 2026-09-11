import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/models/mod_borrow.dart';
import 'package:egy_tracker/core/models/mod_exchange.dart';
import 'package:egy_tracker/core/models/mod_expense.dart';
import 'package:egy_tracker/core/models/mod_initial_balance.dart';
import 'package:egy_tracker/core/services/f_auth.dart';
import 'package:egy_tracker/core/utils/m_auth_helpers.dart';
import 'package:egy_tracker/core/utils/m_calculations.dart';
import 'package:egy_tracker/core/utils/m_formatters.dart';
import 'package:egy_tracker/core/utils/m_validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail checks standard email patterns', () {
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('user@domain.com'), isNull);
    });

    test('normalizeEmail appends @gmail.com when omitted', () {
      expect(Validators.normalizeEmail(null), '');
      expect(Validators.normalizeEmail(''), '');
      expect(Validators.normalizeEmail('partner'), 'partner@gmail.com');
      expect(Validators.normalizeEmail('partner@gmail.com'), 'partner@gmail.com');
      expect(Validators.normalizeEmail('partner@yahoo.com'), 'partner@yahoo.com');
    });

    test('validateEmail with allowUsernameOnly permits username-only input', () {
      expect(Validators.validateEmail('partner', allowUsernameOnly: true), isNull);
      expect(Validators.validateEmail('partner with space', allowUsernameOnly: true), isNotNull);
      expect(Validators.validateEmail('partner@example.com', allowUsernameOnly: true), isNull);
    });

    test('validateNonNegativeAmount enforces valid positive numbers', () {
      expect(Validators.validateNonNegativeAmount(null, 'USD'), isNotNull);
      expect(Validators.validateNonNegativeAmount('abc', 'USD'), isNotNull);
      expect(Validators.validateNonNegativeAmount('-10', 'USD'), isNotNull);
      expect(Validators.validateNonNegativeAmount('0', 'USD'), isNull);
      expect(Validators.validateNonNegativeAmount('150.50', 'USD'), isNull);
    });
  });

  group('Formatters Unit Tests', () {
    test('formatUsd and formatEgp correctly display currency', () {
      expect(Formatters.formatUsd(100), equals('\$100.00'));
      expect(Formatters.formatUsd(1234.56), equals('\$1,234.56'));
      expect(Formatters.formatUsd(-50), equals('-\$50.00'));

      expect(Formatters.formatEgp(2500), equals('2,500.00 EGP'));
      expect(Formatters.formatCurrency(500, 'USD'), equals('\$500.00'));
      expect(Formatters.formatCurrency(500, 'EGP'), equals('500.00 EGP'));
    });
  });

  group('Calculations Two-Currency Invariant Tests', () {
    test('calculateCashBalance strictly follows MVP cash balance formula', () {
      final initial = InitialBalance(
        userId: 'userA',
        usdAmount: 500.0,
        egpAmount: 2000.0,
        updatedAt: DateTime.now(),
      );

      final exchanges = [
        Exchange(
          id: 'ex1',
          userId: 'userA',
          fromCurrency: 'USD',
          fromAmount: 100.0,
          toCurrency: 'EGP',
          toAmount: 4800.0,
          exchangeRate: 48.0,
          date: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      ];

      final expenses = [
        Expense(
          id: 'exp1',
          title: 'Taxi',
          amount: 200.0,
          currency: 'EGP',
          paidBy: 'userA',
          splitType: 'fifty_fifty',
          mePercentage: 50.0,
          friendPercentage: 50.0,
          date: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      ];

      // USD Balance: 500 initial - 100 exchange out = 400 USD
      final usdBalance = Calculations.calculateCashBalance(
        userId: 'userA',
        currency: 'USD',
        initialBalance: initial,
        exchanges: exchanges,
        expenses: expenses,
      );
      expect(usdBalance, equals(400.0));

      // EGP Balance: 2000 initial + 4800 exchange in - 100 (50% split share) = 6700 EGP
      final egpBalance = Calculations.calculateCashBalance(
        userId: 'userA',
        currency: 'EGP',
        initialBalance: initial,
        exchanges: exchanges,
        expenses: expenses,
      );
      expect(egpBalance, equals(6700.0));

      // UserB EGP Balance: 500 initial - 100 (50% split share) = 400 EGP
      final userBInitial = InitialBalance(
        userId: 'userB',
        usdAmount: 100.0,
        egpAmount: 500.0,
        updatedAt: DateTime.now(),
      );
      final userBEgpBalance = Calculations.calculateCashBalance(
        userId: 'userB',
        currency: 'EGP',
        initialBalance: userBInitial,
        exchanges: const [],
        expenses: expenses,
      );
      expect(userBEgpBalance, equals(400.0));
    });

    test('calculateCashBalance correctly adjusts balances for borrows and handles email aliases', () {
      final initial = InitialBalance(
        userId: 'user_me_uid',
        usdAmount: 100.0,
        egpAmount: 1000.0,
        updatedAt: DateTime.now(),
      );

      final borrows = [
        // Borrowed $50 USD from friend (stored with friend's email before profile creation)
        Borrow(
          id: 'b1',
          borrowerId: 'user_me_uid',
          lenderId: 'friend@example.com',
          usdAmount: 50.0,
          egpAmount: 0.0,
          date: DateTime.now(),
          createdAt: DateTime.now(),
        ),
        // Lent 300 EGP to friend (stored with my email)
        Borrow(
          id: 'b2',
          borrowerId: 'friend_uid',
          lenderId: 'me@example.com',
          usdAmount: 0.0,
          egpAmount: 300.0,
          date: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      ];

      // My balance:
      // USD: 100 + 50 (borrowed in) = 150
      final myUsd = Calculations.calculateCashBalance(
        userId: 'user_me_uid',
        currency: 'USD',
        initialBalance: initial,
        exchanges: const [],
        expenses: const [],
        borrows: borrows,
        userEmail: 'me@example.com',
      );
      expect(myUsd, equals(150.0));

      // EGP: 1000 - 300 (lent out, matching by email alias) = 700
      final myEgp = Calculations.calculateCashBalance(
        userId: 'user_me_uid',
        currency: 'EGP',
        initialBalance: initial,
        exchanges: const [],
        expenses: const [],
        borrows: borrows,
        userEmail: 'me@example.com',
      );
      expect(myEgp, equals(700.0));

      // Friend's balance:
      // Friend initial: USD 200, EGP 500
      final friendInitial = InitialBalance(
        userId: 'friend_uid',
        usdAmount: 200.0,
        egpAmount: 500.0,
        updatedAt: DateTime.now(),
      );

      // Friend USD: 200 - 50 (lent out, matching by email alias) = 150
      final friendUsd = Calculations.calculateCashBalance(
        userId: 'friend_uid',
        currency: 'USD',
        initialBalance: friendInitial,
        exchanges: const [],
        expenses: const [],
        borrows: borrows,
        userEmail: 'friend@example.com',
      );
      expect(friendUsd, equals(150.0));

      // Friend EGP: 500 + 300 (borrowed in, matching by friend_uid) = 800
      final friendEgp = Calculations.calculateCashBalance(
        userId: 'friend_uid',
        currency: 'EGP',
        initialBalance: friendInitial,
        exchanges: const [],
        expenses: const [],
        borrows: borrows,
        userEmail: 'friend@example.com',
      );
      expect(friendEgp, equals(800.0));
    });

    test('Personal share calculates percentage properly', () {
      final share50 = Calculations.calculatePersonalShare(
        amount: 300.0,
        userPercentage: 50.0,
      );
      expect(share50, equals(150.0));

      final share100 = Calculations.calculatePersonalShare(
        amount: 80.0,
        userPercentage: 100.0,
      );
      expect(share100, equals(80.0));
    });

    test('MVP Scenarios A through D User Percentage & Share calculations', () {
      // Scenario A — Personal expense: Taxi $15, Paid by Me, Split 100%
      final expA = Expense(
        id: 'a',
        title: 'Taxi',
        amount: 15.0,
        currency: 'USD',
        paidBy: 'user_me',
        splitType: 'default_100',
        mePercentage: 100.0,
        friendPercentage: 0.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      expect(Calculations.getUserPercentage(expense: expA, isPrimaryUser: true), equals(100.0));
      expect(Calculations.calculateUserExpenseShare(expense: expA, isPrimaryUser: true), equals(15.0));
      expect(Calculations.getUserPercentage(expense: expA, isPrimaryUser: false), equals(0.0));
      expect(Calculations.calculateUserExpenseShare(expense: expA, isPrimaryUser: false), equals(0.0));

      // Scenario B — Shared expense: Dinner 1,000 EGP, Paid by Me, Split 50/50
      final expB = Expense(
        id: 'b',
        title: 'Dinner',
        amount: 1000.0,
        currency: 'EGP',
        paidBy: 'user_me',
        splitType: 'fifty_fifty',
        mePercentage: 50.0,
        friendPercentage: 50.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      expect(Calculations.getUserPercentage(expense: expB, isPrimaryUser: true), equals(50.0));
      expect(Calculations.calculateUserExpenseShare(expense: expB, isPrimaryUser: true), equals(500.0));
      expect(Calculations.getUserPercentage(expense: expB, isPrimaryUser: false), equals(50.0));
      expect(Calculations.calculateUserExpenseShare(expense: expB, isPrimaryUser: false), equals(500.0));

      // Scenario C — Friend pays for me: Taxi $20, Paid by Friend, Split 100% Me
      final expC = Expense(
        id: 'c',
        title: 'Taxi',
        amount: 20.0,
        currency: 'USD',
        paidBy: 'user_friend',
        splitType: 'custom',
        mePercentage: 100.0,
        friendPercentage: 0.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      expect(Calculations.getUserPercentage(expense: expC, isPrimaryUser: true), equals(100.0));
      expect(Calculations.calculateUserExpenseShare(expense: expC, isPrimaryUser: true), equals(20.0));
      expect(Calculations.getUserPercentage(expense: expC, isPrimaryUser: false), equals(0.0));
      expect(Calculations.calculateUserExpenseShare(expense: expC, isPrimaryUser: false), equals(0.0));

      // Scenario D — Custom split: Dinner 2,000 EGP, Paid by Friend, Split Me 70%, Friend 30%
      final expD = Expense(
        id: 'd',
        title: 'Dinner',
        amount: 2000.0,
        currency: 'EGP',
        paidBy: 'user_friend',
        splitType: 'custom',
        mePercentage: 70.0,
        friendPercentage: 30.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      expect(Calculations.getUserPercentage(expense: expD, isPrimaryUser: true), equals(70.0));
      expect(Calculations.calculateUserExpenseShare(expense: expD, isPrimaryUser: true), equals(1400.0));
      expect(Calculations.getUserPercentage(expense: expD, isPrimaryUser: false), equals(30.0));
      expect(Calculations.calculateUserExpenseShare(expense: expD, isPrimaryUser: false), equals(600.0));

      // Scenario E — Exchange: Cairo airport USD 200 -> EGP 10,000, rate 50.0
      final exchangeE = Exchange(
        id: 'e',
        userId: 'user_me',
        fromCurrency: 'USD',
        fromAmount: 200.0,
        toCurrency: 'EGP',
        toAmount: 10000.0,
        exchangeRate: 50.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );
      final now = DateTime.now();
      final usdBalAfterExchange = Calculations.calculateCashBalance(
        userId: 'user_me',
        currency: 'USD',
        initialBalance: InitialBalance(userId: 'user_me', usdAmount: 500.0, egpAmount: 0.0, updatedAt: now),
        exchanges: [exchangeE],
        expenses: [],
      );
      final egpBalAfterExchange = Calculations.calculateCashBalance(
        userId: 'user_me',
        currency: 'EGP',
        initialBalance: InitialBalance(userId: 'user_me', usdAmount: 500.0, egpAmount: 0.0, updatedAt: now),
        exchanges: [exchangeE],
        expenses: [],
      );
      // USD decreases by 200 (500 - 200 = 300)
      expect(usdBalAfterExchange, equals(300.0));
      // EGP increases by 10,000 (0 + 10,000 = 10,000)
      expect(egpBalAfterExchange, equals(10000.0));
    });
  });

  group('Auth Helpers Unit Tests', () {
    test('resolveUserPhoto returns photoURL when present', () {
      final user = DevUser(
        photoURL: 'https://lh3.googleusercontent.com/photo.jpg',
      );
      expect(
        resolveUserPhoto(user),
        equals('https://lh3.googleusercontent.com/photo.jpg'),
      );
    });

    test('resolveUserPhoto uses fallbackUrl when user photoURL is null', () {
      final user = DevUser(photoURL: null);
      expect(
        resolveUserPhoto(user, 'https://firestore.profile/photo.jpg'),
        equals('https://firestore.profile/photo.jpg'),
      );
    });

    test('resolveUserPhoto returns null when neither user nor fallback has photo', () {
      final user = DevUser(photoURL: null);
      expect(resolveUserPhoto(user), isNull);
      expect(resolveUserPhoto(null), isNull);
    });

    test('resolveUserName returns displayName when present', () {
      final user = DevUser(displayName: 'Test Traveler');
      expect(resolveUserName(user), equals('Test Traveler'));
    });

    test('resolveUserName falls back to email prefix when displayName is null', () {
      final user = DevUser(
        displayName: null,
        email: 'alice@example.com',
      );
      expect(resolveUserName(user), equals('alice'));
    });

    test('resolveUserName defaults to Traveler when everything is null', () {
      final user = DevUser(
        displayName: null,
        email: null,
      );
      expect(resolveUserName(user), equals('Traveler'));
      expect(resolveUserName(null), equals('Traveler'));
    });
  });
}
