import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/models/mod_user_profile.dart';
import '../vm_settings.dart';
import 'c_profile_card.dart';

/// Renders the user profile section connected to the users stream.
class SettingsProfileSection extends StatelessWidget {
  final User user;
  final SettingsViewModel viewModel;

  const SettingsProfileSection({
    super.key,
    required this.user,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserProfile>>(
      stream: viewModel.usersStream,
      builder: (context, snapshot) {
        UserProfile? myProfile;
        if (snapshot.hasData) {
          final uid = user.uid;
          final email = user.email?.toLowerCase().trim();
          for (final p in snapshot.data!) {
            if (p.id == uid || (email != null && p.email == email)) {
              myProfile = p;
              break;
            }
          }
        }
        return ProfileCard(
          user: user,
          photoUrl: myProfile?.photoUrl,
          displayName: myProfile?.name,
          onSignOut: viewModel.signOut,
        );
      },
    );
  }
}
