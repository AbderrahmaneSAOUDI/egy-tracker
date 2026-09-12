import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 't_button_input_themes.dart';
import 't_palette.dart';
import 't_surface_themes.dart';

export 't_button_input_themes.dart';
export 't_palette.dart';
export 't_surface_themes.dart';

/// Central theme configuration for egy_tracker.
/// Strictly forces Material 3 and configures cohesive Light and Dark modes.
class AppTheme {
  AppTheme._();

  static const String _themePrefKey = 'user_theme_mode_pref';
  static SharedPreferences? _prefs;

  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  static Future<void> initTheme([SharedPreferences? prefs]) async {
    try {
      _prefs = prefs ?? await SharedPreferences.getInstance();
      final savedMode = _prefs?.getString(_themePrefKey);
      if (savedMode != null) {
        themeModeNotifier.value = ThemeMode.values.firstWhere(
          (m) => m.name == savedMode,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (_) {}
  }

  static void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
    _prefs?.setString(_themePrefKey, mode.name);
  }

  // Backward-compatible palette aliases
  static const Color googleBlue = Color(0xFF1A73E8);
  static const Color googleBlueDark = Color(0xFF2563EB);
  static const Color googleRed = Color(0xFFD93025);
  static const Color googleRedDark = Color(0xFFF28B82);
  static const Color googleYellow = Color(0xFFF9AB00);
  static const Color googleYellowDark = Color(0xFFFDD663);
  static const Color googleGreen = Color(0xFF1E8E3E);
  static const Color googleGreenDark = Color(0xFF81C995);
  static const Color usdColorLight = googleGreen;
  static const Color usdColorDark = googleGreenDark;
  static const Color egpColorLight = googleYellow;
  static const Color egpColorDark = googleYellowDark;

  /// Light ThemeData (Material 3 forced)
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: surfaceLight,
        appBarTheme: buildAppBarTheme(
          backgroundColor: surfaceLight,
          foregroundColor: onSurfaceLight,
        ),
        cardTheme: buildCardTheme(
          surfaceColor: surfaceContainerLight,
          outlineColor: outlineVariantLight,
        ),
        filledButtonTheme: buildFilledButtonTheme(),
        outlinedButtonTheme: buildOutlinedButtonTheme(
          outlineColor: outlineVariantLight,
        ),
        inputDecorationTheme: lightInputDecorationThemeData(),
        navigationBarTheme: buildNavigationBarTheme(
          backgroundColor: surfaceLight,
          indicatorColor: googleBlue.withValues(alpha: 0.12),
          selectedColor: googleBlue,
          unselectedColor: outlineLight,
        ),
        dividerTheme: lightDividerThemeData(),
      );

  /// Dark ThemeData (Material 3 forced)
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: surfaceDark,
        appBarTheme: buildAppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: onSurfaceDark,
        ),
        cardTheme: buildCardTheme(
          surfaceColor: surfaceContainerDark,
          outlineColor: outlineVariantDark,
        ),
        filledButtonTheme: buildFilledButtonTheme(),
        outlinedButtonTheme: buildOutlinedButtonTheme(
          outlineColor: outlineVariantDark,
        ),
        inputDecorationTheme: darkInputDecorationThemeData(),
        navigationBarTheme: buildNavigationBarTheme(
          backgroundColor: surfaceContainerDark,
          indicatorColor: googleBlueDark.withValues(alpha: 0.20),
          selectedColor: googleBlueDark,
          unselectedColor: outlineDark,
        ),
        dividerTheme: darkDividerThemeData(),
      );
}
