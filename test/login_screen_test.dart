import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:egy_tracker/core/services/f_auth.dart';
import 'package:egy_tracker/core/theme/t_app_theme.dart';
import 'package:egy_tracker/features/auth/s_login.dart';

class FakeAuthService extends AuthService {
  bool signInCalled = false;
  bool autoLoginCalled = false;
  bool shouldThrow = false;

  FakeAuthService() : super(initializeGoogleSignIn: false);

  @override
  Future<void> tryRestoreSession() async {}

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    signInCalled = true;
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return null;
  }

  @override
  Future<User> signInAsDevUser([String email = 'abderrahmane.saoudi.26@gmail.com']) async {
    autoLoginCalled = true;
    if (shouldThrow) {
      throw Exception('Auto-login error');
    }
    return DevUser(email: email);
  }
}

void main() {
  group('LoginScreen Tests', () {
    late FakeAuthService fakeAuthService;

    setUp(() {
      fakeAuthService = FakeAuthService();
    });

    Widget buildTestWidget() {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: LoginScreen(authService: fakeAuthService),
      );
    }

    testWidgets('Renders simplified login screen elements', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Title & Subtitle
      expect(find.text('egy_tracker'), findsOneWidget);
      expect(find.text('Trip Expense Tracker'), findsOneWidget);

      // Google Sign-In button
      expect(find.text('Sign in with Google'), findsOneWidget);

      // Private access note
      expect(find.text('Private access for trip members'), findsOneWidget);

      // Cluttered badges must NOT be present
      expect(find.text('USD (\$)'), findsNothing);
      expect(find.text('EGP (ج.م)'), findsNothing);
    });

    testWidgets('Tapping Sign in with Google triggers auth service', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final buttonFinder = find.widgetWithText(OutlinedButton, 'Sign in with Google');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      expect(fakeAuthService.signInCalled, isTrue);
    });

    testWidgets('Tapping logo triggers auto login via auth service', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      final logoFinder = find.byKey(const Key('login_logo_button'));
      expect(logoFinder, findsOneWidget);

      await tester.tap(logoFinder);
      await tester.pump();

      expect(fakeAuthService.autoLoginCalled, isTrue);
    });

    testWidgets('Displays error message when sign-in fails', (WidgetTester tester) async {
      fakeAuthService.shouldThrow = true;

      await tester.pumpWidget(buildTestWidget());

      final buttonFinder = find.widgetWithText(OutlinedButton, 'Sign in with Google');
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(find.textContaining('Sign-in failed: Exception: Network error'), findsOneWidget);
    });
  });
}
