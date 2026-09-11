import 'package:flutter/material.dart';

/// Checkbox row for individual data deletion category.
class DeleteDataCheckboxRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final ColorScheme colorScheme;

  const DeleteDataCheckboxRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: colorScheme.error,
                checkColor: colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: colorScheme.error.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 16, color: colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
