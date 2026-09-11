import 'package:flutter/material.dart';

/// Calculation and validation for expense split percentages.
class ExpenseSplitCalculator {
  static (double mePct, double friendPct)? calculatePercentages({
    required BuildContext context,
    required String splitType,
    required String paidBy,
    required bool isPrimaryUser,
    required double customMePercentage,
    required double customFriendPercentage,
  }) {
    if (splitType == 'default_100') {
      if (paidBy == 'you') {
        return (isPrimaryUser ? 100.0 : 0.0, isPrimaryUser ? 0.0 : 100.0);
      } else {
        return (isPrimaryUser ? 0.0 : 100.0, isPrimaryUser ? 100.0 : 0.0);
      }
    } else if (splitType == 'fifty_fifty') {
      return (50.0, 50.0);
    } else {
      if ((customMePercentage + customFriendPercentage - 100.0).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Split percentages must sum to exactly 100%'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
      final me = isPrimaryUser ? customMePercentage : customFriendPercentage;
      final fr = isPrimaryUser ? customFriendPercentage : customMePercentage;
      return (me, fr);
    }
  }
}
