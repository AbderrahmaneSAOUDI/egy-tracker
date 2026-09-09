import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/models/mod_allowed_email.dart';
import 'package:egy_tracker/core/models/mod_borrow.dart';
import 'package:egy_tracker/core/models/mod_exchange.dart';
import 'package:egy_tracker/core/models/mod_expense.dart';
import 'package:egy_tracker/core/models/mod_initial_balance.dart';
import 'package:egy_tracker/core/models/mod_user_profile.dart';
import 'package:egy_tracker/core/services/f_auth.dart';
import 'package:egy_tracker/core/services/f_firestore.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';
import 'package:egy_tracker/features/home/components/c_activity_tile.dart';
import 'package:egy_tracker/features/home/models/mod_activity_item.dart';
import 'package:egy_tracker/features/home/s_home_tab.dart';
import 'package:egy_tracker/features/home/vm_home_feed.dart';

class MockFirestoreService extends FirestoreService {
  final StreamController<List<Expense>> expensesController =
      StreamController<List<Expense>>.broadcast();
  final StreamController<List<Exchange>> exchangesController =
      StreamController<List<Exchange>>.broadcast();
  final StreamController<List<Borrow>> borrowsController =
      StreamController<List<Borrow>>.broadcast();
  final StreamController<List<InitialBalance>> balancesController =
      StreamController<List<InitialBalance>>.broadcast();
  final StreamController<List<UserProfile>> usersController =
      StreamController<List<UserProfile>>.broadcast();
  final StreamController<List<AllowedEmail>> emailsController =
      StreamController<List<AllowedEmail>>.broadcast();

  final List<Expense> addedExpenses = [];
  final List<Exchange> addedExchanges = [];
  final List<Borrow> addedBorrows = [];
  final List<String> deletedExpenseIds = [];
  final List<String> deletedExchangeIds = [];
  final List<String> deletedBorrowIds = [];

  @override
  Stream<List<Expense>> getExpensesStream() => expensesController.stream;

  @override
  Stream<List<Exchange>> getExchangesStream() => exchangesController.stream;

  @override
  Stream<List<Borrow>> getBorrowsStream() => borrowsController.stream;

  @override
  Stream<List<InitialBalance>> getInitialBalancesStream() =>
      balancesController.stream;

  @override
  Stream<List<UserProfile>> getUsersStream() => usersController.stream;

  @override
  Stream<List<AllowedEmail>> getAllowedEmailsStream() => emailsController.stream;

  @override
  Future<void> addExpense(Expense expense) async {
    addedExpenses.add(expense);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    deletedExpenseIds.add(expenseId);
  }

  @override
  Future<void> addExchange(Exchange exchange) async {
    addedExchanges.add(exchange);
  }

  @override
  Future<void> deleteExchange(String exchangeId) async {
    deletedExchangeIds.add(exchangeId);
  }

  @override
  Future<void> addBorrow(Borrow borrow) async {
    addedBorrows.add(borrow);
  }

  @override
  Future<void> deleteBorrow(String borrowId) async {
    deletedBorrowIds.add(borrowId);
  }

  void dispose() {
    expensesController.close();
    exchangesController.close();
    borrowsController.close();
    balancesController.close();
    usersController.close();
    emailsController.close();
  }
}

