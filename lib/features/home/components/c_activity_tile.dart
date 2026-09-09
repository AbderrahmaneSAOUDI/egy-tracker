import 'package:flutter/material.dart';
import '../../../core/components/c_action_icon_button.dart';
import '../../../core/theme/t_app_theme.dart';
import '../../../core/utils/m_formatters.dart';
import '../models/mod_activity_item.dart';

/// Clean activity list item displaying either an Expense or a Currency Exchange.
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
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = curve;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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

    Widget content;
    if (widget.item.isExpense) {
      content = _buildExpenseTile(context, isDark);
    } else if (widget.item.isExchange) {
      content = _buildExchangeTile(context, isDark);
    } else {
      content = _buildBorrowTile(context, isDark);
    }

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: content,
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
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? const Color(0xFF202124) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0),
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currencyColor.withValues(alpha: isDark ? 0.15 : 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: currencyColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
                      const SizedBox(height: 2),
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
                const SizedBox(width: 8),
                // Amount & actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatCurrency(expense.amount, expense.currency),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: currencyColor,
                      ),
                    ),
                    if (onEdit != null || onDelete != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null) ...[
                            ActionIconButton(
                              icon: Icons.edit_outlined,
                              color: Theme.of(context).colorScheme.outline,
                              iconSize: 18,
                              onTap: onEdit,
                            ),
                            if (onDelete != null) const SizedBox(width: 4),
                          ],
                          if (onDelete != null)
                            ActionIconButton(
                              icon: Icons.delete_outline_rounded,
                              color: Theme.of(context).colorScheme.outline,
                              iconSize: 18,
                              onTap: onDelete,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
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
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? const Color(0xFF202124) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: exchangeColor.withValues(alpha: isDark ? 0.35 : 0.25),
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: exchangeColor.withValues(alpha: isDark ? 0.15 : 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sync_alt_rounded,
                    color: exchangeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
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
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Exchange',
                              style: TextStyle(
                                fontSize: 10,
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
                                fontSize: 13,
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
                      const SizedBox(height: 2),
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
                if (onEdit != null || onDelete != null) ...[
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null) ...[
                        ActionIconButton(
                          icon: Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.outline,
                          iconSize: 18,
                          onTap: onEdit,
                        ),
                        if (onDelete != null) const SizedBox(width: 4),
                      ],
                      if (onDelete != null)
                        ActionIconButton(
                          icon: Icons.delete_outline_rounded,
                          color: Theme.of(context).colorScheme.outline,
                          iconSize: 18,
                          onTap: onDelete,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
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
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? const Color(0xFF202124) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borrowColor.withValues(alpha: isDark ? 0.35 : 0.25),
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: borrowColor.withValues(alpha: isDark ? 0.15 : 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.handshake_outlined,
                    color: borrowColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
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
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isBorrower ? 'Borrowed' : 'Lent',
                              style: TextStyle(
                                fontSize: 10,
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
                                fontSize: 13,
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
                      const SizedBox(height: 2),
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
                if (onEdit != null || onDelete != null) ...[
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null) ...[
                        ActionIconButton(
                          icon: Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.outline,
                          iconSize: 18,
                          onTap: onEdit,
                        ),
                        if (onDelete != null) const SizedBox(width: 4),
                      ],
                      if (onDelete != null)
                        ActionIconButton(
                          icon: Icons.delete_outline_rounded,
                          color: Theme.of(context).colorScheme.outline,
                          iconSize: 18,
                          onTap: onDelete,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
