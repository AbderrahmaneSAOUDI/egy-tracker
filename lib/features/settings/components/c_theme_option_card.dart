import 'package:flutter/material.dart';

/// Reusable interactive card for choosing a single ThemeMode (Light, Dark, Auto).
class ThemeOptionCard extends StatelessWidget {
  final ThemeMode mode;
  final String title;
  final IconData icon;
  final Color activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeOptionCard({
    super.key,
    required this.mode,
    required this.title,
    required this.icon,
    required this.activeColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? activeColor.withValues(alpha: isDark ? 0.18 : 0.12)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : const Color(0xFFF8F9FA)),
          border: Border.all(
            color: isSelected
                ? activeColor.withValues(alpha: 0.8)
                : (isDark
                    ? const Color(0xFF3C4043)
                    : const Color(0xFFE8EAED)),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 260),
              scale: isSelected ? 1.15 : 1.0,
              curve: Curves.easeOutBack,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? activeColor.withValues(alpha: isDark ? 0.25 : 0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? activeColor : colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : colorScheme.onSurface)
                    : colorScheme.outline,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: isSelected ? 6 : 0,
              height: isSelected ? 6 : 0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
