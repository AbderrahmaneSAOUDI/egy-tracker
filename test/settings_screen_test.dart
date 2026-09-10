import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/components/c_floating_pill_nav_bar.dart';
import 'package:egy_tracker/core/models/mod_allowed_email.dart';
import 'package:egy_tracker/core/models/mod_borrow.dart';
import 'package:egy_tracker/core/models/mod_exchange.dart';
import 'package:egy_tracker/core/models/mod_expense.dart';
import 'package:egy_tracker/core/models/mod_initial_balance.dart';
import 'package:egy_tracker/core/models/mod_user_profile.dart';
import 'package:egy_tracker/core/services/f_auth.dart';
import 'package:egy_tracker/core/services/f_firestore.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';
import 'package:egy_tracker/features/auth/s_auth_gate.dart';
import 'package:egy_tracker/features/settings/s_settings.dart';

class FakeAuthService extends AuthService {
  FakeAuthService() : super(initializeGoogleSignIn: false);
}

class FakeFirestoreService extends FirestoreService {
  List<AllowedEmail> _emails = [];
  final StreamController<List<AllowedEmail>> _controller =
      StreamController<List<AllowedEmail>>.broadcast();
  final List<String> addedEmails = [];
  final List<String> deletedEmailIds = [];

  List<InitialBalance> _balances = [];
  final StreamController<List<InitialBalance>> _balancesController =
      StreamController<List<InitialBalance>>.broadcast();
  final Map<String, InitialBalance> savedBalances = {};
  bool deleteAllTripDataCalled = false;

  List<UserProfile> _users = [];
  final StreamController<List<UserProfile>> _usersController =
      StreamController<List<UserProfile>>.broadcast();

  void emitEmails(List<AllowedEmail> list) {
    _emails = list;
    _controller.add(list);
  }

  void emitBalances(List<InitialBalance> list) {
    _balances = list;
    _balancesController.add(list);
  }

  void emitUsers(List<UserProfile> list) {
    _users = list;
    _usersController.add(list);
  }

  @override
  Stream<List<UserProfile>> getUsersStream() async* {
    yield _users;
    yield* _usersController.stream;
  }

  @override
  Stream<List<AllowedEmail>> getAllowedEmailsStream() async* {
    yield _emails;
    yield* _controller.stream;
  }

  @override
  Stream<List<InitialBalance>> getInitialBalancesStream() async* {
    yield _balances;
    yield* _balancesController.stream;
  }

  @override
  Stream<List<Expense>> getExpensesStream() => Stream.value([]);

  @override
  Stream<List<Exchange>> getExchangesStream() => Stream.value([]);

  @override
  Stream<List<Borrow>> getBorrowsStream() => Stream.value([]);

