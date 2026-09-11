import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/components/c_traveler_balance_card.dart';
import '../../core/services/f_firestore.dart';
import '../../core/utils/m_auth_helpers.dart';
import '../home/vm_home_feed.dart';
import 'components/c_my_tracker_list.dart';
import 'vm_my_tracker.dart';

/// Screen (View) for "My Tracker" tab.
class MyTrackerScreen extends StatefulWidget {
  final User user;
  final FirestoreService firestoreService;
  final HomeFeedViewModel? feedViewModel;
  final MyTrackerViewModel? viewModel;

  const MyTrackerScreen({
    super.key,
    required this.user,
    required this.firestoreService,
    this.feedViewModel,
    this.viewModel,
  });

  @override
  State<MyTrackerScreen> createState() => _MyTrackerScreenState();
}

class _MyTrackerScreenState extends State<MyTrackerScreen> {
  late final MyTrackerViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = MyTrackerViewModel(
        user: widget.user,
        firestoreService: widget.firestoreService,
        feedViewModel: widget.feedViewModel,
      );
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final myName = resolveUserName(widget.user, _viewModel.myProfile?.name);
        final myPhoto =
            resolveUserPhoto(widget.user, _viewModel.myProfile?.photoUrl);
        final friendName = _viewModel.friendProfile?.name.isNotEmpty == true
            ? _viewModel.friendProfile!.name
            : _viewModel.friendEmailDoc?.email;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: TravelerBalanceCard(
                name: myName,
                photoUrl: myPhoto,
                email: widget.user.email ?? '',
                isCurrentUser: true,
                usdAmount: _viewModel.myUsdBalance,
                egpAmount: _viewModel.myEgpBalance,
              ),
            ),
            Expanded(
              child: MyTrackerExpenseList(
                expenses: _viewModel.allPersonalExpenses,
                user: widget.user,
                friendName: friendName,
                viewModel: _viewModel,
              ),
            ),
          ],
        );
      },
    );
  }
}
