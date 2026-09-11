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

    WriteBatch batch = _firestore.batch();
    int opCount = 0;

    Future<void> safeDelete(DocumentReference ref) async {
      batch.delete(ref);
      opCount++;
      if (opCount >= 400) {
        await batch.commit();
        batch = _firestore.batch();
        opCount = 0;
      }
    }

    if (deleteExpenses) {
      final expensesSnap = await _expensesCollection.get();
      for (final doc in expensesSnap.docs) {
        await safeDelete(doc.reference);
      }
    }

    if (deleteExchanges) {
      final exchangesSnap = await _exchangesCollection.get();
      for (final doc in exchangesSnap.docs) {
        await safeDelete(doc.reference);
      }
    }

    if (deleteBorrows) {
      final borrowsSnap = await _borrowsCollection.get();
      for (final doc in borrowsSnap.docs) {
        await safeDelete(doc.reference);
      }
    }

    if (deleteInitialBalances) {
      final balancesSnap = await _initialBalancesCollection.get();
      for (final doc in balancesSnap.docs) {
        await safeDelete(doc.reference);
      }
    }

    if (deleteFriends) {
      final emailsSnap = await _allowedEmailsCollection.get();
      for (final doc in emailsSnap.docs) {
        final email = (doc.data()['email'] as String?)?.toLowerCase().trim();
        final isSelf = normalizedKeepEmail != null && email == normalizedKeepEmail;
        final isAdmin = email == defaultAdminEmail;
        if (!isSelf && !isAdmin) {
          await safeDelete(doc.reference);
        }
      }

      final usersSnap = await _usersCollection.get();
      for (final doc in usersSnap.docs) {
        final email = (doc.data()['email'] as String?)?.toLowerCase().trim();
        final id = doc.id;
        final isSelf = (keepUserId != null && id == keepUserId) ||
            (normalizedKeepEmail != null && email == normalizedKeepEmail);
        if (!isSelf) {
          await safeDelete(doc.reference);
        }
      }
    }

    if (opCount > 0) {
      await batch.commit();
    }
  }
}
