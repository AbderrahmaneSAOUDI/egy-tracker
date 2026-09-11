import 'dart:async';
import '../../../core/models/mod_allowed_email.dart';
import '../../../core/models/mod_borrow.dart';
import '../../../core/models/mod_exchange.dart';
import '../../../core/models/mod_expense.dart';
import '../../../core/models/mod_initial_balance.dart';
import '../../../core/models/mod_user_profile.dart';
import '../../../core/services/f_firestore.dart';
import 'vm_my_tracker_filter.dart';
import 'vm_my_tracker_subscriptions.dart';

/// Holds and manages local reactive data state for My Tracker.
class MyTrackerState {
  bool isProcessing = false;
  String? errorMessage;
  MyTrackerFilter filter = MyTrackerFilter.all;

  List<Expense> localExpenses = [];
  List<Exchange> localExchanges = [];
  List<Borrow> localBorrows = [];
  List<InitialBalance> localBalances = [];
  List<UserProfile> localUsers = [];
  List<AllowedEmail> localAllowedEmails = [];

  final MyTrackerSubscriptions subs = MyTrackerSubscriptions();
  bool _isMicrotaskScheduled = false;

  void initSubscriptions({
    required FirestoreService firestoreService,
    required void Function() onUpdate,
  }) {
    subs.init(
      firestoreService: firestoreService,
      onExpenses: (d) { localExpenses = d; _schedule(onUpdate); },
      onExchanges: (d) { localExchanges = d; _schedule(onUpdate); },
      onBorrows: (d) { localBorrows = d; _schedule(onUpdate); },
      onBalances: (d) { localBalances = d; _schedule(onUpdate); },
      onUsers: (d) { localUsers = d; _schedule(onUpdate); },
      onEmails: (d) { localAllowedEmails = d; _schedule(onUpdate); },
    );
  }

  void _schedule(void Function() onUpdate) {
    if (_isMicrotaskScheduled) return;
    _isMicrotaskScheduled = true;
    scheduleMicrotask(() {
      _isMicrotaskScheduled = false;
      onUpdate();
    });
  }

  void dispose() => subs.dispose();
}
