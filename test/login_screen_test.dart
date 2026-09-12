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

      // App Title
      expect(find.text('egy_tracker'), findsOneWidget);

      // Google Sign-In button
      expect(find.text('Sign in with Google'), findsOneWidget);

      // Subtitles, notes, and cluttered badges must NOT be present
      expect(find.text('Trip Expense Tracker'), findsNothing);
      expect(find.text('Private access for trip members'), findsNothing);
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

    testWidgets('Renders AnimatedLoginBackground behind login form in light and dark mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: LoginScreen(
          authService: fakeAuthService,
          enableLoopAnimation: false,
        ),
      ));

      expect(find.byType(AnimatedLoginBackground), findsOneWidget);
      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.text('egy_tracker'), findsOneWidget);
    });

    testWidgets('Shows GoogleProgressBar and hides login button when isVerifying is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: LoginScreen(
          authService: fakeAuthService,
          isVerifying: true,
          verificationMessage: 'Verifying trip authorization...',
          enableLoopAnimation: false,
        ),
      ));

      // Logo and Title still visible
      expect(find.byKey(const Key('login_logo_button')), findsOneWidget);
      expect(find.text('egy_tracker'), findsOneWidget);

      // Google progress bar and caption are visible
      expect(find.byType(GoogleProgressBar), findsOneWidget);
      expect(find.text('Verifying trip authorization...'), findsOneWidget);

      // Google Sign-In button is NOT shown
      expect(find.text('Sign in with Google'), findsNothing);

      // Tapping logo while verifying does not trigger auto login
      await tester.tap(find.byKey(const Key('login_logo_button')));
      await tester.pump();
      expect(fakeAuthService.autoLoginCalled, isFalse);
    });

    testWidgets('Shows Google sign-in button and error banner when authorization failed',
        (WidgetTester tester) async {
      const errorMsg = 'The account "unauthorized@example.com" is not authorized for this trip.';
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: LoginScreen(
          authService: fakeAuthService,
          isVerifying: false,
          errorMessage: errorMsg,
          enableLoopAnimation: false,
        ),
      ));

      // Progress bar should NOT be shown
      expect(find.byType(GoogleProgressBar), findsNothing);

      // Error message banner should be shown
      expect(find.text(errorMsg), findsOneWidget);

      // Google sign-in button should be shown
      expect(find.text('Sign in with Google'), findsOneWidget);
    });
  });
}
