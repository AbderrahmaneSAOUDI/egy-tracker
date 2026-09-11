import 'package:flutter/material.dart';

/// Slider and label row for custom split percentage in expense dialog.
class ExpenseCustomSplitSlider extends StatelessWidget {
  final double customMePercentage;
  final double customFriendPercentage;
  final String friendName;
  final Color blueColor;
  final Color outlineColor;
  final void Function(double mePct, double friendPct) onCustomPercentageChanged;

  const ExpenseCustomSplitSlider({
    super.key,
    required this.customMePercentage,
    required this.customFriendPercentage,
    required this.friendName,
    required this.blueColor,
    required this.outlineColor,
    required this.onCustomPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'You: ${customMePercentage.toInt()}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: blueColor,
              ),
            ),
            Text(
              '$friendName: ${customFriendPercentage.toInt()}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: outlineColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: blueColor,
            thumbColor: blueColor,
            overlayColor: blueColor.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: customMePercentage,
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: (val) => onCustomPercentageChanged(val, 100 - val),
          ),
        ),
      ],
    );
  }
}
