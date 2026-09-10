import 'package:flutter/material.dart';
import '../../../core/components/c_section_card.dart';
import '../../../core/components/c_segmented_pill_bar.dart';
import '../../../core/theme/t_app_theme.dart';

/// Interactive theme selector card for picking Light, Dark, or System mode.
/// Powered by the animated [SegmentedPillBar] for smooth sliding transitions.
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
      isCollapsible: true,
      initiallyExpanded: false,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.themeModeNotifier,
        builder: (context, activeMode, _) {
          return SegmentedPillBar<ThemeMode>(
            selectedValue: activeMode,
            onValueChanged: (mode) => AppTheme.setThemeMode(mode),
            items: const [
              SegmentedPillItem(
                value: ThemeMode.light,
                label: 'Light',
                icon: Icons.light_mode_rounded,
              ),
              SegmentedPillItem(
                value: ThemeMode.dark,
                label: 'Dark',
                icon: Icons.dark_mode_rounded,
              ),
              SegmentedPillItem(
                value: ThemeMode.system,
                label: 'Auto',
                icon: Icons.brightness_auto_rounded,
              ),
            ],
          );
        },
      ),
    );
  }
}
