import 'package:flutter/material.dart';

Widget buildCurrencySection({
  required String currencyCode,
  required String amountFormatted,
  required Color color,
  required bool isDark,
  required String keyPrefix,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.20 : 0.12),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              currencyCode,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Cash',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerRight,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              amountFormatted,
              key: ValueKey('${keyPrefix}_$amountFormatted'),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
                color: color,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    ],
  );
}
