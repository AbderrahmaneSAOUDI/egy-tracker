import 'package:flutter/material.dart';
import '../models/mod_borrow.dart';
import 'borrow_dialog/c_borrow_dialog_params.dart';
import 'borrow_dialog/c_borrow_dialog_view.dart';
import 'c_app_dialog.dart';

export 'borrow_dialog/c_borrow_amount_inputs.dart';
export 'borrow_dialog/c_borrow_date_picker.dart';
export 'borrow_dialog/c_borrow_dialog_content.dart';
export 'borrow_dialog/c_borrow_dialog_models.dart';
export 'borrow_dialog/c_borrow_dialog_params.dart';
export 'borrow_dialog/c_borrow_dialog_view.dart';
export 'borrow_dialog/c_borrow_direction_chip.dart';
export 'borrow_dialog/c_borrow_direction_selector.dart';
export 'borrow_dialog/c_borrow_submit_handler.dart';

/// Shows modal dialog for borrowing or lending cash between travel partners.
Future<void> showBorrowDialog({
  required BuildContext context,
  required String currentUserId,
  required String currentUserName,
  String? currentUserEmail,
  String? friendUserId,
  String? friendUserName,
  String? friendUserEmail,
  double myUsdBalance = 0.0,
  double myEgpBalance = 0.0,
  double friendUsdBalance = 0.0,
  double friendEgpBalance = 0.0,
  Borrow? initialBorrow,
  required Future<bool> Function(Borrow) onSave,
}) async {
  final usdController = TextEditingController(
    text: initialBorrow != null && initialBorrow.usdAmount > 0
        ? initialBorrow.usdAmount.toStringAsFixed(2)
        : '',
  );
  final egpController = TextEditingController(
    text: initialBorrow != null && initialBorrow.egpAmount > 0
        ? initialBorrow.egpAmount.toStringAsFixed(2)
        : '',
  );

  final friendId = friendUserId ?? (friendUserEmail?.trim().isNotEmpty == true ? friendUserEmail!.trim() : 'friend');
  final friendName = friendUserName ?? 'Friend';

  await showAnimatedDialog<void>(
    context: context,
    disposables: [usdController, egpController],
    builder: (dialogContext) {
      return BorrowDialogView(
        params: BorrowDialogParams(
          dialogContext: dialogContext,
          currentUserId: currentUserId,
          currentUserEmail: currentUserEmail,
          friendId: friendId,
          friendName: friendName,
          myUsdBalance: myUsdBalance,
          myEgpBalance: myEgpBalance,
          friendUsdBalance: friendUsdBalance,
          friendEgpBalance: friendEgpBalance,
          initialBorrow: initialBorrow,
          usdController: usdController,
          egpController: egpController,
          onSave: onSave,
        ),
      );
    },
  );
}
