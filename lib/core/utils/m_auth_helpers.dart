import 'package:firebase_auth/firebase_auth.dart';

/// Pure Dart utility functions for reliably extracting user metadata
/// across Firebase root User properties, Google provider data, and fallback values.

/// Resolves user's photo URL by inspecting:
/// 1. Direct [user.photoURL]
/// 2. [user.providerData] list (Google account photo URL)
/// 3. Optional [fallbackUrl] (e.g. from Firestore user profile)
String? resolveUserPhoto(User? user, [String? fallbackUrl]) {
  if (user != null && user.photoURL != null && user.photoURL!.trim().isNotEmpty) {
    return user.photoURL!.trim();
  }

  if (user != null) {
    try {
      for (final profile in user.providerData) {
        if (profile.photoURL != null && profile.photoURL!.trim().isNotEmpty) {
          return profile.photoURL!.trim();
        }
      }
    } catch (_) {}
  }

  if (fallbackUrl != null && fallbackUrl.trim().isNotEmpty) {
    return fallbackUrl.trim();
  }

  return null;
}

/// Resolves user's display name by inspecting:
/// 1. Direct [user.displayName]
/// 2. [user.providerData] list (Google account display name)
/// 3. Optional [fallbackName] (e.g. from Firestore user profile)
/// 4. Email prefix before '@'
/// 5. Defaults to 'Traveler'
String resolveUserName(User? user, [String? fallbackName]) {
  if (user != null && user.displayName != null && user.displayName!.trim().isNotEmpty) {
    return user.displayName!.trim();
  }

  if (user != null) {
    try {
      for (final profile in user.providerData) {
        if (profile.displayName != null && profile.displayName!.trim().isNotEmpty) {
          return profile.displayName!.trim();
        }
      }
    } catch (_) {}
  }

  if (fallbackName != null && fallbackName.trim().isNotEmpty) {
    return fallbackName.trim();
  }

  if (user != null && user.email != null && user.email!.trim().isNotEmpty) {
    return user.email!.trim().split('@').first;
  }

  return 'Traveler';
}
