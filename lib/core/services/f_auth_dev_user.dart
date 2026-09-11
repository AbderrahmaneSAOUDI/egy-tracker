import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

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
    this.email = AppConfig.adminEmail,
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

Future<User> signInAsDevUserHelper(
  FirebaseAuth? firebaseAuth,
  StreamController<User?> authController, [
  String email = AppConfig.adminEmail,
]) async {
  String? currentUid;
  String? currentDisplayName;
  String? currentPhotoURL;

  if (firebaseAuth != null) {
    try {
      if (firebaseAuth.currentUser == null) {
        await firebaseAuth.signInAnonymously();
      }
      currentUid = firebaseAuth.currentUser?.uid;
      currentDisplayName = firebaseAuth.currentUser?.displayName;
      currentPhotoURL = firebaseAuth.currentUser?.photoURL;
    } catch (e) {
      debugPrint('Anonymous auth fallback notice: $e');
    }
  }

  final devUser = DevUser(
    uid: currentUid ?? 'dev_user_saoudi',
    email: email,
    displayName: currentDisplayName ?? 'Abderrahmane Saoudi',
    photoURL: currentPhotoURL ??
        'https://lh3.googleusercontent.com/a/ACg8ocILd9gSXc_m2GUKRMU0ucOIVdzakbH63Mpk4tuzp817B_aUQMB0=s96-c',
  );
  authController.add(devUser);
  return devUser;
}
