import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/models/mod_allowed_email.dart';
import '../../core/models/mod_initial_balance.dart';
import '../../core/models/mod_user_profile.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';

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

  // Streams
  Stream<List<UserProfile>> get usersStream => firestoreService.getUsersStream();
  Stream<List<AllowedEmail>> get allowedEmailsStream => firestoreService.getAllowedEmailsStream();
  Stream<List<InitialBalance>> get initialBalancesStream => firestoreService.getInitialBalancesStream();

  /// Adds a new email to the whitelist
  Future<bool> addAllowedEmail(String email) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await firestoreService.addAllowedEmail(email.trim().toLowerCase());
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add email: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Removes an email from the whitelist
  Future<bool> deleteAllowedEmail(String id) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await firestoreService.deleteAllowedEmail(id);
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete email: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Sets starting cash configuration for a user
  Future<bool> setInitialBalances({
    required String userId,
    required double usdAmount,
    required double egpAmount,
  }) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await firestoreService.setInitialBalances(
        userId: userId,
        usdAmount: usdAmount,
        egpAmount: egpAmount,
      );
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update starting cash: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Updates current user's profile display name
  Future<bool> updateDisplayName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return false;

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await user.updateDisplayName(trimmed);
      await firestoreService.saveUserProfile(
        UserProfile(
          id: user.uid,
          name: trimmed,
          email: user.email ?? '',
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        ),
      );
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile name: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Purges all expenses, exchanges, initial balances, and user records
  Future<bool> deleteAllTripData() async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await firestoreService.deleteAllTripData();
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete data: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}
