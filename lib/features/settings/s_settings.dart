import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/animations/a_fade_slide_transition.dart';
import '../../core/models/mod_user_profile.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';
import 'components/c_allowed_emails_card.dart';
import 'components/c_delete_data_card.dart';
import 'components/c_initial_balances_card.dart';
import 'components/c_profile_card.dart';
import 'components/c_theme_selector_card.dart';
import 'vm_settings.dart';

/// Screen (View) for Settings, orchestrating staggered entrance animations
/// and assembling isolated cards backed by [SettingsViewModel].
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

  late AnimationController _animController;
  late Animation<double> _profileAnim;
  late Animation<double> _themeAnim;
  late Animation<double> _balancesAnim;
  late Animation<double> _emailsAnim;
  late Animation<double> _dataAnim;

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

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _profileAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.40, curve: Curves.easeOutCubic),
    );

    _themeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
    );

    _balancesAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.30, 0.70, curve: Curves.easeOutCubic),
    );

    _emailsAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
    );

    _dataAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.60, 1.0, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        // ===================== SECTION 1: USER PROFILE HERO =====================
        FadeSlideTransition(
          animation: _profileAnim,
          child: StreamBuilder<List<UserProfile>>(
            stream: _viewModel.usersStream,
            builder: (context, snapshot) {
              UserProfile? myProfile;
              if (snapshot.hasData) {
                final uid = widget.user.uid;
                final email = widget.user.email?.toLowerCase().trim();
                for (final p in snapshot.data!) {
                  if (p.id == uid || (email != null && p.email == email)) {
                    myProfile = p;
                    break;
                  }
                }
              }
              return ProfileCard(
                user: widget.user,
                photoUrl: myProfile?.photoUrl,
                displayName: myProfile?.name,
                onSignOut: _viewModel.signOut,
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // ===================== SECTION 2: THEME SELECTOR =====================
        FadeSlideTransition(
          animation: _themeAnim,
          child: const ThemeSelectorCard(),
        ),
        const SizedBox(height: 16),

        // ===================== SECTION 3: INITIAL BALANCES =====================
        FadeSlideTransition(
          animation: _balancesAnim,
          child: InitialBalancesCard(
            user: widget.user,
            viewModel: _viewModel,
          ),
        ),
        const SizedBox(height: 16),

        // ===================== SECTION 4: ALLOWED EMAILS WHITELIST =====================
        FadeSlideTransition(
          animation: _emailsAnim,
          child: AllowedEmailsCard(
            user: widget.user,
            viewModel: _viewModel,
          ),
        ),
        const SizedBox(height: 16),

        // ===================== SECTION 5: DATA LIFECYCLE / RESET =====================
        FadeSlideTransition(
          animation: _dataAnim,
          child: DeleteDataCard(
            viewModel: _viewModel,
          ),
        ),
      ],
    );
  }
}
