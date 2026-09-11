import 'package:flutter/material.dart';
import 'c_slide_action_button.dart';
import 'c_slide_action_item.dart';

Widget buildSlideActionRow({
  required BuildContext context,
  required Widget child,
  required SlideActionItem? startAction,
  required SlideActionItem? endAction,
  required double startWidth,
  required double endWidth,
  required double maxActionWidth,
  required double spacing,
  required VoidCallback onStartTrigger,
  required VoidCallback onEndTrigger,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (startAction != null && startWidth > 0) ...[
        buildSlideActionCard(
          context: context,
          action: startAction,
          width: startWidth,
          maxActionWidth: maxActionWidth,
          onTrigger: onStartTrigger,
        ),
        SizedBox(width: (startWidth / maxActionWidth) * spacing),
      ],
      Expanded(child: child),
      if (endAction != null && endWidth > 0) ...[
        SizedBox(width: (endWidth / maxActionWidth) * spacing),
        buildSlideActionCard(
          context: context,
          action: endAction,
          width: endWidth,
          maxActionWidth: maxActionWidth,
          onTrigger: onEndTrigger,
        ),
      ],
    ],
  );
}
