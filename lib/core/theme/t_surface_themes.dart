import 'package:flutter/material.dart';
import 't_palette.dart';

CardThemeData buildCardTheme({
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

AppBarTheme buildAppBarTheme({
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

NavigationBarThemeData buildNavigationBarTheme({
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
        return IconThemeData(color: selectedColor, size: 24);
      }
      return IconThemeData(color: unselectedColor, size: 24);
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

DividerThemeData lightDividerThemeData() => const DividerThemeData(
      color: outlineVariantLight,
      thickness: 1,
      space: 1,
    );

DividerThemeData darkDividerThemeData() => const DividerThemeData(
      color: outlineVariantDark,
      thickness: 1,
      space: 1,
    );
