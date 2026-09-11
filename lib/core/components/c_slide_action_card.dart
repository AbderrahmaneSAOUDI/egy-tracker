import 'package:flutter/material.dart';
import 'c_slide_action_item.dart';
import 'c_slide_action_row.dart';

export 'c_slide_action_button.dart';
export 'c_slide_action_item.dart';
export 'c_slide_action_row.dart';

part 'c_slide_action_card_state.dart';

/// A reusable modern card container featuring interactive side-sliding action cards.
class SlideActionCard extends StatefulWidget {
  final Widget child;
  final SlideActionItem? startAction;
  final SlideActionItem? endAction;
  final VoidCallback? onTap;
  final double maxActionWidth;
  final double triggerThreshold;
  final double spacing;

  const SlideActionCard({
    super.key,
    required this.child,
    this.startAction,
    this.endAction,
    this.onTap,
    this.maxActionWidth = 92.0,
    this.triggerThreshold = 55.0,
    this.spacing = 8.0,
  });

  @override
  State<SlideActionCard> createState() => _SlideActionCardState();
}
