import '../../../core/config/app_config.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';

/// Helper class for resolving user and friend profiles in My Tracker.
class MyTrackerProfiles {
  static AllowedEmail? findFriendEmailDoc(
    List<AllowedEmail> allowedEmails,
    String myEmail,
  ) {
    final cleanEmail = myEmail.toLowerCase().trim();
    for (final e in allowedEmails) {
      if (e.email.toLowerCase().trim() != cleanEmail) return e;
    }
    return null;
  }

  static UserProfile? findFriendProfile(
    List<UserProfile> users,
    AllowedEmail? friendDoc,
  ) {
    if (friendDoc == null) return null;
    final fe = friendDoc.email.toLowerCase().trim();
    for (final u in users) {
      if (u.email.toLowerCase().trim() == fe) return u;
    }
    return null;
  }

  static UserProfile? findMyProfile(
    List<UserProfile> users,
    String myUid,
    String myEmail,
  ) {
    final cleanEmail = myEmail.toLowerCase().trim();
    for (final u in users) {
      if (u.id == myUid || u.email.toLowerCase().trim() == cleanEmail) return u;
    }
    return null;
  }

  static InitialBalance? findMyInitialBalance(
    List<InitialBalance> balances,
    String myUid,
    String myEmail,
  ) {
    final cleanEmail = myEmail.toLowerCase().trim();
    for (final b in balances) {
      if (b.userId == myUid || b.userId.toLowerCase().trim() == cleanEmail) {
        return b;
      }
    }
    return null;
  }

  static bool checkIsPrimaryUser(
    String myEmail,
    List<AllowedEmail> allowedEmails,
  ) {
    final cleanEmail = myEmail.toLowerCase().trim();
    if (cleanEmail == AppConfig.adminEmail) return true;
    if (allowedEmails.isEmpty) return true;
    return cleanEmail == allowedEmails.first.email.toLowerCase().trim();
  }
}
