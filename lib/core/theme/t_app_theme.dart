import 'package:flutter/material.dart';

/// Central theme configuration for egy_tracker.
/// Strictly forces Material 3 and configures cohesive Light and Dark modes.
class AppTheme {
  AppTheme._();

  /// Reactive notifier for the currently active ThemeMode (light, dark, or system/auto).
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  /// Helper to update the active theme mode.
  static void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }

  // ===================== GOOGLE BRAND PALETTE TOKENS =====================
  // Official Google Brand Colors
  static const Color googleBlue = Color(0xFF1A73E8);
  static const Color googleBlueDark = Color(0xFF8AB4F8);

  static const Color googleRed = Color(0xFFD93025);
  static const Color googleRedDark = Color(0xFFF28B82);

  static const Color googleYellow = Color(0xFFF9AB00);
  static const Color googleYellowDark = Color(0xFFFDD663);

  static const Color googleGreen = Color(0xFF1E8E3E);
  static const Color googleGreenDark = Color(0xFF81C995);

  // ===================== CURRENCY TOKENS =====================
  // Strictly independent currencies — never combined
  // USD is bound to Google Green; EGP is bound to Google Yellow
  static const Color usdColorLight = googleGreen;
  static const Color usdColorDark = googleGreenDark;

  static const Color egpColorLight = googleYellow;
  static const Color egpColorDark = googleYellowDark;

  // ===================== NEUTRAL BRAND SURFACES =====================
  // Google Light & Dark Surfaces
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _surfaceContainerLight = Color(0xFFF8F9FA);
  static const Color _onSurfaceLight = Color(0xFF202124);
  static const Color _onSurfaceVariantLight = Color(0xFF5F6368);
  static const Color _outlineLight = Color(0xFF80868B);
  static const Color _outlineVariantLight = Color(0xFFDADCE0);

  static const Color _surfaceDark = Color(0xFF121212);
  static const Color _surfaceContainerDark = Color(0xFF1E1E1E);
  static const Color _onSurfaceDark = Color(0xFFE8EAED);
  static const Color _onSurfaceVariantDark = Color(0xFF9AA0A6);
  static const Color _outlineDark = Color(0xFF5F6368);
  static const Color _outlineVariantDark = Color(0xFF3C4043);

  // ===================== COLOR SCHEMES =====================

  static ColorScheme get _lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: googleBlue,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFD2E3FC),
        onPrimaryContainer: Color(0xFF041E49),
        secondary: googleGreen,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFCEEAD6),
        onSecondaryContainer: Color(0xFF0D652D),
        tertiary: googleYellow,
        onTertiary: Color(0xFF202124),
        tertiaryContainer: Color(0xFFFEF7E0),
        onTertiaryContainer: Color(0xFF5F4000),
        error: googleRed,
        onError: Colors.white,
        errorContainer: Color(0xFFFAD2CF),
        onErrorContainer: Color(0xFFA50E0E),
        surface: _surfaceLight,
        onSurface: _onSurfaceLight,
        onSurfaceVariant: _onSurfaceVariantLight,
        outline: _outlineLight,
        outlineVariant: _outlineVariantLight,
        surfaceContainerLowest: Color(0xFFFFFFFF),
        surfaceContainerLow: Color(0xFFF8F9FA),
        surfaceContainer: Color(0xFFF1F3F4),
        surfaceContainerHigh: Color(0xFFE8EAED),
        surfaceContainerHighest: Color(0xFFDADCE0),
      );

  static ColorScheme get _darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: googleBlueDark,
        onPrimary: Color(0xFF041E49),
        primaryContainer: Color(0xFF174EA6),
        onPrimaryContainer: Color(0xFFD2E3FC),
        secondary: googleGreenDark,
        onSecondary: Color(0xFF0D652D),
        secondaryContainer: Color(0xFF0D652D),
        onSecondaryContainer: Color(0xFFCEEAD6),
        tertiary: googleYellowDark,
        onTertiary: Color(0xFF3B2800),
        tertiaryContainer: Color(0xFF5F4000),
        onTertiaryContainer: Color(0xFFFEF7E0),
        error: googleRedDark,
        onError: Color(0xFF601410),
        errorContainer: Color(0xFFA50E0E),
        onErrorContainer: Color(0xFFFAD2CF),
        surface: _surfaceDark,
        onSurface: _onSurfaceDark,
        onSurfaceVariant: _onSurfaceVariantDark,
        outline: _outlineDark,
        outlineVariant: _outlineVariantDark,
        surfaceContainerLowest: Color(0xFF0F0F0F),
        surfaceContainerLow: Color(0xFF18191A),
        surfaceContainer: Color(0xFF1E1E1E),
        surfaceContainerHigh: Color(0xFF28292A),
        surfaceContainerHighest: Color(0xFF303134),
      );

  // ===================== THEME DEFINITIONS =====================

  /// Light ThemeData (Material 3 forced)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: _surfaceLight,
      appBarTheme: _lightAppBarThemeData(),
      cardTheme: _lightCardThemeData(),
      filledButtonTheme: _filledButtonThemeData(),
      outlinedButtonTheme: _lightOutlinedButtonThemeData(),
      inputDecorationTheme: _lightInputDecorationThemeData(),
      navigationBarTheme: _lightNavigationBarThemeData(),
      dividerTheme: _lightDividerThemeData(),
    );
  }

  /// Dark ThemeData (Material 3 forced)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: _surfaceDark,
      appBarTheme: _darkAppBarThemeData(),
      cardTheme: _darkCardThemeData(),
      filledButtonTheme: _filledButtonThemeData(),
      outlinedButtonTheme: _darkOutlinedButtonThemeData(),
      inputDecorationTheme: _darkInputDecorationThemeData(),
      navigationBarTheme: _darkNavigationBarThemeData(),
      dividerTheme: _darkDividerThemeData(),
    );
  }

  // ===================== COMPONENT THEME EXTRACTS =====================

  // --- Card Themes ---
  static CardThemeData _lightCardThemeData() {
    return _buildCardTheme(
      surfaceColor: _surfaceContainerLight,
      outlineColor: _outlineVariantLight,
    );
  }

  static CardThemeData _darkCardThemeData() {
    return _buildCardTheme(
      surfaceColor: _surfaceContainerDark,
      outlineColor: _outlineVariantDark,
    );
  }

  static CardThemeData _buildCardTheme({
    required Color surfaceColor,
    required Color outlineColor,
  }) {
    return CardThemeData(
      elevation: 0,
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: outlineColor, width: 1),
      ),
      margin: EdgeInsets.zero,
    );
  }

  // --- AppBar Themes ---
  static AppBarTheme _lightAppBarThemeData() {
    return _buildAppBarTheme(
      backgroundColor: _surfaceLight,
      foregroundColor: _onSurfaceLight,
    );
  }

  static AppBarTheme _darkAppBarThemeData() {
    return _buildAppBarTheme(
      backgroundColor: _surfaceDark,
      foregroundColor: _onSurfaceDark,
    );
  }

  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      titleTextStyle: TextStyle(
        color: foregroundColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.2,
      ),
    );
  }

  // --- Button Themes ---
  static FilledButtonThemeData _filledButtonThemeData() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _lightOutlinedButtonThemeData() {
    return _buildOutlinedButtonTheme(outlineColor: _outlineVariantLight);
  }

  static OutlinedButtonThemeData _darkOutlinedButtonThemeData() {
    return _buildOutlinedButtonTheme(outlineColor: _outlineVariantDark);
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({
    required Color outlineColor,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        side: BorderSide(color: outlineColor, width: 1.2),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  // --- Input Decoration Themes ---
  static InputDecorationTheme _lightInputDecorationThemeData() {
    return _buildInputDecorationTheme(
      fillColor: _surfaceContainerLight,
      outlineColor: _outlineVariantLight,
      primaryColor: googleBlue,
      errorColor: googleRed,
    );
  }

  static InputDecorationTheme _darkInputDecorationThemeData() {
    return _buildInputDecorationTheme(
      fillColor: _surfaceContainerDark,
      outlineColor: _outlineVariantDark,
      primaryColor: googleBlueDark,
      errorColor: googleRedDark,
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color fillColor,
    required Color outlineColor,
    required Color primaryColor,
    required Color errorColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: outlineColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: outlineColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorColor),
      ),
    );
  }

  // --- Navigation Bar Themes ---
  static NavigationBarThemeData _lightNavigationBarThemeData() {
    return _buildNavigationBarTheme(
      backgroundColor: _surfaceLight,
      indicatorColor: googleBlue.withValues(alpha: 0.12),
      selectedColor: googleBlue,
      unselectedColor: _outlineLight,
    );
  }

  static NavigationBarThemeData _darkNavigationBarThemeData() {
    return _buildNavigationBarTheme(
      backgroundColor: _surfaceContainerDark,
      indicatorColor: googleBlueDark.withValues(alpha: 0.20),
      selectedColor: googleBlueDark,
      unselectedColor: _outlineDark,
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme({
    required Color backgroundColor,
    required Color indicatorColor,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return NavigationBarThemeData(
      height: 68,
      elevation: 0,
      backgroundColor: backgroundColor,
      indicatorColor: indicatorColor,
      indicatorShape: const StadiumBorder(),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: selectedColor,
            size: 24,
          );
        }
        return IconThemeData(
          color: unselectedColor,
          size: 24,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: selectedColor,
          );
        }
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: unselectedColor,
        );
      }),
    );
  }

  // --- Divider Themes ---
  static DividerThemeData _lightDividerThemeData() {
    return const DividerThemeData(
      color: _outlineVariantLight,
      thickness: 1,
      space: 1,
    );
  }

  static DividerThemeData _darkDividerThemeData() {
    return const DividerThemeData(
      color: _outlineVariantDark,
      thickness: 1,
      space: 1,
    );
  }
}
