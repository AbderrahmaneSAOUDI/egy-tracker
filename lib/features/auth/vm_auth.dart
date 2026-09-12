import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/config/app_config.dart';
import '../../core/services/f_auth.dart';

/// ViewModel managing authentication state and Google / Dev sign-in flows.
class AuthViewModel extends ChangeNotifier {
  final AuthService authService;

  bool _isSigningIn = false;
  bool _isVerifying = false;
  String? _verificationMessage;
  String? _errorMessage;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  AuthViewModel({
    required this.authService,
    bool isVerifying = false,
    String? verificationMessage,
    String? errorMessage,
  })  : _isVerifying = isVerifying,
        _verificationMessage = verificationMessage,
        _errorMessage = errorMessage;

  bool get isSigningIn => _isSigningIn;
  bool get isVerifying => _isVerifying;
  String? get verificationMessage => _verificationMessage;
  String? get errorMessage => _errorMessage;
  User? get currentUser => authService.currentUser;
  Stream<User?> get authStateChanges => authService.authStateChanges;

  void setVerifying(bool verifying, [String? message]) {
    _isVerifying = verifying;
    _verificationMessage = message;
    notifyListeners();
  }

  void setErrorMessage(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> handleAutoLogin() async {
    // SECURITY: Dev login is disabled in release builds (Fix 1.5.3)
    if (!kDebugMode) return;

    _isSigningIn = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authService.signInAsDevUser(AppConfig.adminEmail);
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
