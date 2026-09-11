part of 'f_firestore.dart';

mixin FirestorePurgeMixin on FirestoreServiceBase {
  Future<void> deleteAllTripData({String? keepEmail, String? keepUserId}) async {
    await deleteTripData(
      deleteExpenses: true,
      deleteExchanges: true,
      deleteBorrows: true,
      deleteInitialBalances: true,
      deleteFriends: true,
      keepEmail: keepEmail,
      keepUserId: keepUserId,
    );
  }

  Future<void> deleteTripData({
    bool deleteExpenses = true,
    bool deleteExchanges = true,
    bool deleteBorrows = true,
    bool deleteInitialBalances = true,
    bool deleteFriends = true,
    String? keepEmail,
    String? keepUserId,
  }) async {
    final normalizedKeepEmail = keepEmail?.toLowerCase().trim();
    const defaultAdminEmail = AppConfig.adminEmail;

    final refsToDelete = <DocumentReference>[];

    if (deleteExpenses) {
      final expensesSnap = await _expensesCollection.get();
      for (final doc in expensesSnap.docs) {
        refsToDelete.add(doc.reference);
      }
    }

    if (deleteExchanges) {
      final exchangesSnap = await _exchangesCollection.get();
      for (final doc in exchangesSnap.docs) {
        refsToDelete.add(doc.reference);
      }
    }

    if (deleteBorrows) {
      final borrowsSnap = await _borrowsCollection.get();
      for (final doc in borrowsSnap.docs) {
        refsToDelete.add(doc.reference);
      }
    }

    if (deleteInitialBalances) {
      final balancesSnap = await _initialBalancesCollection.get();
      for (final doc in balancesSnap.docs) {
        refsToDelete.add(doc.reference);
      }
    }

    if (deleteFriends) {
      final emailsSnap = await _allowedEmailsCollection.get();
      for (final doc in emailsSnap.docs) {
        final email = (doc.data()['email'] as String?)?.toLowerCase().trim();
        final isSelf = normalizedKeepEmail != null && email == normalizedKeepEmail;
        final isAdmin = email == defaultAdminEmail;
        if (!isSelf && !isAdmin) {
          refsToDelete.add(doc.reference);
        }
      }

      final usersSnap = await _usersCollection.get();
      for (final doc in usersSnap.docs) {
        final email = (doc.data()['email'] as String?)?.toLowerCase().trim();
        final id = doc.id;
        final isSelf = (keepUserId != null && id == keepUserId) ||
            (normalizedKeepEmail != null && email == normalizedKeepEmail);
        if (!isSelf) {
          refsToDelete.add(doc.reference);
        }
      }
    }

    for (var i = 0; i < refsToDelete.length; i += 400) {
      final end = (i + 400 > refsToDelete.length) ? refsToDelete.length : i + 400;
      final chunk = refsToDelete.sublist(i, end);
      final batch = _firestore.batch();
      for (final ref in chunk) {
        batch.delete(ref);
      }
      try {
        await batch.commit();
      } catch (e) {
        debugPrint('Firestore delete batch chunk failed: $e');
        rethrow;
      }
    }
  }
}
