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
      subtitle: 'Manage temporary travel records',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upon returning from Egypt, easily wipe all expenses, exchanges, starting balances, and profiles to reset the app.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          DangerButton(
            key: const ValueKey('delete_all_data_button'),
            label: 'Delete all data',
            onPressed: () => showDeleteAllDataDialog(
              context: context,
              onDeleteAllData: viewModel.deleteAllTripData,
            ),
          ),
        ],
      ),
    );
  }
}
