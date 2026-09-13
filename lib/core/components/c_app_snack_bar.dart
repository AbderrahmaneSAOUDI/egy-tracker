import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/t_app_theme.dart';

/// Semantic types for styled application snackbars.
enum AppSnackBarType {
  success,
  error,
  info,
}

/// Helper for displaying premium, animated, floating snackbars.
class AppSnackBar {
  AppSnackBar._();

  /// Displays an animated floating snackbar with icon and haptic feedback.
  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.success,
    String? title,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    if (type == AppSnackBarType.error) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: duration,
        content: _AnimatedSnackBarCard(
          message: message,
          title: title,
          type: type,
        ),
      ),
    );
  }
}

class _AnimatedSnackBarCard extends StatefulWidget {
  final String message;
  final String? title;
  final AppSnackBarType type;

  const _AnimatedSnackBarCard({
    required this.message,
    this.title,
    required this.type,
  });

  @override
  State<_AnimatedSnackBarCard> createState() => _AnimatedSnackBarCardState();
}

class _AnimatedSnackBarCardState extends State<_AnimatedSnackBarCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _iconScaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _iconScaleAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final (accentColor, iconData) = switch (widget.type) {
      AppSnackBarType.success => (
          isDark ? AppTheme.googleGreenDark : AppTheme.googleGreen,
          Icons.check_circle_rounded,
        ),
      AppSnackBarType.error => (
          isDark ? AppTheme.googleRedDark : AppTheme.googleRed,
          Icons.error_outline_rounded,
        ),
      AppSnackBarType.info => (
          isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue,
          Icons.info_outline_rounded,
        ),
    };

    return ScaleTransition(
      scale: _scaleAnim,
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF25262B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ScaleTransition(
              scale: _iconScaleAnim,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 20,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null) ...[
                    Text(
                      widget.title!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFFE8EAED)
                          : const Color(0xFF3C4043),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
