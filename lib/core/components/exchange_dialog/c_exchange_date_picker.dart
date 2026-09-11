import 'package:flutter/material.dart';
import '../../utils/m_formatters.dart';

/// Date selector row with reset to now button for exchange dialog.
class ExchangeDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const ExchangeDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && context.mounted) {
      onDateChanged(DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDate.hour,
        selectedDate.minute,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _pickDateTime(context),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    Formatters.formatDate(selectedDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.restore_rounded, size: 18),
          tooltip: 'Reset to now',
          onPressed: () => onDateChanged(DateTime.now()),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }
}
