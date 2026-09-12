import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/config/app_config.dart';
import '../../core/models/mod_allowed_email.dart';
import '../../core/models/mod_initial_balance.dart';
import '../../core/models/mod_user_profile.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';
import '../../core/utils/m_auth_helpers.dart';

/// ViewModel managing settings actions: initial balances, whitelist emails,
/// user profile display name editing, and the complete data wipe protocol.
class SettingsViewModel extends ChangeNotifier {
  final User user;
  final AuthService authService;
  final FirestoreService firestoreService;

  bool _isProcessing = false;
  String? _errorMessage;

  SettingsViewModel({
    required this.user,
    required this.authService,
    required this.firestoreService,
  });

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  bool get isSuperAdmin =>
      (user.email ?? '').toLowerCase().trim() == AppConfig.adminEmail.toLowerCase().trim();

  Stream<List<UserProfile>> get usersStream =>
      firestoreService.getUsersStream();
  Stream<List<AllowedEmail>> get allowedEmailsStream =>
      firestoreService.getAllowedEmailsStream();
  Stream<List<InitialBalance>> get initialBalancesStream =>
      firestoreService.getInitialBalancesStream();

  Future<bool> updateAllowedEmail(String id, String email) {
    if (!isSuperAdmin) {
      _errorMessage = 'Only the super admin can update allowed emails.';
      notifyListeners();
      return Future.value(false);
    }
    return _run(
        'Failed to update email',
        () => firestoreService.updateAllowedEmail(id, email.trim().toLowerCase()));
  }

  Future<bool> addAllowedEmail(String email) {
    if (!isSuperAdmin) {
      _errorMessage = 'Only the super admin can add allowed emails.';
      notifyListeners();
      return Future.value(false);
    }
    return _run(
        'Failed to add email',
        () => firestoreService.addAllowedEmail(email.trim().toLowerCase()));
  }

  Future<bool> deleteAllowedEmail(String id) {
    if (!isSuperAdmin) {
      _errorMessage = 'Only the super admin can delete allowed emails.';
      notifyListeners();
      return Future.value(false);
    }
    return _run(
        'Failed to delete email', () => firestoreService.deleteAllowedEmail(id));
  }

  Future<bool> setInitialBalances({
    required String userId,
    required double usdAmount,
    required double egpAmount,
  }) => _run('Failed to update starting cash', () =>
          firestoreService.setInitialBalances(
            userId: userId, usdAmount: usdAmount, egpAmount: egpAmount));

  Future<bool> updateDisplayName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return false;
    return _run('Failed to update profile name', () async {
      await user.updateDisplayName(trimmed);
      await firestoreService.saveUserProfile(UserProfile(
        id: user.uid, name: trimmed, email: user.email ?? '',
        photoUrl: resolveUserPhoto(user), createdAt: DateTime.now(),
      ));
    });
  }

  Future<bool> deleteTripData({
    bool deleteExpenses = true,
    bool deleteExchanges = true,
    bool deleteBorrows = true,
    bool deleteInitialBalances = true,
    bool deleteFriends = true,
  }) {
    if (!isSuperAdmin) {
      _errorMessage = 'Only the super admin can delete trip data.';
      notifyListeners();
      return Future.value(false);
    }
    return _run('Failed to delete data', () => firestoreService.deleteTripData(
          deleteExpenses: deleteExpenses, deleteExchanges: deleteExchanges,
          deleteBorrows: deleteBorrows, deleteInitialBalances: deleteInitialBalances,
          deleteFriends: deleteFriends, keepEmail: user.email, keepUserId: user.uid,
        ));
  }

  Future<bool> deleteAllTripData() => deleteTripData();

  Future<void> signOut() => authService.signOut();

  Future<bool> _run(String errorPrefix, Future<void> Function() action) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '$errorPrefix: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
