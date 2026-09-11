import 'package:firebase_auth/firebase_auth.dart';

/// Syncs photo and display name on first login across Web and Mobile
Future<void> syncProfileIfNeeded(
  User? user, {
  String? fallbackPhoto,
  String? fallbackName,
}) async {
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
