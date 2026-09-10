import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Lightweight dev user for skipping Google login during development
class DevUser implements User {
  @override
  final String uid;

  @override
  final String? email;

  @override
  final String? displayName;

  @override
  final String? photoURL;

  @override
  final bool emailVerified;

  @override
  final bool isAnonymous;

  DevUser({
    this.uid = 'dev_user_saoudi',
    this.email = 'abderrahmane.saoudi.26@gmail.com',
    this.displayName = 'Abderrahmane Saoudi',
    this.photoURL =
        'https://lh3.googleusercontent.com/a/ACg8ocILd9gSXc_m2GUKRMU0ucOIVdzakbH63Mpk4tuzp817B_aUQMB0=s96-c',
    this.emailVerified = true,
    this.isAnonymous = false,
  });

  @override
  List<UserInfo> get providerData => [];

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> reload() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class AuthService {
  final FirebaseAuth? auth;
  static User? _devUser;
  static final StreamController<User?> _authController =
      StreamController<User?>.broadcast();

  static const String serverClientId =
      '27615434041-rpa8j2d54r5pkpmoctpu3oe48s5jfads.apps.googleusercontent.com';

  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (kIsWeb || _googleSignInInitialized) return;
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: serverClientId,
      );
      _googleSignInInitialized = true;
    } catch (e) {
      debugPrint('GoogleSignIn initialize caught error: $e');
    }
  }

  AuthService({this.auth, bool initializeGoogleSignIn = true}) {
    try {
      _firebaseAuth.authStateChanges().listen((user) {
        if (_devUser == null) {
          _authController.add(user);
        }
      });
    } catch (_) {}

    if (!kIsWeb && initializeGoogleSignIn) {
      _ensureGoogleSignInInitialized();
    }
  }

  FirebaseAuth get _firebaseAuth => auth ?? FirebaseAuth.instance;

  /// Stream to listen to auth state changes (immediately yields current state)
  Stream<User?> get authStateChanges async* {
    yield currentUser;
    yield* _authController.stream;
  }

  /// Get current user
  User? get currentUser => _devUser ?? _firebaseAuth.currentUser;

  /// Fast dev login skipping the Google popup and validating the email
  Future<User> signInAsDevUser([String email = 'abderrahmane.saoudi.26@gmail.com']) async {
    String? currentUid;
    String? currentDisplayName;
    String? currentPhotoURL;

    try {
      if (_firebaseAuth.currentUser == null) {
        await _firebaseAuth.signInAnonymously();
      }
      currentUid = _firebaseAuth.currentUser?.uid;
      currentDisplayName = _firebaseAuth.currentUser?.displayName;
      currentPhotoURL = _firebaseAuth.currentUser?.photoURL;
    } catch (e) {
      debugPrint('Anonymous auth fallback notice: $e');
    }

    final devUser = DevUser(
      uid: currentUid ?? 'dev_user_saoudi',
      email: email,
      displayName: currentDisplayName ?? 'Abderrahmane Saoudi',
      photoURL: currentPhotoURL ??
          'https://lh3.googleusercontent.com/a/ACg8ocILd9gSXc_m2GUKRMU0ucOIVdzakbH63Mpk4tuzp817B_aUQMB0=s96-c',
    );
    _devUser = devUser;
    _authController.add(devUser);
    return devUser;
  }

  /// Internal helper to sync photo and display name on first login across Web and Mobile
  Future<void> _syncProfileIfNeeded(User? user, {String? fallbackPhoto, String? fallbackName}) async {
    if (user == null) return;
    String? photo = user.photoURL ?? fallbackPhoto;
    String? name = user.displayName ?? fallbackName;
    if (photo == null || name == null) {
      for (final p in user.providerData) {
        photo ??= (p.photoURL?.isNotEmpty == true) ? p.photoURL : null;
        name ??= (p.displayName?.isNotEmpty == true) ? p.displayName : null;
      }
    }
    bool reload = false;
    if (user.photoURL == null && photo != null && photo.isNotEmpty) {
      try {
        await user.updatePhotoURL(photo);
        reload = true;
      } catch (_) {}
    }
    if (user.displayName == null && name != null && name.isNotEmpty) {
      try {
        await user.updateDisplayName(name);
        reload = true;
      } catch (_) {}
    }
    if (reload) {
      try {
        await user.reload();
      } catch (_) {}
    }
  }

  /// Restores existing session across app/web reopens
  Future<void> tryRestoreSession() async {
    try {
      if (kIsWeb) {
        await _firebaseAuth.setPersistence(Persistence.LOCAL);
      } else {
        if (_firebaseAuth.currentUser == null) {
          await _ensureGoogleSignInInitialized();
          final attempt = GoogleSignIn.instance.attemptLightweightAuthentication();
          if (attempt != null) {
            final account = await attempt;
            if (account != null && account.authentication.idToken != null) {
              final credential = GoogleAuthProvider.credential(
                idToken: account.authentication.idToken,
              );
              final userCredential = await _firebaseAuth.signInWithCredential(credential);
              await _syncProfileIfNeeded(userCredential.user, fallbackPhoto: account.photoUrl, fallbackName: account.displayName);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error restoring auth session: $e');
    }
  }

  /// Sign in with Google using platform-safe implementation
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        await _firebaseAuth.setPersistence(Persistence.LOCAL);
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(authProvider);
        await _syncProfileIfNeeded(userCredential.user);
        return userCredential;
      } else {
        await _ensureGoogleSignInInitialized();
        final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleUser.authentication.idToken,
        );
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        await _syncProfileIfNeeded(
          userCredential.user,
          fallbackPhoto: googleUser.photoUrl,
          fallbackName: googleUser.displayName,
        );
        return userCredential;
      }
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      rethrow;
    }
  }

  /// Sign out safely across Web and Mobile platforms
  Future<void> signOut() async {
    try {
      _devUser = null;
      _authController.add(null);
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }
}
