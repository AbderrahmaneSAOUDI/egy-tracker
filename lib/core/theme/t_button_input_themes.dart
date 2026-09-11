import 'package:flutter/material.dart';
import 't_palette.dart';

FilledButtonThemeData buildFilledButtonTheme() {
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

OutlinedButtonThemeData buildOutlinedButtonTheme({
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

InputDecorationTheme buildInputDecorationTheme({
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

InputDecorationTheme lightInputDecorationThemeData() => buildInputDecorationTheme(
      fillColor: surfaceContainerLight,
      outlineColor: outlineVariantLight,
      primaryColor: googleBlue,
      errorColor: googleRed,
    );

InputDecorationTheme darkInputDecorationThemeData() => buildInputDecorationTheme(
      fillColor: surfaceContainerDark,
      outlineColor: outlineVariantDark,
      primaryColor: googleBlueDark,
      errorColor: googleRedDark,
    );
