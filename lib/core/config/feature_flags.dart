/// Global compile-time and runtime feature flags for egy_tracker.
class FeatureFlags {
  FeatureFlags._();

  /// Whether debt lending / borrow currency records are enabled.
  /// Set to false to strictly enforce the MVP scope blacklist
  /// against debt settlement / optimization (Tier 2 item 2.11).
  static const bool enableBorrow = false;
}
