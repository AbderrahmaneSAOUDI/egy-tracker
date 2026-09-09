import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/components/c_activity_tile.dart';
import 'package:egy_tracker/core/components/c_empty_state.dart';
import 'package:egy_tracker/core/components/c_segmented_pill_bar.dart';
import 'package:egy_tracker/core/components/c_traveler_balance_card.dart';
import 'package:egy_tracker/core/models/mod_allowed_email.dart';
import 'package:egy_tracker/core/models/mod_borrow.dart';
import 'package:egy_tracker/core/models/mod_exchange.dart';
import 'package:egy_tracker/core/models/mod_expense.dart';
import 'package:egy_tracker/core/models/mod_initial_balance.dart';
import 'package:egy_tracker/core/models/mod_user_profile.dart';
import 'package:egy_tracker/core/services/f_auth.dart';
import 'package:egy_tracker/core/services/f_firestore.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';
import 'package:egy_tracker/features/home/vm_home_feed.dart';
import 'package:egy_tracker/features/my_tracker/s_my_tracker.dart';
import 'package:egy_tracker/features/my_tracker/vm_my_tracker.dart';

class FakeFirestoreService extends FirestoreService {
  List<AllowedEmail> allowedEmails = [];
  List<UserProfile> users = [];
  List<InitialBalance> initialBalances = [];
  List<Expense> expenses = [];
  List<Exchange> exchanges = [];
  List<Borrow> borrows = [];

  final _expensesCtrl = StreamController<List<Expense>>.broadcast();
  final _exchangesCtrl = StreamController<List<Exchange>>.broadcast();
  final _borrowsCtrl = StreamController<List<Borrow>>.broadcast();
  final _balancesCtrl = StreamController<List<InitialBalance>>.broadcast();
  final _usersCtrl = StreamController<List<UserProfile>>.broadcast();
  final _emailsCtrl = StreamController<List<AllowedEmail>>.broadcast();

  void emitExpenses(List<Expense> list) {
    expenses = list;
    _expensesCtrl.add(list);
  }

  void emitBalances(List<InitialBalance> list) {
    initialBalances = list;
    _balancesCtrl.add(list);
  }

  @override
  Stream<List<AllowedEmail>> getAllowedEmailsStream() async* {
    yield allowedEmails;
    yield* _emailsCtrl.stream;
  }

  @override
  Stream<List<UserProfile>> getUsersStream() async* {
    yield users;
    yield* _usersCtrl.stream;
  }

  @override
  Stream<List<InitialBalance>> getInitialBalancesStream() async* {
    yield initialBalances;
    yield* _balancesCtrl.stream;
  }

  @override
  Stream<List<Expense>> getExpensesStream() async* {
    yield expenses;
    yield* _expensesCtrl.stream;
  }

  @override
  Stream<List<Exchange>> getExchangesStream() async* {
    yield exchanges;
    yield* _exchangesCtrl.stream;
  }

  @override
  Stream<List<Borrow>> getBorrowsStream() async* {
    yield borrows;
    yield* _borrowsCtrl.stream;
  }

  @override
  Future<void> addExpense(Expense expense) async {
    expenses.removeWhere((e) => e.id == expense.id);
    expenses.add(expense);
    _expensesCtrl.add(expenses);
  }

  @override
  Future<void> deleteExpense(String id) async {
    expenses.removeWhere((e) => e.id == id);
    _expensesCtrl.add(expenses);
  }
}

