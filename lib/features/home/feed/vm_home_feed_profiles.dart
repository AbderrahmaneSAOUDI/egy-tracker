import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';

/// Helper for resolving user profiles, emails, and initial balances.
class HomeFeedProfiles {
  static bool checkIsPrimaryUser(User user, List<AllowedEmail> allowedEmails) {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    if (myEmail == AppConfig.adminEmail) return true;
    if (allowedEmails.isEmpty) return true;
    return myEmail == allowedEmails.first.email.toLowerCase().trim();
  }

  static AllowedEmail? resolveFriendEmailDoc(User user, List<AllowedEmail> allowedEmails) {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final e in allowedEmails) {
      if (e.email.toLowerCase().trim() != myEmail) return e;
    }
    return null;
  }

  static UserProfile? resolveFriendProfile(AllowedEmail? friendEmailDoc, List<UserProfile> users) {
    if (friendEmailDoc == null) return null;
    final fe = friendEmailDoc.email.toLowerCase().trim();
    for (final u in users) {
      if (u.email.toLowerCase().trim() == fe) return u;
    }
    return null;
  }

  static UserProfile? resolveMyProfile(User user, List<UserProfile> users) {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final u in users) {
      if (u.id == user.uid || u.email.toLowerCase().trim() == myEmail) return u;
    }
    return null;
  }

  static InitialBalance? resolveMyInitialBalance(User user, List<InitialBalance> balances) {
    final myEmail = user.email?.toLowerCase().trim() ?? '';
    for (final b in balances) {
      if (b.userId == user.uid || b.userId.toLowerCase().trim() == myEmail) return b;
    }
    return null;
  }

  static InitialBalance? resolveFriendInitialBalance(
    UserProfile? friendProfile,
    AllowedEmail? friendEmailDoc,
    List<InitialBalance> balances,
  ) {
    final fp = friendProfile;
    final fe = friendEmailDoc?.email.toLowerCase().trim();
    for (final b in balances) {
      if (b.userId == fp?.id || (fe != null && b.userId.toLowerCase().trim() == fe)) {
        return b;
      }
    }
    return null;
  }
}
