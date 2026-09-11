import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/components/c_alert_banner.dart';
import '../vm_auth.dart';
import 'c_google_sign_in_button.dart';
import 'c_login_logo_button.dart';

/// Form body for the login screen.
class LoginForm extends StatelessWidget {
  final AuthViewModel viewModel;

  const LoginForm({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginLogoButton(
          onTap: (!kDebugMode || viewModel.isSigningIn)
              ? null
              : () => viewModel.handleAutoLogin(),
        ),
        const SizedBox(height: 16),
        Text(
          'egy_tracker',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 24),
        if (viewModel.errorMessage != null) ...[
          AlertBanner(
            message: viewModel.errorMessage!,
            severity: AlertSeverity.error,
          ),
          const SizedBox(height: 16),
        ],
        GoogleSignInButton(
          isSigningIn: viewModel.isSigningIn,
          onPressed: () => viewModel.handleSignIn(),
        ),
      ],
    );
  }
}