void main() {
  group('ActivityItem Unit Tests', () {
    test('ActivityItem wraps Expense, Exchange, and Borrow accurately', () {
      final now = DateTime.now();
      final exp = Expense(
        id: 'exp_1',
        title: 'Taxi',
        amount: 150.0,
        currency: 'EGP',
        paidBy: 'user_1',
        splitType: 'default_100',
        mePercentage: 100,
        friendPercentage: 0,
        date: now,
        createdAt: now,
      );
      final exc = Exchange(
        id: 'exc_1',
        userId: 'user_1',
        fromCurrency: 'USD',
        fromAmount: 100.0,
        toCurrency: 'EGP',
        toAmount: 4900.0,
        exchangeRate: 49.0,
        date: now,
        createdAt: now,
      );
      final bor = Borrow(
        id: 'bor_1',
        borrowerId: 'user_1',
        lenderId: 'user_2',
        usdAmount: 50.0,
        egpAmount: 1000.0,
        date: now,
        createdAt: now,
      );

      final itemExp = ActivityItem.expense(exp);
      expect(itemExp.isExpense, isTrue);
      expect(itemExp.isExchange, isFalse);
      expect(itemExp.isBorrow, isFalse);
      expect(itemExp.id, 'exp_1');
      expect(itemExp.expense?.title, 'Taxi');

      final itemExc = ActivityItem.exchange(exc);
      expect(itemExc.isExpense, isFalse);
      expect(itemExc.isExchange, isTrue);
      expect(itemExc.isBorrow, isFalse);
      expect(itemExc.id, 'exc_1');
      expect(itemExc.exchange?.exchangeRate, 49.0);

      final itemBor = ActivityItem.borrow(bor);
      expect(itemBor.isExpense, isFalse);
      expect(itemBor.isExchange, isFalse);
      expect(itemBor.isBorrow, isTrue);
      expect(itemBor.id, 'bor_1');
      expect(itemBor.borrow?.usdAmount, 50.0);
      expect(itemBor.borrow?.egpAmount, 1000.0);
    });
  });

  group('HomeFeedViewModel Calculations', () {
    late MockFirestoreService firestore;
    late DevUser devUser;
    late HomeFeedViewModel vm;
    const myId = 'user_me';
    const friendId = 'user_friend';

    setUp(() {
      firestore = MockFirestoreService();
      devUser = DevUser(
        uid: myId,
        email: 'me@test.com',
        displayName: 'Me',
      );
      vm = HomeFeedViewModel(
        user: devUser,
        firestoreService: firestore,
      );
    });

    tearDown(() {
      vm.dispose();
      firestore.dispose();
    });

    test('Computes independent cash balances correctly with initial balances, exchanges, and expenses', () async {
      final now = DateTime.now();

      // Emit allowed emails to establish Friend
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'me@test.com', createdAt: now),
        AllowedEmail(id: '2', email: 'friend@test.com', createdAt: now),
      ]);
      firestore.usersController.add([
        UserProfile(id: myId, email: 'me@test.com', name: 'Me', createdAt: now),
        UserProfile(id: friendId, email: 'friend@test.com', name: 'Friend', createdAt: now),
      ]);

      // 1. Initial balances
      firestore.balancesController.add([
        InitialBalance(
          userId: myId,
          usdAmount: 500.0,
          egpAmount: 0.0,
          updatedAt: now,
        ),
        InitialBalance(
          userId: friendId,
          usdAmount: 300.0,
          egpAmount: 1000.0,
          updatedAt: now,
        ),
      ]);

      // 2. Exchange: me exchanges $100 -> 4,900 EGP
      firestore.exchangesController.add([
        Exchange(
          id: 'exc_1',
          userId: myId,
          fromCurrency: 'USD',
          fromAmount: 100.0,
          toCurrency: 'EGP',
          toAmount: 4900.0,
          exchangeRate: 49.0,
          date: now,
          createdAt: now,
        ),
      ]);

      // 3. Expense: me pays 900 EGP for museum
      firestore.expensesController.add([
        Expense(
          id: 'exp_1',
          title: 'Museum tickets',
          amount: 900.0,
          currency: 'EGP',
          paidBy: myId,
          splitType: 'fifty_fifty',
          mePercentage: 50,
          friendPercentage: 50,
          date: now,
          createdAt: now,
        ),
      ]);

      // 4. Borrow: me borrows $50 and 500 EGP from friend
      firestore.borrowsController.add([
        Borrow(
          id: 'bor_1',
          borrowerId: myId,
          lenderId: friendId,
          usdAmount: 50.0,
          egpAmount: 500.0,
          date: now,
          createdAt: now,
        ),
      ]);

      await pumpEventQueue();

      // Cash Balance formula: Initial + ExchangesIn - ExchangesOut - ExpensesPaid + BorrowsIn - BorrowsOut
      // Me USD: 500 - 100 (exchange out) + 50 (borrow in) = 450.0
      // Me EGP: 0 + 4900 (exchange in) - 900 (expense paid) + 500 (borrow in) = 4500.0
      expect(vm.myUsdBalance, 450.0);
      expect(vm.myEgpBalance, 4500.0);

      // Friend USD: 300.0 - 50 (borrow out) = 250.0
      // Friend EGP: 1000.0 - 500 (borrow out) = 500.0
      expect(vm.friendUsdBalance, 250.0);
      expect(vm.friendEgpBalance, 500.0);
    });
  });

  group('HomeTabScreen Widget Tests', () {
    late MockFirestoreService firestore;
    late DevUser devUser;
    late HomeFeedViewModel vm;
    const myId = 'user_me';

    setUp(() {
      firestore = MockFirestoreService();
      devUser = DevUser(
        uid: myId,
        email: 'saoudi@example.com',
        displayName: 'Saoudi',
      );
      vm = HomeFeedViewModel(
        user: devUser,
        firestoreService: firestore,
      );
    });

    tearDown(() {
      vm.dispose();
      firestore.dispose();
    });

    testWidgets('Renders balances and empty state when activity is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HomeTabScreen(
              user: devUser,
              viewModel: vm,
            ),
          ),
        ),
      );

      final now = DateTime.now();
      // Emit empty activity and some balances
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'saoudi@example.com', createdAt: now),
        AllowedEmail(id: '2', email: 'friend@example.com', createdAt: now),
      ]);
      firestore.usersController.add([
        UserProfile(id: myId, email: 'saoudi@example.com', name: 'Saoudi', createdAt: now),
        UserProfile(id: 'user_friend', email: 'friend@example.com', name: 'Friend', createdAt: now),
      ]);
      firestore.balancesController.add([
        InitialBalance(
          userId: myId,
          usdAmount: 150.0,
          egpAmount: 2000.0,
          updatedAt: now,
        ),
      ]);
      firestore.expensesController.add([]);
      firestore.exchangesController.add([]);
      firestore.borrowsController.add([]);

      await tester.pump();

      // Balances card should be present
      expect(find.text('You'), findsWidgets);
      expect(find.text('Friend'), findsWidgets);
      expect(find.text('\$150.00'), findsOneWidget);
      expect(find.text('2,000.00 EGP'), findsOneWidget);

      // Empty state text
      expect(find.text('No activity yet'), findsOneWidget);
    });

    testWidgets('Renders activity tiles when expenses and exchanges are present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HomeTabScreen(
              user: devUser,
              viewModel: vm,
            ),
          ),
        ),
      );

      final now = DateTime.now();
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'saoudi@example.com', createdAt: now),
      ]);
      firestore.balancesController.add([]);
      firestore.expensesController.add([
        Expense(
          id: 'exp_pyramid',
          title: 'Pyramids Tour',
          amount: 60.0,
          currency: 'USD',
          paidBy: myId,
          splitType: 'fifty_fifty',
          mePercentage: 50,
          friendPercentage: 50,
          date: now,
          createdAt: now,
        ),
      ]);
      firestore.exchangesController.add([]);
      firestore.borrowsController.add([]);

      await tester.pump();

      expect(find.text('Pyramids Tour'), findsOneWidget);
      expect(find.text('-\$60.00'), findsOneWidget);
      expect(find.text('Paid by You · 50/50'), findsOneWidget);
    });

    testWidgets('Renders borrow activity tile in feed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HomeTabScreen(
              user: devUser,
              viewModel: vm,
            ),
          ),
        ),
      );

      final now = DateTime.now();
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'saoudi@example.com', createdAt: now),
        AllowedEmail(id: '2', email: 'friend@example.com', createdAt: now),
      ]);
      firestore.usersController.add([
        UserProfile(id: myId, email: 'saoudi@example.com', name: 'Saoudi', createdAt: now),
        UserProfile(id: 'user_friend', email: 'friend@example.com', name: 'Friend', createdAt: now),
      ]);
      firestore.balancesController.add([]);
      firestore.expensesController.add([]);
      firestore.exchangesController.add([]);
      firestore.borrowsController.add([
        Borrow(
          id: 'bor_1',
          borrowerId: myId,
          lenderId: 'user_friend',
          usdAmount: 50.0,
          egpAmount: 1000.0,
          date: now,
          createdAt: now,
        ),
      ]);

      await tester.pump();

      expect(find.text('Borrowed from Friend'), findsOneWidget);
      expect(find.text('\$50.00 · 1,000.00 EGP'), findsOneWidget);
    });

    testWidgets('Scenario C — Renders "Paid by Friend · 100% You" when friend pays for me', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HomeTabScreen(
              user: devUser,
              viewModel: vm,
            ),
          ),
        ),
      );

      final now = DateTime.now();
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'saoudi@example.com', createdAt: now),
        AllowedEmail(id: '2', email: 'friend@example.com', createdAt: now),
      ]);
      firestore.usersController.add([
        UserProfile(id: myId, email: 'saoudi@example.com', name: 'Saoudi', createdAt: now),
        UserProfile(id: 'user_friend', email: 'friend@example.com', name: 'Friend', createdAt: now),
      ]);
      firestore.balancesController.add([]);
      firestore.expensesController.add([
        Expense(
          id: 'exp_taxi',
          title: 'Taxi to Airport',
          amount: 20.0,
          currency: 'USD',
          paidBy: 'user_friend',
          splitType: 'default_100',
          mePercentage: 100.0,
          friendPercentage: 0.0,
          date: now,
          createdAt: now,
        ),
      ]);
      firestore.exchangesController.add([]);
      firestore.borrowsController.add([]);

      await tester.pump();

      expect(find.text('Taxi to Airport'), findsOneWidget);
      expect(find.text('Paid by Friend · 100% You'), findsOneWidget);
      // Activity count badge
      expect(find.text('1'), findsOneWidget);
      // ActivityTile gesture item is present
      expect(find.byType(ActivityTile), findsOneWidget);
    });

    testWidgets('Sliding right on activity tile triggers update and opens edit dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HomeTabScreen(
              user: devUser,
              viewModel: vm,
            ),
          ),
        ),
      );

      final now = DateTime.now();
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'saoudi@example.com', createdAt: now),
      ]);
      firestore.balancesController.add([]);
      firestore.expensesController.add([
        Expense(
          id: 'exp_lunch',
          title: 'Shawarma Lunch',
          amount: 200.0,
          currency: 'EGP',
          paidBy: myId,
          splitType: 'fifty_fifty',
          mePercentage: 50.0,
          friendPercentage: 50.0,
          date: now,
          createdAt: now,
        ),
      ]);
      firestore.exchangesController.add([]);
      firestore.borrowsController.add([]);

      await tester.pump();

      // Slide right (start to end) past threshold -> triggers update
      await tester.fling(find.text('Shawarma Lunch'), const Offset(500, 0), 1000);
      await tester.pumpAndSettle();

      // Edit Expense dialog should open with title pre-filled
      expect(find.text('Edit Expense'), findsWidgets);
      expect(find.text('Shawarma Lunch'), findsWidgets);
    });

    testWidgets('Sliding left on activity tile triggers remove and opens confirmation dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HomeTabScreen(
              user: devUser,
              viewModel: vm,
            ),
          ),
        ),
      );

      final now = DateTime.now();
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'saoudi@example.com', createdAt: now),
      ]);
      firestore.balancesController.add([]);
      firestore.expensesController.add([
        Expense(
          id: 'exp_dinner',
          title: 'Koshary Dinner',
          amount: 120.0,
          currency: 'EGP',
          paidBy: myId,
          splitType: 'fifty_fifty',
          mePercentage: 50.0,
          friendPercentage: 50.0,
          date: now,
          createdAt: now,
        ),
      ]);
      firestore.exchangesController.add([]);
      firestore.borrowsController.add([]);

      await tester.pump();

      // Slide left (end to start) past threshold -> triggers remove confirmation
      await tester.fling(find.text('Koshary Dinner'), const Offset(-500, 0), 1000);
      await tester.pumpAndSettle();

      // Delete confirmation dialog should open
      expect(find.text('Delete Expense'), findsWidgets);
      expect(find.text('Delete'), findsWidgets);
      expect(find.text('Cancel'), findsWidgets);
    });

    testWidgets('Tapping activity tile directly opens edit dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HomeTabScreen(
              user: devUser,
              viewModel: vm,
            ),
          ),
        ),
      );

      final now = DateTime.now();
      firestore.emailsController.add([
        AllowedEmail(id: '1', email: 'saoudi@example.com', createdAt: now),
      ]);
      firestore.balancesController.add([]);
      firestore.expensesController.add([
        Expense(
          id: 'exp_tea',
          title: 'Mint Tea',
          amount: 40.0,
          currency: 'EGP',
          paidBy: myId,
          splitType: 'fifty_fifty',
          mePercentage: 50.0,
          friendPercentage: 50.0,
          date: now,
          createdAt: now,
        ),
      ]);
      firestore.exchangesController.add([]);
      firestore.borrowsController.add([]);

      await tester.pump();

      // Tap the tile
      await tester.tap(find.text('Mint Tea'));
      await tester.pumpAndSettle();

      // Edit Expense dialog should open
      expect(find.text('Edit Expense'), findsWidgets);
      expect(find.text('Mint Tea'), findsWidgets);
    });
  });
}
