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
    });
  }

  Future<bool> isEmailAllowed(String email) async {
    final normalized = email.toLowerCase().trim();
    if (normalized == AppConfig.adminEmail) {
      return true;
    }
    final snapshot = await _allowedEmailsCollection.get();

    // If whitelist is completely empty, allow initial user and auto-seed
    if (snapshot.docs.isEmpty) {
      await addAllowedEmail(normalized);
      return true;
    }

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
    final normalized = newEmail.trim().toLowerCase();
    await _allowedEmailsCollection.doc(id).update({
      'email': normalized,
    });
  }

  Future<void> deleteAllowedEmail(String id) async {
    await _allowedEmailsCollection.doc(id).delete();
  }
}
