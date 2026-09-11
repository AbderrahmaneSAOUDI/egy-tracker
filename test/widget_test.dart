import 'package:flutter_test/flutter_test.dart';
import 'package:egy_tracker/core/models/mod_allowed_email.dart';
import 'package:egy_tracker/core/models/mod_initial_balance.dart';
import 'package:egy_tracker/core/models/mod_user_profile.dart';
import 'package:egy_tracker/core/services/f_auth.dart';
import 'package:egy_tracker/core/services/f_firestore.dart';
import 'package:egy_tracker/main.dart';

class _FakeAuthService extends AuthService {
  _FakeAuthService() : super(initializeGoogleSignIn: false);
}

class _FakeFirestoreService extends FirestoreService {
  @override
  Stream<List<AllowedEmail>> getAllowedEmailsStream() => Stream.value([]);
  @override
  Stream<List<InitialBalance>> getInitialBalancesStream() => Stream.value([]);
  @override
  Stream<List<UserProfile>> getUsersStream() => Stream.value([]);
}

void main() {
  testWidgets('App smoke test initializes MyApp and AuthGate', (WidgetTester tester) async {
    final fakeAuth = _FakeAuthService();
    final fakeFirestore = _FakeFirestoreService();

    await tester.pumpWidget(
      MyApp(
        authService: fakeAuth,
        firestoreService: fakeFirestore,
      ),
    );
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
