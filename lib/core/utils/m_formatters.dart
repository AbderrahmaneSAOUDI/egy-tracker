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
}
