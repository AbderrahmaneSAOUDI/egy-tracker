import 'package:flutter/material.dart';
import '../../../core/components/c_danger_button.dart';
import '../../../core/components/c_section_card.dart';
import '../vm_settings.dart';
import 'c_delete_data_dialog.dart';

/// Danger zone card with high-visibility button to purge all trip data.
class DeleteDataCard extends StatelessWidget {
  final SettingsViewModel viewModel;

  const DeleteDataCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SectionCard(
      icon: Icons.delete_sweep_rounded,
      iconColor: colorScheme.error,
      borderColor: colorScheme.error.withValues(alpha: isDark ? 0.35 : 0.25),
      title: 'Trip Data & Reset',
      child: DangerButton(
        key: const ValueKey('delete_all_data_button'),
        label: 'Delete all data',
        onPressed: () => showDeleteAllDataDialog(
          context: context,
          onDeleteAllData: viewModel.deleteAllTripData,
        ),
      ),
    );
  }
}
