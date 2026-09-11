import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../../core/utils/m_auth_helpers.dart';
import '../vm_settings.dart';
import 'c_add_email_dialog.dart';
import 'c_allowed_email_tile.dart';
import 'c_confirm_delete_email_dialog.dart';

/// Renders the list of AllowedEmailTiles with user profile information.
class AllowedEmailsList extends StatelessWidget {
  final List<AllowedEmail> emails;
  final User user;
  final SettingsViewModel viewModel;

  const AllowedEmailsList({
    super.key,
    required this.emails,
    required this.user,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserProfile>>(
      stream: viewModel.usersStream,
      builder: (context, usersSnapshot) {
        final users = usersSnapshot.data ?? [];

        return Column(
          children: emails.map((allowed) {
            final normEmail = allowed.email.toLowerCase().trim();
            final isCurrentUser =
                normEmail == (user.email ?? '').toLowerCase().trim();

            UserProfile? matchingProfile;
            for (final u in users) {
              if (u.email.toLowerCase().trim() == normEmail) {
                matchingProfile = u;
                break;
              }
            }

            final photoUrl = isCurrentUser
                ? resolveUserPhoto(user, matchingProfile?.photoUrl)
                : matchingProfile?.photoUrl;
            final displayName = isCurrentUser
                ? resolveUserName(user, matchingProfile?.name)
                : matchingProfile?.name;

            return AllowedEmailTile(
              allowedEmail: allowed,
              isCurrentUser: isCurrentUser,
              photoUrl: photoUrl,
              displayName: displayName,
              onEdit: isCurrentUser
                  ? null
                  : () => showAddEmailDialog(
                        context: context,
                        initialEmail: allowed.email,
                        onAddEmail: (newEmail) async {
                          await viewModel.updateAllowedEmail(
                              allowed.id, newEmail);
                          return true;
                        },
                      ),
              onDelete: () => showConfirmDeleteEmailDialog(
                context: context,
                allowedEmail: allowed,
                isCurrentUser: isCurrentUser,
                onDeleteEmail: viewModel.deleteAllowedEmail,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
