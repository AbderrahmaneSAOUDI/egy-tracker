import 'package:flutter/material.dart';

// ===================== GOOGLE BRAND PALETTE TOKENS =====================
const Color googleBlue = Color(0xFF1A73E8);
const Color googleBlueDark = Color(0xFF2563EB);

const Color googleRed = Color(0xFFD93025);
const Color googleRedDark = Color(0xFFF28B82);

const Color googleYellow = Color(0xFFF9AB00);
const Color googleYellowDark = Color(0xFFFDD663);

const Color googleGreen = Color(0xFF1E8E3E);
const Color googleGreenDark = Color(0xFF81C995);

// ===================== CURRENCY TOKENS =====================
const Color usdColorLight = googleGreen;
const Color usdColorDark = googleGreenDark;

const Color egpColorLight = googleYellow;
const Color egpColorDark = googleYellowDark;

// ===================== NEUTRAL BRAND SURFACES =====================
const Color surfaceLight = Color(0xFFFFFFFF);
const Color surfaceContainerLight = Color(0xFFF8F9FA);
const Color onSurfaceLight = Color(0xFF202124);
const Color onSurfaceVariantLight = Color(0xFF5F6368);
const Color outlineLight = Color(0xFF80868B);
const Color outlineVariantLight = Color(0xFFDADCE0);

const Color surfaceDark = Color(0xFF121212);
const Color surfaceContainerDark = Color(0xFF1E1E1E);
const Color onSurfaceDark = Color(0xFFE8EAED);
const Color onSurfaceVariantDark = Color(0xFF9AA0A6);
const Color outlineDark = Color(0xFF5F6368);
const Color outlineVariantDark = Color(0xFF3C4043);

// ===================== COLOR SCHEMES =====================
ColorScheme get lightColorScheme => const ColorScheme(
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
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      onSurfaceVariant: onSurfaceVariantLight,
      outline: outlineLight,
      outlineVariant: outlineVariantLight,
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF8F9FA),
      surfaceContainer: Color(0xFFF1F3F4),
      surfaceContainerHigh: Color(0xFFE8EAED),
      surfaceContainerHighest: Color(0xFFDADCE0),
    );

ColorScheme get darkColorScheme => const ColorScheme(
      brightness: Brightness.dark,
      primary: googleBlueDark,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF1D4ED8),
      onPrimaryContainer: Colors.white,
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
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      onSurfaceVariant: onSurfaceVariantDark,
      outline: outlineDark,
      outlineVariant: outlineVariantDark,
      surfaceContainerLowest: Color(0xFF0F0F0F),
      surfaceContainerLow: Color(0xFF18191A),
      surfaceContainer: Color(0xFF1E1E1E),
      surfaceContainerHigh: Color(0xFF28292A),
      surfaceContainerHighest: Color(0xFF303134),
    );
