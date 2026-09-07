import 'dart:async';
import 'package:flutter/material.dart';

/// Automatically animates an item into view with a staggered fade and slide
/// based on its index position in a list.
class StaggeredItem extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final Duration delayPerIndex;
  final Offset slideOffset;

  const StaggeredItem({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 320),
    this.delayPerIndex = const Duration(milliseconds: 40),
    this.slideOffset = const Offset(0, 0.10),
  });

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fade = curve;
    _slide = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(curve);

    final delay = widget.delayPerIndex * widget.index;
    if (delay == Duration.zero) {
      _controller.forward();
    } else {
      _timer = Timer(delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: widget.child,
      ),
    );
  }
}
