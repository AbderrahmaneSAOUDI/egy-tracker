import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/c_alert_banner.dart';
import '../../../core/components/c_empty_state.dart';
import '../../../core/components/c_section_card.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/theme/t_app_theme.dart';
import '../vm_settings.dart';
import 'c_add_email_dialog.dart';
import 'c_allowed_emails_list.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSuperAdmin = viewModel.isSuperAdmin;

    return SectionCard(
      icon: Icons.shield_rounded,
      iconColor: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
      title: 'Allowed Emails',
      subtitle: isSuperAdmin ? null : 'View-only access',
      isCollapsible: true,
      initiallyExpanded: false,
      trailing: isSuperAdmin
          ? FilledButton.icon(
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
            )
          : null,
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

          final rawEmails = snapshot.data ?? [];
          // Deduplicate by normalized email address to guarantee no duplicates appear
          final seen = <String>{};
          final emails = rawEmails.where((e) {
            final key = e.email.toLowerCase().trim();
            return seen.add(key);
          }).toList();

          if (emails.isEmpty) {
            return EmptyState(
              icon: Icons.mail_outline_rounded,
              title: 'No allowed emails yet',
              iconColor: isDark
                  ? AppTheme.googleBlueDark
                  : AppTheme.googleBlue,
            );
          }

          return AllowedEmailsList(
            emails: emails,
            user: user,
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}
