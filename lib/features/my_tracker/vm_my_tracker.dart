import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/f_firestore.dart';
import '../home/vm_home_feed.dart';
import 'tracker/vm_my_tracker_filter.dart';
import 'tracker/vm_my_tracker_getters.dart';
import 'tracker/vm_my_tracker_mutations.dart';
import 'tracker/vm_my_tracker_state.dart';

export 'tracker/vm_my_tracker_filter.dart';

/// ViewModel managing calculations, filtering, and data streams for "My Tracker".
class MyTrackerViewModel extends ChangeNotifier
    with MyTrackerGettersMixin, MyTrackerMutationsMixin {
  @override
  final User user;
  @override
  final FirestoreService firestoreService;
  @override
  final HomeFeedViewModel? feedViewModel;
  @override
  final MyTrackerState state = MyTrackerState();

  MyTrackerViewModel({
    required this.user,
    required this.firestoreService,
    this.feedViewModel,
  }) {
    if (feedViewModel != null) {
      feedViewModel!.addListener(_onFeedUpdated);
    } else {
      state.initSubscriptions(
        firestoreService: firestoreService,
        onUpdate: notifyListeners,
      );
    }
  }

  void _onFeedUpdated() => notifyListeners();

  @override
  void dispose() {
    feedViewModel?.removeListener(_onFeedUpdated);
    state.dispose();
    super.dispose();
  }

  void setFilter(MyTrackerFilter newFilter) {
    if (state.filter == newFilter) return;
    state.filter = newFilter;
    notifyListeners();
  }
}
