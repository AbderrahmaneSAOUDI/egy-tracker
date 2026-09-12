import 'package:flutter/material.dart';
import '../../core/services/f_auth.dart';
import 'components/c_animated_login_background.dart';
import 'components/c_login_form.dart';
import 'vm_auth.dart';

export 'components/c_animated_login_background.dart';
export 'components/c_google_sign_in_button.dart';
export 'components/c_login_form.dart';
export 'components/c_login_logo_button.dart';
export '../../core/components/c_google_progress_bar.dart';

/// Screen (View) for signing in, backed by [AuthViewModel] and framed with
/// an ambient looping animated background.
class LoginScreen extends StatefulWidget {
  final AuthService authService;
  final AuthViewModel? viewModel;
  final bool? enableLoopAnimation;
  final bool isVerifying;
  final String? verificationMessage;
  final String? errorMessage;

  const LoginScreen({
    super.key,
    required this.authService,
    this.viewModel,
    this.enableLoopAnimation,
    this.isVerifying = false,
    this.verificationMessage,
    this.errorMessage,
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
      _viewModel = AuthViewModel(
        authService: widget.authService,
        isVerifying: widget.isVerifying,
        verificationMessage: widget.verificationMessage,
        errorMessage: widget.errorMessage,
      );
      _ownsViewModel = true;
    }
  }

  @override
  void didUpdateWidget(LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVerifying != oldWidget.isVerifying ||
        widget.verificationMessage != oldWidget.verificationMessage) {
      _viewModel.setVerifying(widget.isVerifying, widget.verificationMessage);
    }
    if (widget.errorMessage != oldWidget.errorMessage) {
      _viewModel.setErrorMessage(widget.errorMessage);
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedLoginBackground(
            enableLoopAnimation: widget.enableLoopAnimation,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) => LoginForm(
                      viewModel: _viewModel,
                      isVerifying: widget.isVerifying,
                      verificationMessage: widget.verificationMessage,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
