import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/animations/a_animated_counter.dart';
import '../../../core/services/f_auth.dart';
import '../../../core/services/f_firestore.dart';
import '../../my_tracker/s_my_tracker.dart';
import '../../settings/s_settings.dart';
import '../s_home_tab.dart';
import '../vm_home_feed.dart';

/// Stack holding the 3 tab screens of the application with horizontal slide navigation.
class HomeTabStack extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onPageChanged;
  final PageController? pageController;
  final User user;
  final AuthService authService;
  final FirestoreService firestoreService;
  final HomeFeedViewModel feedViewModel;

  const HomeTabStack({
    super.key,
    required this.selectedIndex,
    this.onPageChanged,
    this.pageController,
    required this.user,
    required this.authService,
    required this.firestoreService,
    required this.feedViewModel,
  });

  @override
  State<HomeTabStack> createState() => _HomeTabStackState();
}

class _HomeTabStackState extends State<HomeTabStack> {
  PageController? _internalPageController;
  late final Map<int, int> _tabVisits;

  PageController get _effectivePageController =>
      widget.pageController ??
      (_internalPageController ??=
          PageController(initialPage: widget.selectedIndex));

  @override
  void initState() {
    super.initState();
    _tabVisits = {
      0: 1,
      1: widget.selectedIndex == 1 ? 1 : 0,
      2: widget.selectedIndex == 2 ? 1 : 0,
    };
  }

  @override
  void didUpdateWidget(covariant HomeTabStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _tabVisits[widget.selectedIndex] =
          (_tabVisits[widget.selectedIndex] ?? 0) + 1;
      final controller = _effectivePageController;
      if (controller.hasClients &&
          (controller.page?.round() != widget.selectedIndex)) {
        controller.animateToPage(
          widget.selectedIndex,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _internalPageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _effectivePageController,
      onPageChanged: (index) {
        _tabVisits[index] = (_tabVisits[index] ?? 0) + 1;
        widget.onPageChanged?.call(index);
      },
      children: [
        _KeepAliveTab(
          child: PageVisitScope(
            token: _tabVisits[0] ?? 1,
            child: HomeTabScreen(
              key: const ValueKey<int>(0),
              user: widget.user,
              viewModel: widget.feedViewModel,
            ),
          ),
        ),
        _KeepAliveTab(
          child: PageVisitScope(
            token: _tabVisits[1] ?? 1,
            child: MyTrackerScreen(
              key: const ValueKey<int>(1),
              user: widget.user,
              firestoreService: widget.firestoreService,
              feedViewModel: widget.feedViewModel,
            ),
          ),
        ),
        _KeepAliveTab(
          child: PageVisitScope(
            token: _tabVisits[2] ?? 1,
            child: SettingsScreen(
              key: const ValueKey<int>(2),
              user: widget.user,
              authService: widget.authService,
              firestoreService: widget.firestoreService,
            ),
          ),
        ),
      ],
    );
  }
}

class _KeepAliveTab extends StatefulWidget {
  final Widget child;

  const _KeepAliveTab({required this.child});

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
