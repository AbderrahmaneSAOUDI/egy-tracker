import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/models/mod_user_profile.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';
import '../home/s_home.dart';
import 's_login.dart';

class AuthGate extends StatefulWidget {
  final AuthService authService;
  final FirestoreService firestoreService;

  const AuthGate({
    super.key,
    required this.authService,
    required this.firestoreService,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Stream<User?> _authStream;
  String? _cachedUserId;
  String? _cachedEmail;
  Future<bool>? _whitelistFuture;

  @override
  void initState() {
    super.initState();
    _authStream = widget.authService.authStateChanges;
  }

  @override
  void didUpdateWidget(AuthGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authService != widget.authService) {
      _authStream = widget.authService.authStateChanges;
    }
  }

  Future<bool> _getWhitelistFuture(User user) {
    final email = user.email ?? '';
    if (_cachedUserId == user.uid &&
        _cachedEmail == email &&
        _whitelistFuture != null) {
      return _whitelistFuture!;
    }
    _cachedUserId = user.uid;
    _cachedEmail = email;
    _whitelistFuture = widget.firestoreService.isEmailAllowed(email);
    return _whitelistFuture!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      initialData: widget.authService.currentUser,
      stream: _authStream,
      builder: (context, snapshot) {
        final user = snapshot.data ?? widget.authService.currentUser;
        if (user == null) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          _cachedUserId = null;
          _cachedEmail = null;
          _whitelistFuture = null;
          return LoginScreen(authService: widget.authService);
        }

        return _buildWhitelistCheck(context, user);
      },
    );
  }

  Widget _buildWhitelistCheck(BuildContext context, User user) {
    final isDefaultAllowed =
        user.email?.toLowerCase().trim() == 'abderrahmane.saoudi.26@gmail.com';

    return FutureBuilder<bool>(
      future: _getWhitelistFuture(user),
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
          // Sync profile to Firestore
          widget.firestoreService.saveUserProfile(
            UserProfile(
              id: user.uid,
              name: user.displayName ?? user.email?.split('@').first ?? 'Traveler',
              email: user.email ?? '',
              photoUrl: user.photoURL,
              createdAt: DateTime.now(),
            ),
          ).catchError((e) {
            debugPrint('saveUserProfile notice: $e');
          });

          return HomeScreen(
            key: const PageStorageKey('home_screen_root'),
            user: user,
            authService: widget.authService,
            firestoreService: widget.firestoreService,
          );
        }

        return _buildAccessDeniedScreen(context, user);
      },
    );
  }

  Widget _buildAccessDeniedScreen(BuildContext context, User user) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.gpp_bad_rounded,
                    size: 44,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Unauthorized Account',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The account "${user.email}" is not on the whitelist for this Egypt trip.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => widget.authService.signOut(),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
