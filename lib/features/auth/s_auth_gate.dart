import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';
import 'components/c_auth_whitelist_gate.dart';
import 's_login.dart';

export 'components/c_access_denied_screen.dart';
export 'components/c_auth_whitelist_gate.dart';

/// Top-level authentication gate handling auth state changes and whitelist checks.
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
          return LoginScreen(authService: widget.authService);
        }

        return AuthWhitelistGate(
          key: ValueKey(user.uid),
          user: user,
          authService: widget.authService,
          firestoreService: widget.firestoreService,
        );
      },
    );
  }
}
