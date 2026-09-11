import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';
import '../c_app_dialog.dart';
import 'c_borrow_dialog_content.dart';
import 'c_borrow_dialog_models.dart';
import 'c_borrow_dialog_params.dart';
import 'c_borrow_submit_handler.dart';

/// Stateful view coordinator for the borrow/lend dialog.
class BorrowDialogView extends StatefulWidget {
  final BorrowDialogParams params;

  const BorrowDialogView({super.key, required this.params});

  @override
  State<BorrowDialogView> createState() => _BorrowDialogViewState();
}

class _BorrowDialogViewState extends State<BorrowDialogView> {
  final _formKey = GlobalKey<FormState>();
  late String _borrowMode;
  late DateTime _selectedDate;
  bool _isSubmitting = false;

  BorrowDialogParams get p => widget.params;

  @override
  void initState() {
    super.initState();
    _selectedDate = p.initialBorrow?.date ?? DateTime.now();
    _borrowMode = 'borrow';
    if (p.initialBorrow != null) {
      final bId = p.initialBorrow!.borrowerId.toLowerCase().trim();
      final cId = p.currentUserId.toLowerCase().trim();
      final cEmail = p.currentUserEmail?.toLowerCase().trim();
      _borrowMode = (bId == cId || (cEmail != null && bId == cEmail)) ? 'borrow' : 'lend';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borrowColor = isDark ? AppTheme.googleYellowDark : AppTheme.googleYellow;
    final usd = double.tryParse(p.usdController.text.trim()) ?? 0.0;
    final egp = double.tryParse(p.egpController.text.trim()) ?? 0.0;

    final limits = BorrowLimits.calculate(
      isBorrowMode: _borrowMode == 'borrow',
      myUsdBalance: p.myUsdBalance,
      myEgpBalance: p.myEgpBalance,
      friendUsdBalance: p.friendUsdBalance,
      friendEgpBalance: p.friendEgpBalance,
      initialBorrow: p.initialBorrow,
      currentUserId: p.currentUserId,
      friendId: p.friendId,
      enteredUsd: usd,
      enteredEgp: egp,
      isSubmitting: _isSubmitting,
    );

    void doSubmit() => BorrowSubmitHandler.submit(
          context: context,
          dialogContext: p.dialogContext,
          isBorrowMode: _borrowMode == 'borrow',
          currentUserId: p.currentUserId,
          friendId: p.friendId,
          friendName: p.friendName,
          usd: usd,
          egp: egp,
          selectedDate: _selectedDate,
          initialBorrow: p.initialBorrow,
          onSave: p.onSave,
          setSubmitting: (val) => setState(() => _isSubmitting = val),
        );

    return AppDialog(
      icon: Icons.handshake_outlined,
      iconColor: borrowColor,
      title: p.initialBorrow != null ? 'Edit Borrow Record' : 'Borrow Currency',
      actionLabel: 'Save',
      isSubmitting: _isSubmitting,
      onCancel: () => Navigator.of(p.dialogContext).pop(),
      onAction: limits.canSubmit ? doSubmit : null,
      content: BorrowDialogContent(
        formKey: _formKey,
        borrowMode: _borrowMode,
        friendName: p.friendName,
        isDark: isDark,
        borrowColor: borrowColor,
        usdController: p.usdController,
        egpController: p.egpController,
        isSubmitting: _isSubmitting,
        limits: limits,
        selectedDate: _selectedDate,
        onModeChanged: (m) => setState(() => _borrowMode = m),
        onChanged: () => setState(() {}),
        onDateChanged: (d) => setState(() => _selectedDate = d),
      ),
    );
  }
}
