import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:egy_tracker/core/models/mod_allowed_email.dart';
import 'package:egy_tracker/core/models/mod_initial_balance.dart';
import 'package:egy_tracker/core/models/mod_user_profile.dart';
import 'package:egy_tracker/core/services/f_auth.dart';
import 'package:egy_tracker/core/services/f_firestore.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';
import 'package:egy_tracker/features/auth/components/c_auth_whitelist_gate.dart';
import 'package:egy_tracker/features/auth/s_login.dart';
import 'package:egy_tracker/features/home/s_home.dart';

class _GateFakeAuthService extends AuthService {
  bool signOutCalled = false;

  _GateFakeAuthService() : super(initializeGoogleSignIn: false);

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }
}

class _GateFakeFirestoreService extends FirestoreService {
  Completer<bool>? completer;
  bool isAllowedResult = true;

  @override
  Future<bool> isEmailAllowed(String email) {
    if (completer != null) {
      return completer!.future;
    }
    return Future.value(isAllowedResult);
  }

  @override
  Stream<List<AllowedEmail>> getAllowedEmailsStream() => Stream.value([]);
  @override
  Stream<List<InitialBalance>> getInitialBalancesStream() => Stream.value([]);
  @override
  Stream<List<UserProfile>> getUsersStream() => Stream.value([]);
}

void main() {
  group('AuthWhitelistGate Merged Login Tests', () {
    late _GateFakeAuthService fakeAuth;
    late _GateFakeFirestoreService fakeFirestore;
    late User fakeUser;

    setUp(() {
      fakeAuth = _GateFakeAuthService();
      fakeFirestore = _GateFakeFirestoreService();
      fakeUser = DevUser(email: 'traveler@example.com');
    });

    testWidgets('Displays LoginScreen with GoogleProgressBar while verifying authorization',
        (WidgetTester tester) async {
      fakeFirestore.completer = Completer<bool>();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: AuthWhitelistGate(
            user: fakeUser,
            authService: fakeAuth,
            firestoreService: fakeFirestore,
          ),
        ),
      );
      await tester.pump();

      // Renders LoginScreen with progress bar, not a plain Scaffold
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(GoogleProgressBar), findsOneWidget);
      expect(find.text('Verifying trip authorization...'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsNothing);
    });

    testWidgets('Transitions to HomeScreen when whitelist verification succeeds',
        (WidgetTester tester) async {
      fakeFirestore.isAllowedResult = true;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: AuthWhitelistGate(
            user: fakeUser,
            authService: fakeAuth,
            firestoreService: fakeFirestore,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Displays LoginScreen with error banner and Google button when authorization fails',
        (WidgetTester tester) async {
      fakeFirestore.isAllowedResult = false;
      String? reportedFailure;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: AuthWhitelistGate(
            user: fakeUser,
            authService: fakeAuth,
            firestoreService: fakeFirestore,
            onAuthFailed: (msg) {
              reportedFailure = msg;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Progress bar should disappear
      expect(find.byType(GoogleProgressBar), findsNothing);

      // Error message and Google Sign In button must be shown
      expect(
        find.text('The account "traveler@example.com" is not authorized for this trip.'),
        findsOneWidget,
      );
      expect(find.text('Sign in with Google'), findsOneWidget);

      // Payout/signout should be initiated for security
      expect(fakeAuth.signOutCalled, isTrue);
      expect(reportedFailure, contains('not authorized'));
    });
  });
}
