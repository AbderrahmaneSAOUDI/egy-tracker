import 'package:flutter/material.dart';
import '../animations/a_press_scale.dart';

/// Configuration for a sliding side action in [SlideActionCard].
class SlideActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTrigger;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color foregroundColor;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;

  const SlideActionItem({
    required this.icon,
    required this.label,
    required this.onTrigger,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderRadius,
    this.shadow,
  });
}

/// A reusable modern card container featuring interactive side-sliding action cards:
/// - Dragging Right grows [startAction] on the left side of the main item.
/// - Dragging Left grows [endAction] on the right side of the main item.
/// Actions sit beside the main item (not behind it) and expand organically with the drag.
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

class _SlideActionCardState extends State<SlideActionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _springController;
  Animation<double>? _springAnimation;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _springController.addListener(() {
      if (_springAnimation != null) {
        setState(() {
          _dragOffset = _springAnimation!.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _animateBackToZero() {
    _springAnimation = Tween<double>(
      begin: _dragOffset,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _springController,
      curve: Curves.easeOutCubic,
    ));
    _springController.forward(from: 0.0);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0.0;

    // Disallow dragging in a direction if the action is not configured
    if (_dragOffset + delta > 0 && widget.startAction == null) return;
    if (_dragOffset + delta < 0 && widget.endAction == null) return;

    if (_springController.isAnimating) {
      _springController.stop();
    }

    setState(() {
      _dragOffset += delta;
      if (_dragOffset > widget.maxActionWidth) {
        final excess = _dragOffset - widget.maxActionWidth;
        _dragOffset = widget.maxActionWidth + (excess * 0.25);
      } else if (_dragOffset < -widget.maxActionWidth) {
        final excess = _dragOffset + widget.maxActionWidth;
        _dragOffset = -widget.maxActionWidth + (excess * 0.25);
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0.0;
    if (widget.startAction != null &&
        (_dragOffset >= widget.triggerThreshold ||
            (velocity > 350 && _dragOffset > 15))) {
      widget.startAction!.onTrigger();
    } else if (widget.endAction != null &&
        (_dragOffset <= -widget.triggerThreshold ||
            (velocity < -350 && _dragOffset < -15))) {
      widget.endAction!.onTrigger();
    }
    _animateBackToZero();
  }

  @override
  Widget build(BuildContext context) {
    final hasStart = widget.startAction != null && _dragOffset > 0;
    final hasEnd = widget.endAction != null && _dragOffset < 0;
    final actionWidth = _dragOffset.abs().clamp(0.0, widget.maxActionWidth + 25.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Growing Start/Left Action Card (Beside main item)
            if (hasStart && actionWidth > 1.0) ...[
              _buildActionCard(context, widget.startAction!, actionWidth, true),
              SizedBox(width: widget.spacing),
            ],

            // 2. Main Card Face
            Expanded(
              child: PressScale(
                onTap: () {
                  if (_dragOffset.abs() > 5) {
                    _animateBackToZero();
                  } else {
                    widget.onTap?.call();
                  }
                },
                scaleDown: 0.98,
                child: widget.child,
              ),
            ),

            // 3. Growing End/Right Action Card (Beside main item)
            if (hasEnd && actionWidth > 1.0) ...[
              SizedBox(width: widget.spacing),
              _buildActionCard(context, widget.endAction!, actionWidth, false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    SlideActionItem action,
    double width,
    bool isStart,
  ) {
    final progress = (width / widget.maxActionWidth).clamp(0.0, 1.0);
    final iconScale = (0.6 + 0.4 * progress).clamp(0.6, 1.0);
    final borderRadius = action.borderRadius ?? BorderRadius.circular(20);

    return GestureDetector(
      onTap: () {
        action.onTrigger();
        _animateBackToZero();
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: action.gradient,
          color: action.gradient == null
              ? (action.backgroundColor ??
                  Theme.of(context).colorScheme.primary)
              : null,
          borderRadius: borderRadius,
          boxShadow: action.shadow != null ? [action.shadow!] : null,
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
}
