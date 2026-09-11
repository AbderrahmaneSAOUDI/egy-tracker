/// Centralized app-wide configuration constants.
///
/// Extracted from hardcoded values across 8+ files to ensure
/// a single source of truth for admin identity and OAuth config.
class AppConfig {
  AppConfig._();

  /// The email address of the primary admin/owner of the trip tracker.
  /// Used for:
  /// - Default whitelist bypass (isEmailAllowed)
  /// - Sort priority in allowed_emails list
  /// - isPrimaryUser determination (first allowed email)
  /// - Dev login default email
  /// - Delete-all-data protection
  static const String adminEmail = 'abderrahmane.saoudi.26@gmail.com';

  /// Google OAuth server client ID for Google Sign-In.
  static const String serverClientId =
      '27615434041-rpa8j2d54r5pkpmoctpu3oe48s5jfads.apps.googleusercontent.com';
}
