import 'package:flutter/material.dart';
import '../../../core/components/c_section_card.dart';
import '../../../core/theme/t_app_theme.dart';
import 'c_theme_option_card.dart';

/// Interactive theme selector card for picking Light, Dark, or System mode.
class ThemeSelectorCard extends StatelessWidget {
  const ThemeSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SectionCard(
      icon: Icons.palette_rounded,
      iconColor: isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
      title: 'Theme Mode',
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.themeModeNotifier,
        builder: (context, activeMode, _) {
          return Row(
            children: [
              Expanded(
                child: ThemeOptionCard(
                  mode: ThemeMode.light,
                  title: 'Light',
                  icon: Icons.light_mode_rounded,
                  activeColor: isDark
                      ? AppTheme.googleYellowDark
                      : AppTheme.googleYellow,
                  isSelected: activeMode == ThemeMode.light,
                  onTap: () => AppTheme.setThemeMode(ThemeMode.light),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ThemeOptionCard(
                  mode: ThemeMode.dark,
                  title: 'Dark',
                  icon: Icons.dark_mode_rounded,
                  activeColor: isDark
                      ? AppTheme.googleBlueDark
                      : AppTheme.googleBlue,
                  isSelected: activeMode == ThemeMode.dark,
                  onTap: () => AppTheme.setThemeMode(ThemeMode.dark),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ThemeOptionCard(
                  mode: ThemeMode.system,
                  title: 'Auto',
                  icon: Icons.brightness_auto_rounded,
                  activeColor: isDark
                      ? AppTheme.googleGreenDark
                      : AppTheme.googleGreen,
                  isSelected: activeMode == ThemeMode.system,
                  onTap: () => AppTheme.setThemeMode(ThemeMode.system),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
