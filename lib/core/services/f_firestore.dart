import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mod_allowed_email.dart';
import '../models/mod_borrow.dart';
import '../models/mod_exchange.dart';
import '../models/mod_expense.dart';
import '../models/mod_initial_balance.dart';
import '../models/mod_user_profile.dart';

class FirestoreService {
  final FirebaseFirestore? _customFirestore;

  FirestoreService({FirebaseFirestore? firestore}) : _customFirestore = firestore;

  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _allowedEmailsCollection =>
      _firestore.collection('allowed_emails');
  CollectionReference<Map<String, dynamic>> get _initialBalancesCollection =>
      _firestore.collection('initial_balances');
  CollectionReference<Map<String, dynamic>> get _expensesCollection =>
      _firestore.collection('expenses');
  CollectionReference<Map<String, dynamic>> get _exchangesCollection =>
      _firestore.collection('exchanges');
  CollectionReference<Map<String, dynamic>> get _borrowsCollection =>
      _firestore.collection('borrows');

  // ===================== USER PROFILES =====================

  Stream<List<UserProfile>> getUsersStream() {
    return _usersCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserProfile.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> saveUserProfile(UserProfile user) async {
    final data = user.toMap();
    if (user.photoUrl == null || user.photoUrl!.trim().isEmpty) {
      data.remove('photo_url');
    }
    await _usersCollection.doc(user.id).set(data, SetOptions(merge: true));
  }

  // ===================== ALLOWED EMAILS =====================

  Stream<List<AllowedEmail>> getAllowedEmailsStream() {
    return _allowedEmailsCollection.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => AllowedEmail.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) {
        final aIsPrimary =
            a.email.toLowerCase().trim() == 'abderrahmane.saoudi.26@gmail.com';
        final bIsPrimary =
            b.email.toLowerCase().trim() == 'abderrahmane.saoudi.26@gmail.com';
        if (aIsPrimary && !bIsPrimary) return -1;
        if (!aIsPrimary && bIsPrimary) return 1;
        return a.createdAt.compareTo(b.createdAt);
      });
      return list;
    });
  }

  Future<bool> isEmailAllowed(String email) async {
    final normalized = email.toLowerCase().trim();
    if (normalized == 'abderrahmane.saoudi.26@gmail.com') {
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

  Future<void> deleteAllowedEmail(String id) async {
    await _allowedEmailsCollection.doc(id).delete();
  }

  // ===================== INITIAL BALANCES =====================

  Stream<List<InitialBalance>> getInitialBalancesStream() {
    return _initialBalancesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => InitialBalance.fromMap(doc.data(), doc.id))
        .toList());
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

  // ===================== EXPENSES =====================

  Stream<List<Expense>> getExpensesStream() {
    try {
      return _expensesCollection.snapshots().map((snapshot) {
        final list = snapshot.docs
            .map((doc) => Expense.fromMap(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<void> addExpense(Expense expense) async {
    final docRef = _expensesCollection.doc(expense.id.isNotEmpty ? expense.id : null);
    final toSave = Expense(
      id: docRef.id,
      title: expense.title,
      amount: expense.amount,
      currency: expense.currency,
      paidBy: expense.paidBy,
      splitType: expense.splitType,
      mePercentage: expense.mePercentage,
      friendPercentage: expense.friendPercentage,
      date: expense.date,
      createdAt: expense.createdAt,
    );
    await docRef.set(toSave.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _expensesCollection.doc(id).delete();
  }

  // ===================== EXCHANGES =====================

  Stream<List<Exchange>> getExchangesStream() {
    try {
      return _exchangesCollection.snapshots().map((snapshot) {
        final list = snapshot.docs
            .map((doc) => Exchange.fromMap(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<void> addExchange(Exchange exchange) async {
    final docRef = _exchangesCollection.doc(exchange.id.isNotEmpty ? exchange.id : null);
    final toSave = Exchange(
      id: docRef.id,
      userId: exchange.userId,
      fromCurrency: exchange.fromCurrency,
      fromAmount: exchange.fromAmount,
      toCurrency: exchange.toCurrency,
      toAmount: exchange.toAmount,
      exchangeRate: exchange.exchangeRate,
      date: exchange.date,
      createdAt: exchange.createdAt,
    );
    await docRef.set(toSave.toMap());
  }

  Future<void> deleteExchange(String id) async {
    await _exchangesCollection.doc(id).delete();
  }

  // ===================== BORROWS =====================

  Stream<List<Borrow>> getBorrowsStream() {
    try {
      return _borrowsCollection.snapshots().map((snapshot) {
        final list = snapshot.docs
            .map((doc) => Borrow.fromMap(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<void> addBorrow(Borrow borrow) async {
    final docRef = _borrowsCollection.doc(borrow.id.isNotEmpty ? borrow.id : null);
    final toSave = Borrow(
      id: docRef.id,
      borrowerId: borrow.borrowerId,
      lenderId: borrow.lenderId,
      usdAmount: borrow.usdAmount,
      egpAmount: borrow.egpAmount,
      date: borrow.date,
      createdAt: borrow.createdAt,
    );
    await docRef.set(toSave.toMap());
  }

  Future<void> deleteBorrow(String id) async {
    await _borrowsCollection.doc(id).delete();
  }

  // ===================== DATA WIPE PROTOCOL =====================

  /// Purges all trip expenses, exchanges, borrows, initial balances, and trip members,
  /// while preserving the logged-in user's own email authorization and profile.
  Future<void> deleteAllTripData({String? keepEmail, String? keepUserId}) async {
    final normalizedKeepEmail = keepEmail?.toLowerCase().trim();
    const defaultAdminEmail = 'abderrahmane.saoudi.26@gmail.com';

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

    // 1. Delete all expenses
    final expensesSnap = await _expensesCollection.get();
    for (final doc in expensesSnap.docs) {
      await safeDelete(doc.reference);
    }

    // 2. Delete all exchanges
    final exchangesSnap = await _exchangesCollection.get();
    for (final doc in exchangesSnap.docs) {
      await safeDelete(doc.reference);
    }

    // 3. Delete all borrows
    final borrowsSnap = await _borrowsCollection.get();
    for (final doc in borrowsSnap.docs) {
      await safeDelete(doc.reference);
    }

    // 4. Reset/delete all initial balances
    final balancesSnap = await _initialBalancesCollection.get();
    for (final doc in balancesSnap.docs) {
      await safeDelete(doc.reference);
    }

    // 5. Purge allowed emails for trip members, preserving current user and default admin
    final emailsSnap = await _allowedEmailsCollection.get();
    for (final doc in emailsSnap.docs) {
      final email = (doc.data()['email'] as String?)?.toLowerCase().trim();
      final isSelf = normalizedKeepEmail != null && email == normalizedKeepEmail;
      final isAdmin = email == defaultAdminEmail;
      if (!isSelf && !isAdmin) {
        await safeDelete(doc.reference);
      }
    }

    // 6. Delete user profiles for friends/other users, preserving current user
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

    if (opCount > 0) {
      await batch.commit();
    }
  }
}