  @override
  Future<void> setInitialBalances({
    required String userId,
    required double usdAmount,
    required double egpAmount,
  }) async {
    savedBalances[userId] = InitialBalance(
      userId: userId,
      usdAmount: usdAmount,
      egpAmount: egpAmount,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteAllTripData({String? keepEmail, String? keepUserId}) async {
    deleteAllTripDataCalled = true;
  }

  @override
  Future<void> addAllowedEmail(String email) async {
    addedEmails.add(email);
  }

  @override
  Future<void> deleteAllowedEmail(String id) async {
    deletedEmailIds.add(id);
  }

  @override
  Future<bool> isEmailAllowed(String email) async => true;

  @override
  Future<void> saveUserProfile(dynamic user) async {}
}

void main() {
  group('SettingsScreen Tests', () {
    late FakeAuthService authService;
    late FakeFirestoreService firestoreService;
    late DevUser currentUser;

    setUp(() {
      authService = FakeAuthService();
      firestoreService = FakeFirestoreService();
      currentUser = DevUser(
        uid: 'dev_user_saoudi',
        email: 'abderrahmane.saoudi.26@gmail.com',
      );
      AppTheme.setThemeMode(ThemeMode.system);
    });

    void setLargeSurface(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 2500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    Widget createWidget() {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: Scaffold(
          body: SettingsScreen(
            user: currentUser,
            authService: authService,
            firestoreService: firestoreService,
          ),
        ),
      );
    }

    testWidgets('Renders Theme Mode card and switches themes', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([]);
      await tester.pump();

      // Check Theme Mode Card header
      expect(find.text('Theme Mode'), findsOneWidget);

      // Expand Theme Mode card
      await tester.tap(find.text('Theme Mode'));
      await tester.pumpAndSettle();

      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('Auto'), findsOneWidget);

      expect(AppTheme.themeModeNotifier.value, equals(ThemeMode.system));

      // Tap Light
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(AppTheme.themeModeNotifier.value, equals(ThemeMode.light));

      // Tap Dark
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(AppTheme.themeModeNotifier.value, equals(ThemeMode.dark));

      // Tap Auto
      await tester.tap(find.text('Auto'));
      await tester.pumpAndSettle();
      expect(AppTheme.themeModeNotifier.value, equals(ThemeMode.system));
    });

    testWidgets('Renders empty state when allowed emails list is empty', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([]);
      await tester.pump();

      expect(find.text('Allowed Emails'), findsOneWidget);

      // Expand Allowed Emails card
      await tester.tap(find.text('Allowed Emails'));
      await tester.pumpAndSettle();

      expect(find.text('No allowed emails yet'), findsOneWidget);
    });

    testWidgets('Renders emails and identifies current user with You badge', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([
        AllowedEmail(
          id: 'doc-1',
          email: 'abderrahmane.saoudi.26@gmail.com',
          createdAt: DateTime.now(),
        ),
        AllowedEmail(
          id: 'doc-2',
          email: 'friend@example.com',
          createdAt: DateTime.now(),
        ),
      ]);
      await tester.pump();

      // Expand Allowed Emails card
      await tester.tap(find.text('Allowed Emails'));
      await tester.pumpAndSettle();

      expect(find.text('abderrahmane.saoudi.26@gmail.com'), findsNWidgets(3));
      expect(find.text('friend@example.com'), findsWidgets);
      expect(find.text('You'), findsWidgets);
    });

    testWidgets('Opens Add Email dialog, validates and adds email', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([]);
      await tester.pump();

      // Tap Add button in header
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await tester.pumpAndSettle();

      expect(find.text('Add Allowed Email'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Cancel'), findsOneWidget);

      // Submit empty using Add button inside AlertDialog
      final addDialogButton = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Add'),
      );
      await tester.tap(addDialogButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter an email'), findsOneWidget);
      expect(firestoreService.addedEmails, isEmpty);

      // Enter invalid email
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'not-an-email');
      await tester.tap(addDialogButton);
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(firestoreService.addedEmails, isEmpty);

      // Enter valid email
      await tester.enterText(textField, 'partner@gmail.com');
      await tester.tap(addDialogButton);
      await tester.pumpAndSettle();

      expect(firestoreService.addedEmails, contains('partner@gmail.com'));
      expect(find.text('Add Allowed Email'), findsNothing);
    });

