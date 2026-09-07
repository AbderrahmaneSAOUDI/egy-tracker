import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/models/mod_allowed_email.dart';
import 'package:egy_tracker/core/models/mod_exchange.dart';
import 'package:egy_tracker/core/models/mod_expense.dart';
import 'package:egy_tracker/core/models/mod_initial_balance.dart';
import 'package:egy_tracker/core/models/mod_user_profile.dart';

void main() {
  group('Domain Models Unit Tests', () {
    test('UserProfile serialization and deserialization', () {
      final now = DateTime.now();
      final profile = UserProfile(
        id: 'u1',
        name: 'Saoudi',
        email: 'Saoudi@Example.Com',
        photoUrl: 'https://example.com/photo.png',
        createdAt: now,
      );

      final map = profile.toMap();
      expect(map['email'], equals('saoudi@example.com')); // normalized

      final reconstructed = UserProfile.fromMap(map, 'u1');
      expect(reconstructed.id, equals('u1'));
      expect(reconstructed.name, equals('Saoudi'));
      expect(reconstructed.email, equals('saoudi@example.com'));
      expect(reconstructed.photoUrl, equals('https://example.com/photo.png'));
    });

    test('AllowedEmail normalizes email to lowercase and trims', () {
      final allowed = AllowedEmail(
        id: 'e1',
        email: '  Traveler@Domain.com ',
        createdAt: DateTime.now(),
      );

      final map = allowed.toMap();
      expect(map['email'], equals('traveler@domain.com'));

      final fromMap = AllowedEmail.fromMap(map, 'e1');
      expect(fromMap.email, equals('traveler@domain.com'));
    });

    test('Expense maintains currency and split invariant', () {
      final expense = Expense(
        id: 'exp1',
        title: 'Dinner at Nile',
        amount: 500.0,
        currency: 'EGP',
        paidBy: 'u1',
        splitType: 'fifty_fifty',
        mePercentage: 50.0,
        friendPercentage: 50.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      expect(expense.mePercentage + expense.friendPercentage, equals(100.0));
      expect(expense.currency, isIn(['USD', 'EGP']));

      final map = expense.toMap();
      final fromMap = Expense.fromMap(map, 'exp1');
      expect(fromMap.amount, equals(500.0));
      expect(fromMap.currency, equals('EGP'));
      expect(fromMap.splitType, equals('fifty_fifty'));
    });

    test('Exchange model records currency transfer correctly', () {
      final exchange = Exchange(
        id: 'xch1',
        userId: 'u1',
        fromCurrency: 'USD',
        fromAmount: 100.0,
        toCurrency: 'EGP',
        toAmount: 4850.0,
        exchangeRate: 48.5,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      expect(exchange.fromCurrency, equals('USD'));
      expect(exchange.toCurrency, equals('EGP'));
      expect(exchange.exchangeRate, equals(48.5));

      final map = exchange.toMap();
      final fromMap = Exchange.fromMap(map, 'xch1');
      expect(fromMap.fromAmount, equals(100.0));
      expect(fromMap.toAmount, equals(4850.0));
    });

    test('InitialBalance stores distinct USD and EGP balances', () {
      final balance = InitialBalance(
        userId: 'u1',
        usdAmount: 350.0,
        egpAmount: 5000.0,
        updatedAt: DateTime.now(),
      );

      final map = balance.toMap();
      final fromMap = InitialBalance.fromMap(map, 'u1');
      expect(fromMap.usdAmount, equals(350.0));
      expect(fromMap.egpAmount, equals(5000.0));
    });
  });
}
