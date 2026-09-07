import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/c_alert_banner.dart';
import '../../../core/components/c_empty_state.dart';
import '../../../core/components/c_section_card.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/theme/t_app_theme.dart';
import '../vm_settings.dart';
import 'c_add_email_dialog.dart';
import 'c_allowed_email_tile.dart';
import 'c_confirm_delete_email_dialog.dart';

/// Card managing the allowed email whitelist for access gating.
class AllowedEmailsCard extends StatelessWidget {
  final User user;
  final SettingsViewModel viewModel;

  const AllowedEmailsCard({
    super.key,
    required this.user,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SectionCard(
      icon: Icons.shield_rounded,
      iconColor: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
      title: 'Allowed Emails',
      subtitle: 'Authorized Google accounts',
      trailing: FilledButton.icon(
        onPressed: () => showAddEmailDialog(
          context: context,
          onAddEmail: viewModel.addAllowedEmail,
        ),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Add'),
        style: FilledButton.styleFrom(
          backgroundColor:
              isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          minimumSize: const Size(0, 36),
          elevation: 0,
        ),
      ),
      child: StreamBuilder<List<AllowedEmail>>(
        stream: viewModel.allowedEmailsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return AlertBanner(
              message: 'Error loading whitelist: ${snapshot.error}',
              severity: AlertSeverity.error,
            );
          }

          final emails = snapshot.data ?? [];
          if (emails.isEmpty) {
            return EmptyState(
              icon: Icons.mail_outline_rounded,
              title: 'No allowed emails yet',
              subtitle: 'Tap "+ Add" to authorize your first travel partner.',
              iconColor: isDark
                  ? AppTheme.googleBlueDark
                  : AppTheme.googleBlue,
            );
          }

          return Column(
            children: emails.map((allowed) {
              final isCurrentUser = allowed.email.toLowerCase() ==
                  (user.email ?? '').toLowerCase();

              return AllowedEmailTile(
                allowedEmail: allowed,
                isCurrentUser: isCurrentUser,
                currentUserPhotoUrl: user.photoURL,
                currentUserName: user.displayName,
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
      ),
    );
  }
}
