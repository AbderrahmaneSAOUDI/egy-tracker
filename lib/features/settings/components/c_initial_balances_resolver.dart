import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';

/// Resolved balance and profile data for initial balances view.
class InitialBalancesData {
  final InitialBalance? myBalance;
  final UserProfile? myProfile;
  final AllowedEmail? friendEmailDoc;
  final UserProfile? friendProfile;
  final InitialBalance? friendBalance;
  final String? friendDisplayName;
  final String? friendUserId;

  const InitialBalancesData({
    this.myBalance,
    this.myProfile,
    this.friendEmailDoc,
    this.friendProfile,
    this.friendBalance,
    this.friendDisplayName,
    this.friendUserId,
  });

  static InitialBalancesData resolve({
    required List<InitialBalance> balances,
    required List<AllowedEmail> emails,
    required List<UserProfile> users,
    required User user,
  }) {
    final myEmail = (user.email ?? '').toLowerCase().trim();

    InitialBalance? myBalance;
    for (final b in balances) {
      if (b.userId == user.uid || b.userId.toLowerCase().trim() == myEmail) {
        myBalance = b;
        break;
      }
    }

    UserProfile? myProfile;
    for (final u in users) {
      if (u.id == user.uid || u.email.toLowerCase().trim() == myEmail) {
        myProfile = u;
        break;
      }
    }

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
    String? friendDisplayName;
    if (friendEmailDoc != null) {
      final fe = friendEmailDoc.email.toLowerCase().trim();
      friendDisplayName = (friendProfile != null && friendProfile.name.isNotEmpty)
          ? friendProfile.name
          : friendEmailDoc.email;

      for (final b in balances) {
        if (b.userId == friendProfile?.id || b.userId.toLowerCase().trim() == fe) {
          friendBalance = b;
          break;
        }
      }
    }

    final friendUserId =
        friendProfile?.id ?? friendEmailDoc?.email.toLowerCase().trim();

    return InitialBalancesData(
      myBalance: myBalance,
      myProfile: myProfile,
      friendEmailDoc: friendEmailDoc,
      friendProfile: friendProfile,
      friendBalance: friendBalance,
      friendDisplayName: friendDisplayName,
      friendUserId: friendUserId,
    );
  }
}
