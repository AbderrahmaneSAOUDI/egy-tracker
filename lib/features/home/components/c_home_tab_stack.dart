import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/services/f_auth.dart';
import '../../../core/services/f_firestore.dart';
import '../../my_tracker/s_my_tracker.dart';
import '../../settings/s_settings.dart';
import '../s_home_tab.dart';
import '../vm_home_feed.dart';

/// Stack holding the 3 tab screens of the application.
class HomeTabStack extends StatelessWidget {
  final int selectedIndex;
  final User user;
  final AuthService authService;
  final FirestoreService firestoreService;
  final HomeFeedViewModel feedViewModel;

  const HomeTabStack({
    super.key,
    required this.selectedIndex,
    required this.user,
    required this.authService,
    required this.firestoreService,
    required this.feedViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        HomeTabScreen(
          key: const ValueKey<int>(0),
          user: user,
          viewModel: feedViewModel,
        ),
        MyTrackerScreen(
          key: const ValueKey<int>(1),
          user: user,
          firestoreService: firestoreService,
          feedViewModel: feedViewModel,
        ),
        SettingsScreen(
          key: const ValueKey<int>(2),
          user: user,
          authService: authService,
          firestoreService: firestoreService,
        ),
      ],
    );
  }
}
