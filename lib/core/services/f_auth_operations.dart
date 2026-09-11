import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'f_auth_google.dart';
import 'f_auth_sync.dart';

/// Helper methods for session restoration and Google sign-in workflows.
class AuthOperations {
  static Future<void> tryRestoreSession(FirebaseAuth firebaseAuth) async {
    try {
      if (kIsWeb) {
        await firebaseAuth.setPersistence(Persistence.LOCAL);
      } else if (firebaseAuth.currentUser == null) {
        await GoogleAuthHelper.ensureInitialized();
        final account = await GoogleAuthHelper.attemptLightweight();
        if (account != null && account.authentication.idToken != null) {
          final credential = GoogleAuthProvider.credential(
            idToken: account.authentication.idToken,
          );
          final userCredential = await firebaseAuth.signInWithCredential(credential);
          await syncProfileIfNeeded(
            userCredential.user,
            fallbackPhoto: account.photoUrl,
            fallbackName: account.displayName,
          );
        }
      }
    } catch (e) {
      debugPrint('Error restoring auth session: $e');
    }
  }

  static Future<UserCredential?> signInWithGoogle(FirebaseAuth firebaseAuth) async {
    if (kIsWeb) {
      await firebaseAuth.setPersistence(Persistence.LOCAL);
      final authProvider = GoogleAuthProvider();
      final userCredential = await firebaseAuth.signInWithPopup(authProvider);
      await syncProfileIfNeeded(userCredential.user);
      return userCredential;
    } else {
      await GoogleAuthHelper.ensureInitialized();
      final googleUser = await GoogleAuthHelper.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      await syncProfileIfNeeded(
        userCredential.user,
        fallbackPhoto: googleUser.photoUrl,
        fallbackName: googleUser.displayName,
      );
      return userCredential;
    }
  }
}
