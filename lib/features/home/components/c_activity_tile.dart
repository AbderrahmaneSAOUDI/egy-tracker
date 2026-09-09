import 'package:flutter/material.dart';
import '../../../core/components/c_slide_action_card.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_formatters.dart';
import '../models/mod_activity_item.dart';

/// Clean activity list item displaying an Expense, Currency Exchange, or Borrow record.
///
/// Employs the reusable [SlideActionCard] to provide growing action cards beside
/// the main item:
/// - Slide Right (start-to-end) -> Update Card on the left.
/// - Slide Left (end-to-start) -> Remove Card on the right.
class ActivityTile extends StatefulWidget {
  final ActivityItem item;
  final String currentUserId;
  final String? friendName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActivityTile({
    super.key,
    required this.item,
    required this.currentUserId,
    this.friendName,
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
      onTap: onEdit,
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
              shadow: BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
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
              shadow: BoxShadow(
                color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
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

    final isPaidByMe = expense.paidBy == currentUserId;
    final payerLabel = isPaidByMe ? 'Paid by You' : 'Paid by ${friendName ?? "Friend"}';

    String splitLabel;
    if (expense.mePercentage == 100.0) {
      splitLabel = '100% You';
    } else if (expense.friendPercentage == 100.0) {
      splitLabel = '100% ${friendName ?? "Friend"}';
    } else if (expense.splitType == 'fifty_fifty' ||
        (expense.mePercentage == 50.0 && expense.friendPercentage == 50.0)) {
      splitLabel = '50/50';
    } else {
      splitLabel = '${expense.mePercentage.toInt()}% / ${expense.friendPercentage.toInt()}%';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1D22) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2E37) : const Color(0xFFE5E7EB),
          width: 1.1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1D22) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: exchangeColor.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1.1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: exchangeColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$fromFormatted → $toFormatted',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$userLabel · Rate: ${exchange.exchangeRate.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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
        ],
      ),
    );
  }

  Widget _buildBorrowTile(BuildContext context, bool isDark) {
    final borrow = item.borrow!;
    final isBorrower = borrow.borrowerId == currentUserId;
    final borrowColor = isDark ? AppTheme.googleYellowDark : AppTheme.googleYellow;

    final name = friendName ?? 'Friend';
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1D22) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borrowColor.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1.1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: borrowColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        actionTitle,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  amountsText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isBorrower
                        ? (isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen)
                        : (isDark ? AppTheme.googleRedDark : AppTheme.googleRed),
                  ),
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
        ],
      ),
    );
  }
}
