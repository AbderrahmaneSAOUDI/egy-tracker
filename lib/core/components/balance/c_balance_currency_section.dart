import 'package:flutter/material.dart';
import '../../animations/a_animated_counter.dart';

Widget buildCurrencySection({
  required String currencyCode,
  required double amount,
  String? amountFormatted,
  required Color color,
  required bool isDark,
  required String keyPrefix,
}) {
  return Align(
    alignment: Alignment.center,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: AnimatedCurrencyCounter(
        key: ValueKey('${keyPrefix}_counter'),
        value: amount,
        currency: currencyCode,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.6,
          color: color,
        ),
        maxLines: 1,
      ),
    ),
  );
}
