import 'package:flutter/material.dart';
import '../models/mod_activity_item.dart';
import '../theme/t_app_theme.dart';
import 'activity_tiles/c_activity_borrow_tile.dart';
import 'activity_tiles/c_activity_exchange_tile.dart';
import 'activity_tiles/c_activity_expense_tile.dart';
import 'c_slide_action_card.dart';


/// Interactive activity feed tile for expenses, exchanges, and borrows.
class ActivityTile extends StatelessWidget {
  final ActivityItem item;
  final String currentUserId;
  final String? currentUserEmail;
  final String? friendName;
  final bool isPrimaryUser;
  final bool isMyTrackerView;
  final double? personalShare;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ActivityTile({
    super.key,
    required this.item,
    required this.currentUserId,
    this.currentUserEmail,
    this.friendName,
    this.isPrimaryUser = true,
    this.isMyTrackerView = false,
    this.personalShare,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget cardFace;

    if (item.isExpense && item.expense != null) {
      cardFace = buildExpenseTile(
        context: context,
        expense: item.expense!,
        isDark: isDark,
        currentUserId: currentUserId,
        currentUserEmail: currentUserEmail,
        friendName: friendName,
        isPrimaryUser: isPrimaryUser,
        isMyTrackerView: isMyTrackerView,
        personalShare: personalShare,
      );
    } else if (item.isExchange && item.exchange != null) {
      cardFace = buildExchangeTile(
        context: context,
        exchange: item.exchange!,
        isDark: isDark,
        currentUserId: currentUserId,
        friendName: friendName,
      );
    } else if (item.isBorrow && item.borrow != null) {
      cardFace = buildBorrowTile(
        context: context,
        borrow: item.borrow!,
        isDark: isDark,
        currentUserId: currentUserId,
        currentUserEmail: currentUserEmail,
        friendName: friendName,
      );
    } else {
      cardFace = const SizedBox.shrink();
    }

    if (onDelete != null || onEdit != null) {
      final blue = isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue;
      final red = isDark ? AppTheme.googleRedDark : AppTheme.googleRed;
      return SlideActionCard(
        onTap: onTap,
        maxActionWidth: 88,
        triggerThreshold: 52,
        startAction: onEdit == null ? null : SlideActionItem(
          icon: Icons.edit_outlined,
          label: 'Edit',
          foregroundColor: Colors.white,
          backgroundColor: blue,
          onTrigger: onEdit!,
        ),
        endAction: onDelete == null ? null : SlideActionItem(
          icon: Icons.delete_outline_rounded,
          label: 'Delete',
          foregroundColor: Colors.white,
          backgroundColor: red,
          onTrigger: onDelete!,
        ),
        child: cardFace,
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: cardFace,
    );
  }
}
