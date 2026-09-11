import 'package:flutter/foundation.dart';

/// Formatters for currency and numbers in egy_tracker.
class Formatters {
  Formatters._();

  /// Formats an amount with commas and 2 decimal places.
  static String formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    final isNegative = integerPart.startsWith('-');
    final digits = isNegative ? integerPart.substring(1) : integerPart;

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }

    return '${isNegative ? '-' : ''}${buffer.toString()}.$decimalPart';
  }

  /// Formats a USD amount, e.g. `$100.00` or `-$25.50`.
  static String formatUsd(double amount) {
    if (amount < 0) {
      return '-\$${formatAmount(amount.abs())}';
    }
    return '\$${formatAmount(amount)}';
  }

  /// Formats an EGP amount, e.g. `1,500.00 EGP` or `-500.00 EGP`.
  static String formatEgp(double amount) {
    return '${formatAmount(amount)} EGP';
  }

  /// Formats an amount based on currency string ('USD' or 'EGP').
  static String formatCurrency(double amount, String currency) {
    if (currency.toUpperCase().trim() == 'USD') {
      return formatUsd(amount);
    }
    return formatEgp(amount);
  }

  /// Formats a DateTime into a human-friendly string, e.g. `Sep 7, 2:30 PM`.
  static String formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dt.month - 1];
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month ${dt.day}, $hour:$minute $period';
  }

  /// Safely parses a dynamic date value from Firestore (Timestamp, DateTime, or ISO string).
  static DateTime parseDate(dynamic val, [DateTime? fallback]) {
    if (val == null) {
      if (fallback != null) return fallback;
      debugPrint('Formatters.parseDate warning: null date value provided; defaulting to DateTime.now()');
      return DateTime.now();
    }
    if (val is DateTime) return val;
    if (val is String) {
      final parsed = DateTime.tryParse(val);
      if (parsed != null) return parsed;
    }
    try {
      final dt = (val as dynamic).toDate();
      if (dt is DateTime) return dt;
    } catch (_) {}
    final fallbackParsed = DateTime.tryParse(val.toString());
    if (fallbackParsed != null) return fallbackParsed;

    debugPrint('Formatters.parseDate warning: Invalid date value "$val"; falling back to default.');
    return fallback ?? DateTime.now();
  }
}
