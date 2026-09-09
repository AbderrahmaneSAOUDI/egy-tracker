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
import 'package:egy_tracker/features/home/s_home.dart';

class FakeAuthService extends AuthService {
  FakeAuthService() : super(initializeGoogleSignIn: false);
}

class FakeFirestoreService extends FirestoreService {
  @override
  Stream<List<AllowedEmail>> getAllowedEmailsStream() {
    return Stream.value([
      AllowedEmail(
        id: '1',
        email: 'abderrahmane.saoudi.26@gmail.com',
        createdAt: DateTime.now(),
      ),
    ]);
  }

  @override
  Stream<List<InitialBalance>> getInitialBalancesStream() {
    return Stream.value([]);
  }

  @override
  Stream<List<UserProfile>> getUsersStream() {
    return Stream.value([]);
  }

  @override
  Stream<List<Expense>> getExpensesStream() {
    return Stream.value([]);
  }

  @override
  Stream<List<Exchange>> getExchangesStream() {
    return Stream.value([]);
  }

  @override
  Stream<List<Borrow>> getBorrowsStream() {
    return Stream.value([]);
  }
}

void main() {
  group('HomeScreen Bottom Navigation Tests', () {
    late FakeAuthService fakeAuthService;
    late FakeFirestoreService fakeFirestoreService;
    late DevUser devUser;

    setUp(() {
      fakeAuthService = FakeAuthService();
      fakeFirestoreService = FakeFirestoreService();
      devUser = DevUser(email: 'abderrahmane.saoudi.26@gmail.com');
    });

    testWidgets('Renders FloatingPillNavBar with Home active by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: HomeScreen(
            user: devUser,
            authService: fakeAuthService,
            firestoreService: fakeFirestoreService,
          ),
        ),
      );

      // Verify AppBar is removed and FloatingPillNavBar exists
      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(FloatingPillNavBar), findsOneWidget);

      // Default index 0 (Home selected):
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Home')),
        findsOneWidget,
      );

      // Inactive items ('My Tracker', 'Settings') have their labels hidden
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('My Tracker')),
        findsNothing,
      );
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Settings')),
        findsNothing,
      );

      // Icons are all visible in the navigation bar (Home active, others inactive)
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.byIcon(Icons.home_rounded)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.byIcon(Icons.person_outline_rounded)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.byIcon(Icons.settings_outlined)),
        findsOneWidget,
      );

      // Add button is hidden on Home (dashboard only)
      expect(find.byKey(const ValueKey('nav_add_button')), findsNothing);

      final navBar = tester.widget<FloatingPillNavBar>(find.byType(FloatingPillNavBar));
      expect(navBar.selectedIndex, equals(0));
    });

    testWidgets('Switching destinations updates label visibility, selectedIndex, and active screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: HomeScreen(
            user: devUser,
            authService: fakeAuthService,
            firestoreService: fakeFirestoreService,
          ),
        ),
      );

      // Starts on Home (index 0) with Add button hidden (dashboard only)
      var navBar = tester.widget<FloatingPillNavBar>(find.byType(FloatingPillNavBar));
      expect(navBar.selectedIndex, equals(0));
      expect(find.byKey(const ValueKey('nav_add_button')), findsNothing);

      // Tap 'Settings' nav item
      final settingsItem = find.byKey(const ValueKey('nav_item_settings'));
      await tester.tap(settingsItem);
      await tester.pumpAndSettle();

      navBar = tester.widget<FloatingPillNavBar>(find.byType(FloatingPillNavBar));
      expect(navBar.selectedIndex, equals(2));
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Settings')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Home')),
        findsNothing,
      );

      // Add button is hidden on Settings
      expect(find.byKey(const ValueKey('nav_add_button')), findsNothing);

      // Tap 'My Tracker' nav item
      final myTrackerItem = find.byKey(const ValueKey('nav_item_my_tracker'));
      await tester.tap(myTrackerItem);
      await tester.pumpAndSettle();

      navBar = tester.widget<FloatingPillNavBar>(find.byType(FloatingPillNavBar));
      expect(navBar.selectedIndex, equals(1));
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('My Tracker')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Settings')),
        findsNothing,
      );

      // Add button is visible on My Tracker
      expect(find.byKey(const ValueKey('nav_add_button')), findsOneWidget);

      // Tap 'Home' nav item
      final homeItem = find.byKey(const ValueKey('nav_item_home'));
      await tester.tap(homeItem);
      await tester.pumpAndSettle();

      navBar = tester.widget<FloatingPillNavBar>(find.byType(FloatingPillNavBar));
      expect(navBar.selectedIndex, equals(0));
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('Home')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(FloatingPillNavBar), matching: find.text('My Tracker')),
        findsNothing,
      );

      // Add button is hidden on Home
      expect(find.byKey(const ValueKey('nav_add_button')), findsNothing);
    });
  });
}
