import 'package:flutter/material.dart';
import '../../../core/components/c_traveler_balance_card.dart';

/// Modern ungrouped balance cards displaying independent USD and EGP cash balances.
///
/// Composes reusable [TravelerBalanceCard] widgets for "You" and "Travel Partner".
/// Strict Domain Invariant: Zero combined totals and absolute currency separation.
class HomeBalancesCard extends StatelessWidget {
  final String myName;
  final String? myPhotoUrl;
  final String myEmail;
  final double myUsd;
  final double myEgp;

  final String? friendName;
  final String? friendPhotoUrl;
  final String? friendEmail;
  final double friendUsd;
  final double friendEgp;

  const HomeBalancesCard({
    super.key,
    required this.myName,
    this.myPhotoUrl,
    required this.myEmail,
    required this.myUsd,
    required this.myEgp,
    this.friendName,
    this.friendPhotoUrl,
    this.friendEmail,
    required this.friendUsd,
    required this.friendEgp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Primary Traveler ("You") Standalone Card
        TravelerBalanceCard(
          name: myName,
          photoUrl: myPhotoUrl,
          email: myEmail,
          isCurrentUser: true,
          usdAmount: myUsd,
          egpAmount: myEgp,
        ),
        const SizedBox(height: 14),

        // 2. Travel Partner Standalone Card
        if (friendEmail != null)
          TravelerBalanceCard(
            name: friendName ?? 'Friend',
            photoUrl: friendPhotoUrl,
            email: friendEmail!,
            isCurrentUser: false,
            usdAmount: friendUsd,
            egpAmount: friendEgp,
          )
        else
          const EmptyTravelerCard(),
      ],
    );
  }
}