void main() {
  group('MyTrackerViewModel Tests', () {
    late FakeFirestoreService firestoreService;
    late DevUser userA;
    late DevUser userB;

    setUp(() {
      firestoreService = FakeFirestoreService();
      userA = DevUser(
        uid: 'uid_a',
        email: 'abderrahmane.saoudi.26@gmail.com',
        displayName: 'Abderrahmane',
      );
      userB = DevUser(
        uid: 'uid_b',
        email: 'friend@gmail.com',
        displayName: 'Friend Traveler',
      );

      // Seed allowed emails (User A is primary)
      firestoreService.allowedEmails = [
        AllowedEmail(
          id: 'ae1',
          email: 'abderrahmane.saoudi.26@gmail.com',
          createdAt: DateTime(2026, 1, 1),
        ),
        AllowedEmail(
          id: 'ae2',
          email: 'friend@gmail.com',
          createdAt: DateTime(2026, 1, 2),
        ),
      ];

      // Seed user profiles
      firestoreService.users = [
        UserProfile(
          id: 'uid_a',
          email: 'abderrahmane.saoudi.26@gmail.com',
          name: 'Abderrahmane',
          createdAt: DateTime(2026, 1, 1),
        ),
        UserProfile(
          id: 'uid_b',
          email: 'friend@gmail.com',
          name: 'Friend Traveler',
          createdAt: DateTime(2026, 1, 2),
        ),
      ];

      // Seed initial balances
      firestoreService.initialBalances = [
        InitialBalance(
          userId: 'uid_a',
          usdAmount: 300.0,
          egpAmount: 5000.0,
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];
    });

    test('Categorizes expenses into My Expenses (100%) and Shared Expenses (>0% and <100%)', () async {
      // Scenario A: Taxi $15, Paid by Me, 100% Me
      final expA = Expense(
        id: 'expA',
        title: 'Taxi to Hotel',
        amount: 15.0,
        currency: 'USD',
        paidBy: 'uid_a',
        splitType: 'default_100',
        mePercentage: 100.0,
        friendPercentage: 0.0,
        date: DateTime(2026, 9, 1),
        createdAt: DateTime(2026, 9, 1),
      );

      // Scenario B: Dinner 1,000 EGP, Paid by Me, 50/50
      final expB = Expense(
        id: 'expB',
        title: 'Dinner at Nile',
        amount: 1000.0,
        currency: 'EGP',
        paidBy: 'uid_a',
        splitType: 'fifty_fifty',
        mePercentage: 50.0,
        friendPercentage: 50.0,
        date: DateTime(2026, 9, 2),
        createdAt: DateTime(2026, 9, 2),
      );

      // Scenario C: Coffee $10, Paid by Friend, 100% Me
      final expC = Expense(
        id: 'expC',
        title: 'Coffee for Me',
        amount: 10.0,
        currency: 'USD',
        paidBy: 'uid_b',
        splitType: 'custom',
        mePercentage: 100.0,
        friendPercentage: 0.0,
        date: DateTime(2026, 9, 3),
        createdAt: DateTime(2026, 9, 3),
      );

      // Scenario D: Dinner 2,000 EGP, Paid by Friend, Me 70% / Friend 30%
      final expD = Expense(
        id: 'expD',
        title: 'Seafood Feast',
        amount: 2000.0,
        currency: 'EGP',
        paidBy: 'uid_b',
        splitType: 'custom',
        mePercentage: 70.0,
        friendPercentage: 30.0,
        date: DateTime(2026, 9, 4),
        createdAt: DateTime(2026, 9, 4),
      );

      // Scenario Other: Souvenirs $50, Paid by Friend for Friend (100% Friend, 0% Me)
      final expFriendSolo = Expense(
        id: 'expSolo',
        title: 'Friend Souvenir',
        amount: 50.0,
        currency: 'USD',
        paidBy: 'uid_b',
        splitType: 'default_100',
        mePercentage: 0.0,
        friendPercentage: 100.0,
        date: DateTime(2026, 9, 5),
        createdAt: DateTime(2026, 9, 5),
      );

      firestoreService.expenses = [expA, expB, expC, expD, expFriendSolo];

      final vm = MyTrackerViewModel(
        user: userA,
        firestoreService: firestoreService,
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(vm.isPrimaryUser, isTrue);

      // My Expenses (100% share): expA ($15) and expC ($10)
      expect(vm.myExpenses.length, equals(2));
      expect(vm.myExpenses.map((e) => e.id), containsAll(['expA', 'expC']));

      // Shared Expenses (>0% and <100%): expB (50%) and expD (70%)
      expect(vm.sharedExpenses.length, equals(2));
      expect(vm.sharedExpenses.map((e) => e.id), containsAll(['expB', 'expD']));

      // Friend's 100% solo expense (0% Me) must be completely excluded from userA's personal lists
      expect(vm.allPersonalExpenses.length, equals(4));
      expect(vm.allPersonalExpenses.any((e) => e.id == 'expSolo'), isFalse);

      // Spending Totals (Strict currency independence: USD separate from EGP)
      // USD Personal Spending = $15 (expA) + $10 (expC) = $25.0
      expect(vm.totalPersonalSpendingUsd, equals(25.0));

      // EGP Personal Spending = 500 EGP (expB) + 1400 EGP (expD) = 1900.0 EGP
      expect(vm.totalPersonalSpendingEgp, equals(1900.0));

      // Physical cash balances:
      // USD cash: 300 initial - 15 expA paid = 285 USD (expC was paid by Friend)
      expect(vm.myUsdBalance, equals(285.0));
      // EGP cash: 5000 initial - 1000 expB paid = 4000 EGP (expD was paid by Friend)
      expect(vm.myEgpBalance, equals(4000.0));

      // Filter tests
      expect(vm.filter, equals(MyTrackerFilter.all));
      vm.setFilter(MyTrackerFilter.myExpenses);
      expect(vm.filter, equals(MyTrackerFilter.myExpenses));
      vm.setFilter(MyTrackerFilter.sharedExpenses);
      expect(vm.filter, equals(MyTrackerFilter.sharedExpenses));

      vm.dispose();
    });

    test('Works correctly when Friend (secondary user) views My Tracker', () async {
      // Scenario D: Dinner 2,000 EGP, Paid by Friend, Me 70% / Friend 30%
      final expD = Expense(
        id: 'expD',
        title: 'Seafood Feast',
        amount: 2000.0,
        currency: 'EGP',
        paidBy: 'uid_b',
        splitType: 'custom',
        mePercentage: 70.0,
        friendPercentage: 30.0,
        date: DateTime(2026, 9, 4),
        createdAt: DateTime(2026, 9, 4),
      );

      firestoreService.expenses = [expD];

      final vm = MyTrackerViewModel(
        user: userB,
        firestoreService: firestoreService,
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(vm.isPrimaryUser, isFalse);

      // For Friend, their share of expD is 30% = 600 EGP
      expect(vm.sharedExpenses.length, equals(1));
      expect(vm.calculateUserPercentage(expD), equals(30.0));
      expect(vm.calculateUserShare(expD), equals(600.0));
      expect(vm.totalPersonalSpendingEgp, equals(600.0));

      vm.dispose();
    });
  });

  group('MyTrackerScreen Widget Tests', () {
    late FakeFirestoreService firestoreService;
    late DevUser userA;
    late HomeFeedViewModel feedViewModel;

    setUp(() {
      firestoreService = FakeFirestoreService();
      userA = DevUser(
        uid: 'uid_a',
        email: 'abderrahmane.saoudi.26@gmail.com',
        displayName: 'Abderrahmane',
      );

      firestoreService.allowedEmails = [
        AllowedEmail(
          id: 'ae1',
          email: 'abderrahmane.saoudi.26@gmail.com',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      firestoreService.initialBalances = [
        InitialBalance(
          userId: 'uid_a',
          usdAmount: 150.0,
          egpAmount: 3500.0,
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];

      feedViewModel = HomeFeedViewModel(
        user: userA,
        firestoreService: firestoreService,
      );
    });

    tearDown(() {
      feedViewModel.dispose();
    });

    testWidgets('Renders personal balance card, spending summary, and empty states when no expenses', (tester) async {
      tester.view.physicalSize = const Size(1200, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: MyTrackerScreen(
              user: userA,
              firestoreService: firestoreService,
              feedViewModel: feedViewModel,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify TravelerBalanceCard is rendered with personal balances
      expect(find.byType(TravelerBalanceCard), findsOneWidget);
      expect(find.text('\$150.00'), findsOneWidget);
      expect(find.text('3,500.00 EGP'), findsOneWidget);

      // Verify SegmentedPillBar is rendered
      expect(find.byType(SegmentedPillBar<MyTrackerFilter>), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Mine'), findsOneWidget);
      expect(find.text('Shared'), findsOneWidget);

      // Verify Empty state for unified list
      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('No personal expenses yet'), findsOneWidget);
    });

    testWidgets('Renders personal expenses and shared expenses with exact shares and enables filtering', (tester) async {
      tester.view.physicalSize = const Size(1200, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final exp1 = Expense(
        id: 'exp1',
        title: 'Taxi to Pyramids',
        amount: 25.0,
        currency: 'USD',
        paidBy: 'uid_a',
        splitType: 'default_100',
        mePercentage: 100.0,
        friendPercentage: 0.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final exp2 = Expense(
        id: 'exp2',
        title: 'Dinner Koshary',
        amount: 600.0,
        currency: 'EGP',
        paidBy: 'uid_a',
        splitType: 'fifty_fifty',
        mePercentage: 50.0,
        friendPercentage: 50.0,
        date: DateTime.now(),
        createdAt: DateTime.now(),
      );

      firestoreService.emitExpenses([exp1, exp2]);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: MyTrackerScreen(
              user: userA,
              firestoreService: firestoreService,
              feedViewModel: feedViewModel,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Personal shares reflect in activity tiles ($25.00 and 300.00 EGP)
      expect(find.text('\$25.00'), findsOneWidget); // 100% of $25
      expect(find.text('300.00 EGP'), findsOneWidget); // 50% of 600 EGP

      // Activity tiles should render
      expect(find.byType(ActivityTile), findsNWidgets(2));
      expect(find.text('Taxi to Pyramids'), findsOneWidget);
      expect(find.text('Dinner Koshary'), findsOneWidget);

      // Check My Share text formatting
      expect(find.text('My share: 100%'), findsOneWidget);
      expect(find.text('Total: 600.00 EGP'), findsOneWidget);

      // Filter: tap "Mine" segment
      await tester.tap(find.text('Mine'));
      await tester.pumpAndSettle();

      // Only 1 tile now
      expect(find.byType(ActivityTile), findsOneWidget);
      expect(find.text('Taxi to Pyramids'), findsOneWidget);
      expect(find.text('Dinner Koshary'), findsNothing);

      // Filter: tap "Shared" segment
      await tester.tap(find.text('Shared'));
      await tester.pumpAndSettle();

      // Only shared tile now
      expect(find.byType(ActivityTile), findsOneWidget);
      expect(find.text('Dinner Koshary'), findsOneWidget);
      expect(find.text('Taxi to Pyramids'), findsNothing);
    });
  });
}
