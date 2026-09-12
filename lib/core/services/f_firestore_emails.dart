part of 'f_firestore.dart';

mixin FirestoreEmailsMixin on FirestoreServiceBase {
  Stream<List<AllowedEmail>> getAllowedEmailsStream() {
    return _allowedEmailsCollection.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => AllowedEmail.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) {
        final aIsPrimary =
            a.email.toLowerCase().trim() == AppConfig.adminEmail;
        final bIsPrimary =
            b.email.toLowerCase().trim() == AppConfig.adminEmail;
        if (aIsPrimary && !bIsPrimary) return -1;
        if (!aIsPrimary && bIsPrimary) return 1;
        return a.createdAt.compareTo(b.createdAt);
      });
      return list;
    }).handleError((error) {
      debugPrint('Firestore allowed emails stream error: $error');
      return <AllowedEmail>[];
    });
  }

  Future<bool> isEmailAllowed(String email) async {
    final normalized = email.toLowerCase().trim();
    if (normalized == AppConfig.adminEmail) {
      final snapshot = await _allowedEmailsCollection.get();
      if (snapshot.docs.isEmpty) {
        await addAllowedEmail(AppConfig.adminEmail);
      }
      return true;
    }

    final snapshot = await _allowedEmailsCollection.get();
    return snapshot.docs.any((doc) {
      final docEmail = (doc.data()['email'] as String? ?? '').toLowerCase().trim();
      return docEmail == normalized;
    });
  }

  Future<void> addAllowedEmail(String email) async {
    final normalized = email.toLowerCase().trim();
    final snapshot = await _allowedEmailsCollection.get();
    final alreadyExists = snapshot.docs.any((doc) {
      final docEmail = (doc.data()['email'] as String? ?? '').toLowerCase().trim();
      return docEmail == normalized;
    });
    if (alreadyExists) {
      return;
    }

    final docRef = _allowedEmailsCollection.doc();
    final allowedEmail = AllowedEmail(
      id: docRef.id,
      email: normalized,
      createdAt: DateTime.now(),
    );
    await docRef.set(allowedEmail.toMap());
  }

  Future<void> updateAllowedEmail(String id, String newEmail) async {
    final doc = await _allowedEmailsCollection.doc(id).get();
    if (doc.exists) {
      final currentEmail =
          (doc.data()?['email'] as String? ?? '').toLowerCase().trim();
      if (currentEmail == AppConfig.adminEmail) {
        throw StateError('Cannot modify super admin email');
      }
    }
    final normalized = newEmail.trim().toLowerCase();
    await _allowedEmailsCollection.doc(id).update({
      'email': normalized,
    });
  }

  Future<void> deleteAllowedEmail(String id) async {
    final doc = await _allowedEmailsCollection.doc(id).get();
    if (doc.exists) {
      final currentEmail =
          (doc.data()?['email'] as String? ?? '').toLowerCase().trim();
      if (currentEmail == AppConfig.adminEmail) {
        throw StateError('Cannot delete super admin email');
      }
    }
    await _allowedEmailsCollection.doc(id).delete();
  }
}
