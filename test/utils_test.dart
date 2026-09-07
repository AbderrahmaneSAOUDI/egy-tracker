import 'package:flutter_test/flutter_test.dart';
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

      // EGP Balance: 2000 initial + 4800 exchange in - 200 expense paid = 6600 EGP
      final egpBalance = Calculations.calculateCashBalance(
        userId: 'userA',
        currency: 'EGP',
        initialBalance: initial,
        exchanges: exchanges,
        expenses: expenses,
      );
      expect(egpBalance, equals(6600.0));
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
