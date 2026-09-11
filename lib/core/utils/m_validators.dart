/// Pure Dart validation methods for egy_tracker.
class Validators {
  Validators._();

  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );

  /// Normalizes an email address, appending @gmail.com if no '@' symbol is present.
  static String normalizeEmail(String? value) {
    if (value == null) return '';
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    if (!trimmed.contains('@')) {
      return '$trimmed@gmail.com';
    }
    return trimmed;
  }

  /// Validates an email address.
  /// If [allowUsernameOnly] is true, strings without '@' will have '@gmail.com' appended before checking format.
  /// Returns null if valid, or an error string if invalid.
  static String? validateEmail(String? value, {bool allowUsernameOnly = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    final normalized = allowUsernameOnly ? normalizeEmail(value) : value.trim();
    if (!emailRegex.hasMatch(normalized)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a non-negative cash amount.
  static String? validateNonNegativeAmount(String? value, String currencyLabel) {
    if (value == null || value.trim().isEmpty) {
      return '$currencyLabel amount is required';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid numeric amount';
    }
    if (parsed < 0) {
      return '$currencyLabel amount cannot be negative';
    }
    return null;
  }

  /// Validates a strictly positive cash amount (> 0).
  static String? validatePositiveAmount(String? value, String currencyLabel) {
    if (value == null || value.trim().isEmpty) {
      return '$currencyLabel amount is required';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a valid numeric amount';
    }
    if (parsed <= 0) {
      return '$currencyLabel amount must be greater than zero';
    }
    return null;
  }

  /// Validates that from and to currencies are distinct and supported (USD/EGP).
  static String? validateExchangeCurrencies(String fromCurrency, String toCurrency) {
    if (fromCurrency.trim().toUpperCase() == toCurrency.trim().toUpperCase()) {
      return 'From and To currencies must be different';
    }
    const valid = {'USD', 'EGP'};
    if (!valid.contains(fromCurrency.trim().toUpperCase()) ||
        !valid.contains(toCurrency.trim().toUpperCase())) {
      return 'Currencies must be either USD or EGP';
    }
    return null;
  }

  /// Validates that a string field is not empty.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

