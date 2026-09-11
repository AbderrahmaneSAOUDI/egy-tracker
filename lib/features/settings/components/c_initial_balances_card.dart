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
import 'c_friend_balance_item.dart';
import 'c_initial_balances_resolver.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SectionCard(
      icon: Icons.account_balance_wallet_rounded,
      iconColor: isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight,
      title: 'Initial Balances',
      isCollapsible: true,
      initiallyExpanded: false,
      child: StreamBuilder<List<InitialBalance>>(
        stream: viewModel.initialBalancesStream,
        builder: (context, balancesSnap) {
          return StreamBuilder<List<AllowedEmail>>(
            stream: viewModel.allowedEmailsStream,
            builder: (context, emailsSnap) {
              return StreamBuilder<List<UserProfile>>(
                stream: viewModel.usersStream,
                builder: (context, usersSnap) {
                  final data = InitialBalancesData.resolve(
                    balances: balancesSnap.data ?? [],
                    emails: emailsSnap.data ?? [],
                    users: usersSnap.data ?? [],
                    user: user,
                  );

                  final myDisplayName =
                      resolveUserName(user, data.myProfile?.name);
                  final myPhotoUrl =
                      resolveUserPhoto(user, data.myProfile?.photoUrl);

                  return Column(
                    children: [
                      BalanceUserCard(
                        isCurrentUser: true,
                        name: myDisplayName,
                        email: user.email ?? '',
                        photoUrl: myPhotoUrl,
                        usdAmount: data.myBalance?.usdAmount ?? 0.0,
                        egpAmount: data.myBalance?.egpAmount ?? 0.0,
                        onEdit: () => showEditInitialBalancesDialog(
                          context: context,
                          userId: user.uid,
                          userName: myDisplayName,
                          currentUsd: data.myBalance?.usdAmount ?? 0.0,
                          currentEgp: data.myBalance?.egpAmount ?? 0.0,
                          onSave: viewModel.setInitialBalances,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FriendBalanceItem(
                        friendEmailDoc: data.friendEmailDoc,
                        friendDisplayName: data.friendDisplayName,
                        friendProfile: data.friendProfile,
                        friendBalance: data.friendBalance,
                        onEdit: data.friendUserId != null
                            ? () => showEditInitialBalancesDialog(
                                context: context,
                                userId: data.friendUserId!,
                                userName: data.friendDisplayName ?? 'Friend',
                                currentUsd: data.friendBalance?.usdAmount ?? 0.0,
                                currentEgp: data.friendBalance?.egpAmount ?? 0.0,
                                onSave: viewModel.setInitialBalances,
                              )
                            : null,
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
