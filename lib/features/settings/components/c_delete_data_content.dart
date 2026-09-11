import 'package:flutter/material.dart';
import 'c_delete_data_checkbox_list.dart';
import 'c_delete_data_selection.dart';

/// Modal dialog content with data category checkboxes.
class DeleteDataContent extends StatelessWidget {
  final DeleteDataSelection selection;
  final VoidCallback onChanged;

  const DeleteDataContent({
    super.key,
    required this.selection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This action is irreversible. Choose which data to permanently delete:',
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trip Data Items:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                selection.toggleAll();
                onChanged();
              },
              child: Text(
                selection.allSelected ? 'Deselect All' : 'Select All',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        DeleteDataCheckboxList(
          selection: selection,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
        Text(
          'Your Google login access will remain active.',
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
