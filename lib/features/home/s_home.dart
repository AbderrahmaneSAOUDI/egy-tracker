import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/components/c_floating_pill_nav_bar.dart';
import '../../core/services/f_auth.dart';
import '../../core/services/f_firestore.dart';
import '../settings/s_settings.dart';
import 'components/c_add_action_sheet.dart';
import 'components/c_add_exchange_dialog.dart';
import 'components/c_add_expense_dialog.dart';
import 'components/c_borrow_dialog.dart';
import 's_home_tab.dart';
import 'vm_home.dart';
import 'vm_home_feed.dart';

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
    if (_ownsFeedViewModel) {
      _homeFeedViewModel.dispose();
    }
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final selectedIndex = _viewModel.selectedIndex;
        final slideDirection = _viewModel.slideDirection;

        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, slideDirection * 0.15),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                _viewModel.currentTitle,
                key: ValueKey<String>(_viewModel.currentTitle),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.06),
              ),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final isIncoming = (child.key as ValueKey<int>?)?.value == selectedIndex;
              final beginOffset = isIncoming
                  ? Offset(slideDirection * 0.08, 0)
                  : Offset(-slideDirection * 0.08, 0);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: beginOffset,
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: selectedIndex == 0
                ? HomeTabScreen(
                    key: const ValueKey<int>(0),
                    user: widget.user,
                    viewModel: _homeFeedViewModel,
                  )
                : selectedIndex == 2
                    ? SettingsScreen(
                        key: const ValueKey<int>(2),
                        user: widget.user,
                        authService: widget.authService,
                        firestoreService: widget.firestoreService,
                      )
                    : SizedBox.expand(
                        key: ValueKey<int>(selectedIndex),
                      ),
          ),
          bottomNavigationBar: FloatingPillNavBar(
            selectedIndex: selectedIndex,
            showAddButton: selectedIndex == 1,
            onAddPressed: () {
              showAddActionSheet(
                context: context,
                onAddExpense: () {
                  final friendId = _homeFeedViewModel.friendProfile?.id ??
                      _homeFeedViewModel.friendEmailDoc?.email;
                  final friendName = _homeFeedViewModel.friendProfile?.name ??
                      _homeFeedViewModel.friendEmailDoc?.email;

                  showAddExpenseDialog(
                    context: context,
                    currentUserId: widget.user.uid,
                    currentUserName:
                        _homeFeedViewModel.myProfile?.name ?? 'You',
                    friendUserId: friendId,
                    friendUserName: friendName,
                    myUsdBalance: _homeFeedViewModel.myUsdBalance,
                    myEgpBalance: _homeFeedViewModel.myEgpBalance,
                    friendUsdBalance: _homeFeedViewModel.friendUsdBalance,
                    friendEgpBalance: _homeFeedViewModel.friendEgpBalance,
                    onSave: _homeFeedViewModel.addExpense,
                  );
                },
                onAddExchange: () {
                  showAddExchangeDialog(
                    context: context,
                    currentUserId: widget.user.uid,
                    currentUserName:
                        _homeFeedViewModel.myProfile?.name ?? 'You',
                    myUsdBalance: _homeFeedViewModel.myUsdBalance,
                    myEgpBalance: _homeFeedViewModel.myEgpBalance,
                    onSave: _homeFeedViewModel.addExchange,
                  );
                },
                onBorrowCurrency: () {
                  final friendId = _homeFeedViewModel.friendProfile?.id ??
                      _homeFeedViewModel.friendEmailDoc?.email;
                  final friendName = _homeFeedViewModel.friendProfile?.name ??
                      _homeFeedViewModel.friendEmailDoc?.email;

                  showBorrowDialog(
                    context: context,
                    currentUserId: widget.user.uid,
                    currentUserName:
                        _homeFeedViewModel.myProfile?.name ?? 'You',
                    friendUserId: friendId,
                    friendUserName: friendName,
                    onSave: _homeFeedViewModel.addBorrow,
                  );
                },
              );
            },
            onDestinationSelected: _viewModel.selectTab,
            items: const [
              FloatingNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Home',
              ),
              FloatingNavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'My Tracker',
              ),
              FloatingNavItem(
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings_rounded,
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
