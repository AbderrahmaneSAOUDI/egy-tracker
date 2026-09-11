import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'f_auth_dev_user.dart';
import 'f_auth_google.dart';
import 'f_auth_operations.dart';

export 'f_auth_dev_user.dart';
export 'f_auth_google.dart';
export 'f_auth_operations.dart';
export 'f_auth_sync.dart';

class AuthService {
  final FirebaseAuth? auth;
  static User? _devUser;
  final StreamController<User?> _authController =
      StreamController<User?>.broadcast();
  StreamSubscription<User?>? _authSubscription;

  static const String serverClientId = AppConfig.serverClientId;

  AuthService({this.auth, bool initializeGoogleSignIn = true}) {
    try {
      _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
        if (_devUser == null) {
          _authController.add(user);
        }
      });
    } catch (_) {}

    if (!kIsWeb && initializeGoogleSignIn) {
      GoogleAuthHelper.ensureInitialized();
    }
  }

  FirebaseAuth get _firebaseAuth => auth ?? FirebaseAuth.instance;

  FirebaseAuth? get _safeAuth {
    try {
      return auth ?? FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get authStateChanges async* {
    yield currentUser;
    yield* _authController.stream;
  }

  User? get currentUser {
    if (_devUser != null) return _devUser;
    try {
      return _firebaseAuth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<User> signInAsDevUser([String email = AppConfig.adminEmail]) async {
    final devUser = await signInAsDevUserHelper(_safeAuth, _authController, email);
    _devUser = devUser;
    return devUser;
  }

  Future<void> tryRestoreSession() => AuthOperations.tryRestoreSession(_firebaseAuth);

  Future<UserCredential?> signInWithGoogle() => AuthOperations.signInWithGoogle(_firebaseAuth);

  Future<void> signOut() async {
    _devUser = null;
    _authController.add(null);
    await GoogleAuthHelper.signOut();
    await _firebaseAuth.signOut();
  }

  void dispose() {
    _authSubscription?.cancel();
    _authController.close();
  }
}
