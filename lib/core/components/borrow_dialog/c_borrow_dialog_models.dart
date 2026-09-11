import '../../models/mod_borrow.dart';

/// Helper for calculating limits and validating borrow transactions.
class BorrowLimits {
  final double effectiveLimitUsd;
  final double effectiveLimitEgp;
  final double sourceUsdBalance;
  final double sourceEgpBalance;
  final bool isOverUsd;
  final bool isOverEgp;
  final bool canSubmit;

  BorrowLimits({
    required this.effectiveLimitUsd,
    required this.effectiveLimitEgp,
    required this.sourceUsdBalance,
    required this.sourceEgpBalance,
    required this.isOverUsd,
    required this.isOverEgp,
    required this.canSubmit,
  });

  factory BorrowLimits.calculate({
    required bool isBorrowMode,
    required double myUsdBalance,
    required double myEgpBalance,
    required double friendUsdBalance,
    required double friendEgpBalance,
    required Borrow? initialBorrow,
    required String currentUserId,
    required String friendId,
    required double enteredUsd,
    required double enteredEgp,
    required bool isSubmitting,
  }) {
    final effectiveLimitUsd = isBorrowMode
        ? (friendUsdBalance +
            (initialBorrow != null && initialBorrow.lenderId == friendId
                ? initialBorrow.usdAmount
                : 0.0))
        : (myUsdBalance +
            (initialBorrow != null && initialBorrow.lenderId == currentUserId
                ? initialBorrow.usdAmount
                : 0.0));

    final effectiveLimitEgp = isBorrowMode
        ? (friendEgpBalance +
            (initialBorrow != null && initialBorrow.lenderId == friendId
                ? initialBorrow.egpAmount
                : 0.0))
        : (myEgpBalance +
            (initialBorrow != null && initialBorrow.lenderId == currentUserId
                ? initialBorrow.egpAmount
                : 0.0));

    final sourceUsd = isBorrowMode ? friendUsdBalance : myUsdBalance;
    final sourceEgp = isBorrowMode ? friendEgpBalance : myEgpBalance;

    final isOverUsd = sourceUsd > 0 && enteredUsd > effectiveLimitUsd;
    final isOverEgp = sourceEgp > 0 && enteredEgp > effectiveLimitEgp;

    final canSubmit = (enteredUsd > 0 || enteredEgp > 0) &&
        enteredUsd >= 0 &&
        enteredEgp >= 0 &&
        !isOverUsd &&
        !isOverEgp &&
        !isSubmitting;

    return BorrowLimits(
      effectiveLimitUsd: effectiveLimitUsd,
      effectiveLimitEgp: effectiveLimitEgp,
      sourceUsdBalance: sourceUsd,
      sourceEgpBalance: sourceEgp,
      isOverUsd: isOverUsd,
      isOverEgp: isOverEgp,
      canSubmit: canSubmit,
    );
  }
}
