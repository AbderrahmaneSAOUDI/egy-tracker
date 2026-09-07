import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/c_section_card.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_auth_helpers.dart';
import '../vm_settings.dart';
import 'c_balance_user_card.dart';
import 'c_edit_initial_balances_dialog.dart';

/// Card containing starting cash configurations for You and Friend.
class InitialBalancesCard extends StatelessWidget {
  final User user;
  final SettingsViewModel viewModel;

  const InitialBalancesCard({
    super.key,
    required this.user,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SectionCard(
      icon: Icons.account_balance_wallet_rounded,
      iconColor: isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight,
      title: 'Initial Balances',
      child: StreamBuilder<List<InitialBalance>>(
        stream: viewModel.initialBalancesStream,
        builder: (context, balancesSnap) {
          return StreamBuilder<List<AllowedEmail>>(
            stream: viewModel.allowedEmailsStream,
            builder: (context, emailsSnap) {
              return StreamBuilder<List<UserProfile>>(
                stream: viewModel.usersStream,
                builder: (context, usersSnap) {
                  final balances = balancesSnap.data ?? [];
                  final emails = emailsSnap.data ?? [];
                  final users = usersSnap.data ?? [];

                  // Current user balance lookup
                  final myEmail = (user.email ?? '').toLowerCase().trim();
                  InitialBalance? myBalance;
                  for (final b in balances) {
                    if (b.userId == user.uid ||
                        b.userId.toLowerCase().trim() == myEmail) {
                      myBalance = b;
                      break;
                    }
                  }

                  // Current user profile resolution
                  UserProfile? myProfile;
                  for (final u in users) {
                    if (u.id == user.uid || u.email.toLowerCase().trim() == myEmail) {
                      myProfile = u;
                      break;
                    }
                  }

                  // Friend resolution from whitelist
                  AllowedEmail? friendEmailDoc;
                  for (final e in emails) {
                    if (e.email.toLowerCase().trim() != myEmail) {
                      friendEmailDoc = e;
                      break;
                    }
                  }

                  UserProfile? friendProfile;
                  if (friendEmailDoc != null) {
                    final fe = friendEmailDoc.email.toLowerCase().trim();
                    for (final u in users) {
                      if (u.email.toLowerCase().trim() == fe) {
                        friendProfile = u;
                        break;
                      }
                    }
                  }

                  InitialBalance? friendBalance;
                  String? friendUserId;
                  String? friendDisplayName;
                  if (friendEmailDoc != null) {
                    final fe = friendEmailDoc.email.toLowerCase().trim();
                    friendUserId = friendProfile?.id ?? fe;
                    friendDisplayName = (friendProfile != null &&
                            friendProfile.name.isNotEmpty)
                        ? friendProfile.name
                        : friendEmailDoc.email;

                    for (final b in balances) {
                      if (b.userId == friendProfile?.id ||
                          b.userId.toLowerCase().trim() == fe) {
                        friendBalance = b;
                        break;
                      }
                    }
                  }

                  final myDisplayName = resolveUserName(user, myProfile?.name);
                  final myPhotoUrl = resolveUserPhoto(user, myProfile?.photoUrl);

                  return Column(
                    children: [
                      // 1. You Starting Balance Item
                      BalanceUserCard(
                        isCurrentUser: true,
                        name: myDisplayName,
                        email: user.email ?? '',
                        photoUrl: myPhotoUrl,
                        usdAmount: myBalance?.usdAmount ?? 0.0,
                        egpAmount: myBalance?.egpAmount ?? 0.0,
                        onEdit: () => showEditInitialBalancesDialog(
                          context: context,
                          userId: user.uid,
                          userName: myDisplayName,
                          currentUsd: myBalance?.usdAmount ?? 0.0,
                          currentEgp: myBalance?.egpAmount ?? 0.0,
                          onSave: viewModel.setInitialBalances,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 2. Friend Starting Balance Item
                      if (friendEmailDoc != null)
                        BalanceUserCard(
                          isCurrentUser: false,
                          name: friendDisplayName!,
                          email: friendEmailDoc.email,
                          photoUrl: friendProfile?.photoUrl,
                          usdAmount: friendBalance?.usdAmount ?? 0.0,
                          egpAmount: friendBalance?.egpAmount ?? 0.0,
                          onEdit: () => showEditInitialBalancesDialog(
                            context: context,
                            userId: friendUserId!,
                            userName: friendDisplayName!,
                            currentUsd: friendBalance?.usdAmount ?? 0.0,
                            currentEgp: friendBalance?.egpAmount ?? 0.0,
                            onSave: viewModel.setInitialBalances,
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.02)
                                : Colors.black.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_add_alt_1_outlined,
                                size: 20,
                                color: colorScheme.outline,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Add your travel partner in Allowed Emails below to configure their starting cash.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