    testWidgets('Confirm delete email dialog calls deleteAllowedEmail', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([
        AllowedEmail(
          id: 'del-123',
          email: 'remove-me@example.com',
          createdAt: DateTime.now(),
        ),
      ]);
      await tester.pump();

      // Expand Allowed Emails card
      await tester.tap(find.text('Allowed Emails'));
      await tester.pumpAndSettle();

      // Find delete button
      final deleteBtn = find.byTooltip('Remove');
      expect(deleteBtn, findsOneWidget);

      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      expect(find.text('Remove Allowed Email?'), findsOneWidget);
      expect(find.text('Are you sure you want to remove remove-me@example.com?'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Cancel'), findsOneWidget);

      // Tap cancel first
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(firestoreService.deletedEmailIds, isEmpty);

      // Tap delete again and confirm
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(firestoreService.deletedEmailIds, contains('del-123'));
    });

    testWidgets('Changing theme mode within full app keeps user on Settings screen', (tester) async {
      setLargeSurface(tester);
      await authService.signInAsDevUser('abderrahmane.saoudi.26@gmail.com');

      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: AppTheme.themeModeNotifier,
          builder: (context, themeMode, _) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: AuthGate(
                authService: authService,
                firestoreService: firestoreService,
              ),
            );
          },
        ),
      );

      // Pump initial tree
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Emit empty email list so the stream settles
      firestoreService.emitEmails([]);
      await tester.pumpAndSettle();

      // Switch to Settings tab (nav_item_settings)
      final settingsNavItem = find.byKey(const ValueKey('nav_item_settings'));
      expect(settingsNavItem, findsOneWidget);
      await tester.tap(settingsNavItem);
      await tester.pumpAndSettle();

      // Ensure we are on Settings tab
      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget); // Nav item

      // Expand Theme Mode card
      await tester.tap(find.text('Theme Mode'));
      await tester.pumpAndSettle();

      // Now toggle theme to Dark from within the Settings card
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      // Verify theme changed to dark
      expect(AppTheme.themeModeNotifier.value, equals(ThemeMode.dark));

      // CRITICAL ASSERTION: We must still be on the Settings screen, NOT kicked back to Home!
      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Settings')), findsOneWidget);

      // Toggle to Light
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(AppTheme.themeModeNotifier.value, equals(ThemeMode.light));

      // Still on Settings
      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Settings')), findsOneWidget);
    });

    testWidgets('Renders Initial Balances card with You and Friend sections', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([
        AllowedEmail(
          id: 'doc-1',
          email: 'abderrahmane.saoudi.26@gmail.com',
          createdAt: DateTime.now(),
        ),
        AllowedEmail(
          id: 'doc-2',
          email: 'friend@example.com',
          createdAt: DateTime.now(),
        ),
      ]);
      firestoreService.emitBalances([
        InitialBalance(
          userId: 'dev_user_saoudi',
          usdAmount: 150.0,
          egpAmount: 0.0,
          updatedAt: DateTime.now(),
        ),
        InitialBalance(
          userId: 'friend@example.com',
          usdAmount: 200.0,
          egpAmount: 500.0,
          updatedAt: DateTime.now(),
        ),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Initial Balances'), findsOneWidget);

      // Expand Initial Balances card
      await tester.tap(find.text('Initial Balances'));
      await tester.pumpAndSettle();

      expect(find.text('\$150'), findsOneWidget);
      expect(find.text('0 EGP'), findsOneWidget);
      expect(find.text('\$200'), findsOneWidget);
      expect(find.text('500 EGP'), findsOneWidget);
      expect(find.text('friend@example.com'), findsNWidgets(3)); // Balances name + email + Whitelist
    });

    testWidgets('Opens edit initial balances dialog, validates, and updates starting cash', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([]);
      firestoreService.emitBalances([]);
      await tester.pumpAndSettle();

      // Expand Initial Balances card
      await tester.tap(find.text('Initial Balances'));
      await tester.pumpAndSettle();

      final editYouBtn = find.byKey(const ValueKey('edit_balance_you'));
      expect(editYouBtn, findsOneWidget);

      await tester.tap(editYouBtn);
      await tester.pumpAndSettle();

      // Dialog is open
      expect(find.text('Starting USD (\$)'), findsOneWidget);
      expect(find.text('Starting EGP (EGP)'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Cancel'), findsOneWidget);

      // Enter negative amount to test validation
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, '-50');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Amount must be positive'), findsOneWidget);
      expect(firestoreService.savedBalances, isEmpty);

      // Enter valid amounts
      await tester.enterText(textFields.first, '250');
      await tester.enterText(textFields.last, '1000');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(firestoreService.savedBalances.containsKey('dev_user_saoudi'), isTrue);
      expect(firestoreService.savedBalances['dev_user_saoudi']!.usdAmount, equals(250.0));
      expect(firestoreService.savedBalances['dev_user_saoudi']!.egpAmount, equals(1000.0));
    });

    testWidgets('Renders Delete All Data button, opens confirmation dialog, and calls deleteAllTripData', (tester) async {
      setLargeSurface(tester);
      await tester.pumpWidget(createWidget());
      firestoreService.emitEmails([]);
      firestoreService.emitBalances([]);
      await tester.pumpAndSettle();

      // Expand Trip Data & Reset card
      await tester.tap(find.text('Trip Data & Reset'));
      await tester.pumpAndSettle();

      final deleteBtn = find.byKey(const ValueKey('delete_all_data_button'));
      expect(deleteBtn, findsOneWidget);

      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Dialog shown
      expect(find.text('Delete All Trip Data?'), findsOneWidget);
      expect(find.text('All Expenses (USD & EGP)'), findsOneWidget);
      expect(find.text('All Currency Exchanges'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Cancel'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(firestoreService.deleteAllTripDataCalled, isFalse);

      // Open again and confirm
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete Everything'));
      await tester.pumpAndSettle();

      expect(firestoreService.deleteAllTripDataCalled, isTrue);
      expect(find.text('All trip data has been deleted.'), findsOneWidget);
    });
  });
}
