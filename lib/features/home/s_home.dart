import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/c_home_nav_bar.dart';
import 'components/c_home_tab_stack.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';
import 'vm_home.dart';
import 'vm_home_feed.dart';

export 'components/c_home_action_handler.dart';

/// Screen (View) for Home scaffold with floating pill navigation bar.
class HomeScreen extends StatefulWidget {
  final User user;
  final AuthService authService;
  final FirestoreService firestoreService;
  final HomeViewModel? viewModel;
  final HomeFeedViewModel? feedViewModel;

  const HomeScreen({
    super.key,
    required this.user,
    required this.authService,
    required this.firestoreService,
    this.viewModel,
    this.feedViewModel,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  late final HomeFeedViewModel _homeFeedViewModel;
  bool _ownsViewModel = false;
  bool _ownsFeedViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.feedViewModel != null) {
      _homeFeedViewModel = widget.feedViewModel!;
    } else {
      _homeFeedViewModel = HomeFeedViewModel(
        user: widget.user,
        firestoreService: widget.firestoreService,
      );
      _ownsFeedViewModel = true;
    }

    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = HomeViewModel();
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsFeedViewModel) _homeFeedViewModel.dispose();
    if (_ownsViewModel) _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final selectedIndex = _viewModel.selectedIndex;

        return Scaffold(
          extendBody: true,
          body: SafeArea(
            bottom: false,
            child: HomeTabStack(
              selectedIndex: selectedIndex,
              user: widget.user,
              authService: widget.authService,
              firestoreService: widget.firestoreService,
              feedViewModel: _homeFeedViewModel,
            ),
          ),
          bottomNavigationBar: HomeNavBar(
            selectedIndex: selectedIndex,
            currentUserId: widget.user.uid,
            feedViewModel: _homeFeedViewModel,
            onDestinationSelected: (index) {
              HapticFeedback.selectionClick();
              _viewModel.selectTab(index);
            },
          ),
        );
      },
    );
  }
}
