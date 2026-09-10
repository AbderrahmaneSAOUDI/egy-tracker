import 'package:flutter/material.dart';
import '../models/mod_activity_item.dart';
import '../theme/t_app_theme.dart';
import '../utils/m_formatters.dart';
import 'c_slide_action_card.dart';

/// Clean activity list item displaying an Expense, Currency Exchange, or Borrow record.
///
/// Employs the reusable [SlideActionCard] to provide growing action cards beside
/// the main item:
/// - Slide Right (start-to-end) -> Update Card on the left.
/// - Slide Left (end-to-start) -> Remove Card on the right.
class ActivityTile extends StatefulWidget {
  final ActivityItem item;
  final String currentUserId;
  final String? currentUserEmail;
  final String? friendName;
  final double? personalShare;
  final bool isMyTrackerView;
  final bool isPrimaryUser;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActivityTile({
    super.key,
    required this.item,
    required this.currentUserId,
    this.currentUserEmail,
    this.friendName,
    this.personalShare,
    this.isMyTrackerView = false,
    this.isPrimaryUser = true,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    final curve = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _fade = curve;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(curve);
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  ActivityItem get item => widget.item;
  String get currentUserId => widget.currentUserId;
  String? get friendName => widget.friendName;
  double? get personalShare => widget.personalShare;
  bool get isMyTrackerView => widget.isMyTrackerView;
  bool get isPrimaryUser => widget.isPrimaryUser;
  VoidCallback? get onEdit => widget.onEdit;
  VoidCallback? get onDelete => widget.onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget cardFace;
    if (widget.item.isExpense) {
      cardFace = _buildExpenseTile(context, isDark);
    } else if (widget.item.isExchange) {
      cardFace = _buildExchangeTile(context, isDark);
    } else {
      cardFace = _buildBorrowTile(context, isDark);
    }

    final slidingTile = SlideActionCard(
      onTap: null,
      startAction: onEdit != null
          ? SlideActionItem(
              icon: Icons.edit_outlined,
              label: 'Update',
              gradient: LinearGradient(
                colors: isDark
                    ? const [Color(0xFF1E3A8A), Color(0xFF2563EB)]
                    : const [Color(0xFF2563EB), Color(0xFF60A5FA)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onTrigger: onEdit!,
            )
          : null,
      endAction: onDelete != null
          ? SlideActionItem(
              icon: Icons.delete_outline_rounded,
              label: 'Remove',
              gradient: LinearGradient(
                colors: isDark
                    ? const [Color(0xFF7F1D1D), Color(0xFFDC2626)]
                    : const [Color(0xFFDC2626), Color(0xFFF87171)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              onTrigger: onDelete!,
            )
          : null,
      child: cardFace,
    );

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: slidingTile,
      ),
    );
  }

  Widget _buildExpenseTile(BuildContext context, bool isDark) {
    final expense = item.expense!;
    final isUsd = expense.currency.toUpperCase().trim() == 'USD';
    final currencyColor = isUsd
        ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
        : (isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight);

    final payerId = expense.paidBy.toLowerCase().trim();
    final isPaidByMe = payerId == widget.currentUserId.toLowerCase().trim() ||
        (widget.currentUserEmail != null &&
            payerId == widget.currentUserEmail!.toLowerCase().trim());
    final payerLabel = isPaidByMe ? 'Paid by You' : 'Paid by ${widget.friendName ?? "Friend"}';

    final myPct = isPrimaryUser ? expense.mePercentage : expense.friendPercentage;
    final friendPct = isPrimaryUser ? expense.friendPercentage : expense.mePercentage;

    String splitLabel;
    if (myPct == 100.0) {
      splitLabel = '100% You';
    } else if (friendPct == 100.0) {
      splitLabel = '100% ${friendName ?? "Friend"}';
    } else if (expense.splitType == 'fifty_fifty' ||
        (expense.mePercentage == 50.0 && expense.friendPercentage == 50.0)) {
      splitLabel = '50/50';
    } else {
      splitLabel = '${myPct.toInt()}% / ${friendPct.toInt()}%';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1D22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2E37) : const Color(0xFFE5E7EB),
          width: 1.1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Creative squircle badge with subtle currency aura
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: currencyColor.withValues(alpha: isDark ? 0.16 : 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: currencyColor.withValues(alpha: isDark ? 0.25 : 0.18),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: currencyColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '$payerLabel · $splitLabel',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  Formatters.formatDate(expense.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Amount
          if (isMyTrackerView && personalShare != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatters.formatCurrency(personalShare!, expense.currency),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                    color: currencyColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  personalShare != expense.amount
                      ? 'Total: ${Formatters.formatCurrency(expense.amount, expense.currency)}'
                      : 'My share: 100%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            )
          else
            Text(
              Formatters.formatCurrency(expense.amount, expense.currency),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: currencyColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExchangeTile(BuildContext context, bool isDark) {
    final exchange = item.exchange!;
    final exchangeColor = isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue;
    final isByMe = exchange.userId == currentUserId;
    final userLabel = isByMe ? 'By You' : 'By ${friendName ?? "Friend"}';

    final fromFormatted =
        Formatters.formatCurrency(exchange.fromAmount, exchange.fromCurrency);
    final toFormatted =
        Formatters.formatCurrency(exchange.toAmount, exchange.toCurrency);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1D22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: exchangeColor.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1.1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Squircle exchange icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: exchangeColor.withValues(alpha: isDark ? 0.16 : 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: exchangeColor.withValues(alpha: isDark ? 0.30 : 0.20),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.sync_alt_rounded,
              color: exchangeColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$fromFormatted → $toFormatted',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '$userLabel · Rate: ${exchange.exchangeRate.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  Formatters.formatDate(exchange.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: exchangeColor.withValues(alpha: isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Exchange',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: exchangeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowTile(BuildContext context, bool isDark) {
    final borrow = item.borrow!;
    final borrowerId = borrow.borrowerId.toLowerCase().trim();
    final isBorrower = borrowerId == widget.currentUserId.toLowerCase().trim() ||
        (widget.currentUserEmail != null &&
            borrowerId == widget.currentUserEmail!.toLowerCase().trim());
    final borrowColor = isDark ? AppTheme.googleYellowDark : AppTheme.googleYellow;

    final name = widget.friendName ?? 'Friend';
    final actionTitle = isBorrower ? 'Borrowed from $name' : 'Lent to $name';

    final List<String> amounts = [];
    if (borrow.usdAmount > 0) {
      amounts.add(Formatters.formatUsd(borrow.usdAmount));
    }
    if (borrow.egpAmount > 0) {
      amounts.add(Formatters.formatEgp(borrow.egpAmount));
    }
    final amountsText = amounts.join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1D22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borrowColor.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1.1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Squircle borrow icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: borrowColor.withValues(alpha: isDark ? 0.16 : 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borrowColor.withValues(alpha: isDark ? 0.30 : 0.20),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.handshake_rounded,
              color: borrowColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  amountsText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isBorrower
                        ? (isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen)
                        : (isDark ? AppTheme.googleRedDark : AppTheme.googleRed),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  Formatters.formatDate(borrow.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: borrowColor.withValues(alpha: isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isBorrower ? 'Borrowed' : 'Lent',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: borrowColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
