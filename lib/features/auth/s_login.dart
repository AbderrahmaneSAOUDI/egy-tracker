import 'package:flutter/material.dart';
import '../../core/components/c_alert_banner.dart';
import '../../core/services/f_auth.dart';
import 'components/c_google_sign_in_button.dart';
import 'components/c_login_logo_button.dart';
import 'vm_auth.dart';

/// Screen (View) for signing in, backed by [AuthViewModel].
class LoginScreen extends StatefulWidget {
  final AuthService authService;
  final AuthViewModel? viewModel;

  const LoginScreen({
    super.key,
    required this.authService,
    this.viewModel,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = AuthViewModel(authService: widget.authService);
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon / Logo (Tap to auto-login)
                      LoginLogoButton(
                        onTap: _viewModel.isSigningIn
                            ? null
                            : () => _viewModel.handleAutoLogin(),
                      ),
                      const SizedBox(height: 16),

                      // App Title
                      Text(
                        'egy_tracker',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Error message banner
                      if (_viewModel.errorMessage != null) ...[
                        AlertBanner(
                          message: _viewModel.errorMessage!,
                          severity: AlertSeverity.error,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Google Sign In Button
                      GoogleSignInButton(
                        isSigningIn: _viewModel.isSigningIn,
                        onPressed: () => _viewModel.handleSignIn(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
