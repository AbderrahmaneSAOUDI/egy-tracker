import 'package:flutter/material.dart';
import 'c_empty_state_content.dart';

export 'c_empty_state_content.dart';
export 'c_empty_state_icon.dart';

/// Reusable empty state component with circular tinted icon, title, subtitle,
/// and optional call-to-action widget.
class EmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.action,
    this.padding = const EdgeInsets.symmetric(vertical: 28),
  });

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = widget.iconColor ?? theme.colorScheme.primary;

    return Container(
      padding: widget.padding,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: EmptyStateContent(
            icon: widget.icon,
            title: widget.title,
            subtitle: widget.subtitle,
            iconColor: effectiveColor,
            isDark: isDark,
            action: widget.action,
          ),
        ),
      ),
    );
  }
}
