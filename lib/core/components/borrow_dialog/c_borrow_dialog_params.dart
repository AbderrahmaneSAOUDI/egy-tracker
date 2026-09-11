import 'package:flutter/material.dart';
import '../../models/mod_borrow.dart';

/// Parameters passed into the borrow dialog view.
class BorrowDialogParams {
  final BuildContext dialogContext;
  final String currentUserId;
  final String? currentUserEmail;
  final String friendId;
  final String friendName;
  final double myUsdBalance;
  final double myEgpBalance;
  final double friendUsdBalance;
  final double friendEgpBalance;
  final Borrow? initialBorrow;
  final TextEditingController usdController;
  final TextEditingController egpController;
  final Future<bool> Function(Borrow) onSave;

  const BorrowDialogParams({
    required this.dialogContext,
    required this.currentUserId,
    this.currentUserEmail,
    required this.friendId,
    required this.friendName,
    required this.myUsdBalance,
    required this.myEgpBalance,
    required this.friendUsdBalance,
    required this.friendEgpBalance,
    required this.initialBorrow,
    required this.usdController,
    required this.egpController,
    required this.onSave,
  });
}
