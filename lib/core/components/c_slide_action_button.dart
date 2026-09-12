import 'package:flutter/material.dart';
import 'c_slide_action_item.dart';

Widget buildSlideActionCard({
  required BuildContext context,
  required SlideActionItem action,
  required double width,
  required double maxActionWidth,
  required VoidCallback onTrigger,
}) {
  final progress = (width / maxActionWidth).clamp(0.0, 1.0);
  final iconScale = (0.6 + 0.4 * progress).clamp(0.6, 1.0);
  final borderRadius = action.borderRadius ?? BorderRadius.circular(14);

  return GestureDetector(
    onTap: onTrigger,
    child: Container(
      width: width,
      decoration: BoxDecoration(
        gradient: action.gradient,
        color: action.gradient == null
            ? (action.backgroundColor ?? Theme.of(context).colorScheme.primary)
            : null,
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: iconScale,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: action.foregroundColor.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action.icon,
                      color: action.foregroundColor,
                      size: 18,
                    ),
                  ),
                ),
                if (width >= 55) ...[
                  const SizedBox(height: 3),
                  Opacity(
                    opacity: ((width - 55) / 25).clamp(0.0, 1.0),
                    child: Text(
                      action.label,
                      style: TextStyle(
                        color: action.foregroundColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
