import 'package:flutter/material.dart';

/// Standalone empty card displayed when no partner has been configured.
class EmptyTravelerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyTravelerCard({
    super.key,
    this.title = 'No Travel Partner Yet',
    this.subtitle = 'No travel partner added yet in Settings',
    this.icon = Icons.person_add_alt_1_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161920) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF262932) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F232B) : const Color(0xFFEDF2F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
