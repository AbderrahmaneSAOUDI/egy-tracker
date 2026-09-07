import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/f_auth.dart';

/// ViewModel managing authentication state and Google / Dev sign-in flows.
class AuthViewModel extends ChangeNotifier {
  final AuthService authService;

  bool _isSigningIn = false;
  String? _errorMessage;

  AuthViewModel({required this.authService});

  bool get isSigningIn => _isSigningIn;
  String? get errorMessage => _errorMessage;
  User? get currentUser => authService.currentUser;
  Stream<User?> get authStateChanges => authService.authStateChanges;

  Future<void> handleAutoLogin() async {
    _isSigningIn = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authService.signInAsDevUser('abderrahmane.saoudi.26@gmail.com');
    } catch (e) {
      _errorMessage = 'Auto-login failed: ${e.toString()}';
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> handleSignIn() async {
    _isSigningIn = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authService.tryRestoreSession();
      if (authService.currentUser != null) {
        _isSigningIn = false;
        notifyListeners();
        return;
      }

      await authService.signInWithGoogle();
    } catch (e) {
      _errorMessage = 'Sign-in failed: ${e.toString()}';
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}
