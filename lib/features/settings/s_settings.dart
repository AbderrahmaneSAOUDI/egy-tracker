import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/animations/a_fade_slide_transition.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';
import 'components/c_allowed_emails_card.dart';
import 'components/c_delete_data_card.dart';
import 'components/c_initial_balances_card.dart';
import 'components/c_settings_animations.dart';
import 'components/c_settings_profile_section.dart';
import 'components/c_theme_selector_card.dart';
import 'vm_settings.dart';

/// Screen (View) for Settings.
class SettingsScreen extends StatefulWidget {
  final User user;
  final AuthService authService;
  final FirestoreService firestoreService;
  final SettingsViewModel? viewModel;

  const SettingsScreen({
    super.key,
    required this.user,
    required this.authService,
    required this.firestoreService,
    this.viewModel,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final SettingsViewModel _viewModel;
  bool _ownsViewModel = false;
  late final SettingsAnimations _anims;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = SettingsViewModel(
        user: widget.user,
        authService: widget.authService,
        firestoreService: widget.firestoreService,
      );
      _ownsViewModel = true;
    }
    _anims = SettingsAnimations(this);
    _anims.forward();
  }

  @override
  void dispose() {
    _anims.dispose();
    if (_ownsViewModel) _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 90),
      children: [
        FadeSlideTransition(
          animation: _anims.profile,
          child: SettingsProfileSection(
            user: widget.user,
            viewModel: _viewModel,
          ),
        ),
        const SizedBox(height: 10),
        FadeSlideTransition(
          animation: _anims.theme,
          child: const ThemeSelectorCard(),
        ),
        const SizedBox(height: 10),
        FadeSlideTransition(
          animation: _anims.balances,
          child: InitialBalancesCard(
            user: widget.user,
            viewModel: _viewModel,
          ),
        ),
        const SizedBox(height: 10),
        FadeSlideTransition(
          animation: _anims.emails,
          child: AllowedEmailsCard(
            user: widget.user,
            viewModel: _viewModel,
          ),
        ),
        if (_viewModel.isSuperAdmin) ...[
          const SizedBox(height: 10),
          FadeSlideTransition(
            animation: _anims.data,
            child: DeleteDataCard(viewModel: _viewModel),
          ),
        ],
        const SizedBox(height: 24),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 44,
                height: 44,
                fit: BoxFit.contain,
                cacheWidth: 128,
                cacheHeight: 128,
              ),
              const SizedBox(height: 8),
              Text(
                'egy_tracker',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'Two-Currency Trip Expense Tracker',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.7),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
