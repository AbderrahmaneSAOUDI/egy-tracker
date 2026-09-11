part of 'f_firestore.dart';

mixin FirestoreUsersBalancesMixin on FirestoreServiceBase {
  Stream<List<UserProfile>> getUsersStream() {
    return _usersCollection
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
            .toList())
        .handleError((error) {
      debugPrint('Firestore users stream error: $error');
      return <UserProfile>[];
    });
  }

  Future<void> saveUserProfile(UserProfile user) async {
    final data = user.toMap();
    if (user.photoUrl == null || user.photoUrl!.trim().isEmpty) {
      data.remove('photo_url');
    }
    await _usersCollection.doc(user.id).set(data, SetOptions(merge: true));
  }

  Stream<List<InitialBalance>> getInitialBalancesStream() {
    return _initialBalancesCollection
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InitialBalance.fromMap(doc.data(), doc.id))
            .toList())
        .handleError((error) {
      debugPrint('Firestore initial balances stream error: $error');
      return <InitialBalance>[];
    });
  }

  Future<void> setInitialBalances({
    required String userId,
    required double usdAmount,
    required double egpAmount,
  }) async {
    final balance = InitialBalance(
      userId: userId,
      usdAmount: usdAmount,
      egpAmount: egpAmount,
      updatedAt: DateTime.now(),
    );
    await _initialBalancesCollection.doc(userId).set(balance.toMap());
  }
}
