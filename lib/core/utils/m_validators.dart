/// Pure Dart validation methods for egy_tracker.
class Validators {
  Validators._();

  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );

  /// Validates an email address.
  /// Returns null if valid, or an error string if invalid.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    final normalized = value.trim();
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

  /// Validates a non-empty required string.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
