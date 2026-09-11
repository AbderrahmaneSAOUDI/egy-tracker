import 'package:flutter/material.dart';
import '../../utils/m_formatters.dart';

/// Date selector with "Reset to now" button for borrow dialog.
class BorrowDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const BorrowDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (context.mounted) {
        onDateChanged(DateTime(
          picked.year,
          picked.month,
          picked.day,
          time?.hour ?? selectedDate.hour,
          time?.minute ?? selectedDate.minute,
        ));
      }
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
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 18, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Text(
                    Formatters.formatDate(selectedDate),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          icon: const Icon(Icons.restore_rounded, size: 20),
          tooltip: 'Reset to now',
          onPressed: () => onDateChanged(DateTime.now()),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
