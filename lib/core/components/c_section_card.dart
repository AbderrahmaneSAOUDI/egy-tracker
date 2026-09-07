import 'package:flutter/material.dart';
import 'c_icon_badge.dart';

/// Reusable section card with standardized borders, background,
/// and clean header (IconBadge + Title + optional trailing widget).
class SectionCard extends StatefulWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final Widget? trailing;
  final Color? borderColor;
  final Widget child;

  const SectionCard({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.trailing,
    this.borderColor,
    required this.child,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = curve;
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(curve);
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

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF202124) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.borderColor ??
                  (isDark ? const Color(0xFF3C4043) : const Color(0xFFDADCE0)),
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(
                    icon: widget.icon,
                    color: widget.iconColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  ?widget.trailing,
                ],
              ),
              const SizedBox(height: 16),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
