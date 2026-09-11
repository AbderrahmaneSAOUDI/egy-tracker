import 'package:flutter/material.dart';
import '../../core/services/f_auth.dart';
import 'components/c_login_form.dart';
import 'vm_auth.dart';

export 'components/c_google_sign_in_button.dart';
export 'components/c_login_form.dart';
export 'components/c_login_logo_button.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) => LoginForm(viewModel: _viewModel),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
