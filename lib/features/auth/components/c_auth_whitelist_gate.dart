import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../../core/services/f_auth.dart';
import '../../../core/services/f_firestore.dart';
import '../../../core/utils/m_auth_helpers.dart';
import '../../home/s_home.dart';
import 'c_access_denied_screen.dart';

/// Verifies whether an authenticated user is on the allowed emails whitelist.
class AuthWhitelistGate extends StatefulWidget {
  final User user;
  final AuthService authService;
  final FirestoreService firestoreService;

  const AuthWhitelistGate({
    super.key,
    required this.user,
    required this.authService,
    required this.firestoreService,
  });

  @override
  State<AuthWhitelistGate> createState() => _AuthWhitelistGateState();
}

class _AuthWhitelistGateState extends State<AuthWhitelistGate> {
  late Future<bool> _whitelistFuture;

  @override
  void initState() {
    super.initState();
    _whitelistFuture = widget.firestoreService.isEmailAllowed(widget.user.email ?? '');
  }

  void _syncProfile() {
    final photoUrl = resolveUserPhoto(widget.user);
    final displayName = resolveUserName(widget.user);

    if (widget.user.photoURL == null && photoUrl != null) {
      try {
        widget.user.updatePhotoURL(photoUrl).then((_) => widget.user.reload()).catchError((_) {});
      } catch (_) {}
    }

    widget.firestoreService.saveUserProfile(
      UserProfile(
        id: widget.user.uid,
        name: displayName,
        email: widget.user.email ?? '',
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      ),
    ).catchError((e) => debugPrint('saveUserProfile notice: $e'));
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.user.email?.toLowerCase().trim() ?? '';
    final isDefaultAllowed = email == AppConfig.adminEmail;

    return FutureBuilder<bool>(
      future: _whitelistFuture,
      builder: (context, snapshot) {
        final isAllowed = snapshot.data ?? isDefaultAllowed;

        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting &&
            !isDefaultAllowed) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Verifying trip authorization...'),
                ],
              ),
            ),
          );
        }

        if (isAllowed) {
          _syncProfile();
          return HomeScreen(
            key: const PageStorageKey('home_screen_root'),
            user: widget.user,
            authService: widget.authService,
            firestoreService: widget.firestoreService,
          );
        }

        return AccessDeniedScreen(
          email: widget.user.email ?? '',
          onSignOut: () => widget.authService.signOut(),
        );
      },
    );
  }
}
