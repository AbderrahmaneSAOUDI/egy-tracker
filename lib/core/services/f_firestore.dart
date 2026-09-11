import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';
import '../models/mod_allowed_email.dart';
import '../models/mod_borrow.dart';
import '../models/mod_exchange.dart';
import '../models/mod_expense.dart';
import '../models/mod_initial_balance.dart';
import '../models/mod_user_profile.dart';

part 'f_firestore_users_balances.dart';
part 'f_firestore_emails.dart';
part 'f_firestore_expenses.dart';
part 'f_firestore_transfers.dart';
part 'f_firestore_purge.dart';

abstract class FirestoreServiceBase {
  CollectionReference<Map<String, dynamic>> get _usersCollection;
  CollectionReference<Map<String, dynamic>> get _allowedEmailsCollection;
  CollectionReference<Map<String, dynamic>> get _initialBalancesCollection;
  CollectionReference<Map<String, dynamic>> get _expensesCollection;
  CollectionReference<Map<String, dynamic>> get _exchangesCollection;
  CollectionReference<Map<String, dynamic>> get _borrowsCollection;
  FirebaseFirestore get _firestore;
}

class FirestoreService extends FirestoreServiceBase
    with
        FirestoreUsersBalancesMixin,
        FirestoreEmailsMixin,
        FirestoreExpensesMixin,
        FirestoreTransfersMixin,
        FirestorePurgeMixin {
  final FirebaseFirestore? _customFirestore;

  FirestoreService({FirebaseFirestore? firestore}) : _customFirestore = firestore;

  @override
  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  // Collection references
  @override
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');
  @override
  CollectionReference<Map<String, dynamic>> get _allowedEmailsCollection =>
      _firestore.collection('allowed_emails');
  @override
  CollectionReference<Map<String, dynamic>> get _initialBalancesCollection =>
      _firestore.collection('initial_balances');
  @override
  CollectionReference<Map<String, dynamic>> get _expensesCollection =>
      _firestore.collection('expenses');
  @override
  CollectionReference<Map<String, dynamic>> get _exchangesCollection =>
      _firestore.collection('exchanges');
  @override
  CollectionReference<Map<String, dynamic>> get _borrowsCollection =>
      _firestore.collection('borrows');
}
