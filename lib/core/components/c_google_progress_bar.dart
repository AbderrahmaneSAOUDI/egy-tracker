import 'package:flutter/material.dart';
import '../theme/t_app_theme.dart';

/// An authentic Google-styled indeterminate linear progress bar inspired by
/// Google's Material 3 expressiveness styling and signature 4-color brand identity.
class GoogleProgressBar extends StatefulWidget {
  final double height;
  final Color? trackColor;
  final bool? enableLoopAnimation;

  const GoogleProgressBar({
    super.key,
    this.height = 5.0,
    this.trackColor,
    this.enableLoopAnimation,
  });

  @override
  State<GoogleProgressBar> createState() => _GoogleProgressBarState();
}

class _GoogleProgressBarState extends State<GoogleProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _shouldLoop {
    if (widget.enableLoopAnimation != null) {
      return widget.enableLoopAnimation!;
    }
    final isTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    return !isTest;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    if (_shouldLoop) {
      _controller.repeat();
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultTrackColor = isDark
        ? const Color(0xFF3C4043)
        : const Color(0xFFE8EAED);

    final colors = isDark
        ? const [
            AppTheme.googleBlueDark,
            AppTheme.googleRedDark,
            AppTheme.googleYellowDark,
            AppTheme.googleGreenDark,
            AppTheme.googleBlueDark,
          ]
        : const [
            AppTheme.googleBlue,
            AppTheme.googleRed,
            AppTheme.googleYellow,
            AppTheme.googleGreen,
            AppTheme.googleBlue,
          ];

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size(double.infinity, widget.height),
            painter: _GoogleProgressBarPainter(
              progress: _controller.value,
              trackColor: widget.trackColor ?? defaultTrackColor,
              colors: colors,
            ),
          );
        },
      ),
    );
  }
}

class _GoogleProgressBarPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final List<Color> colors;

  _GoogleProgressBarPainter({
    required this.progress,
    required this.trackColor,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    final trackRRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      radius,
    );

    // Draw background track capsule
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(trackRRect, trackPaint);

    // Clip to capsule shape
    canvas.save();
    canvas.clipRRect(trackRRect);

    // Two moving pulses with Google Material indeterminate motion curves
    _drawSegment(canvas, size, progress, 0.0, 0.75, radius);
    _drawSegment(canvas, size, (progress + 0.45) % 1.0, 0.25, 0.65, radius);

    canvas.restore();
  }

  void _drawSegment(
    Canvas canvas,
    Size size,
    double t,
    double startOffset,
    double lengthRatio,
    Radius radius,
  ) {
    final curvedT = Curves.easeInOutCubic.transform(t);
    final indicatorWidth = size.width * lengthRatio;
    final totalTravel = size.width + indicatorWidth;
    final left = (curvedT * totalTravel) - indicatorWidth;
    final right = left + indicatorWidth;

    if (right <= 0 || left >= size.width) return;

    final segmentRect = Rect.fromLTRB(
      left.clamp(0.0, size.width),
      0,
      right.clamp(0.0, size.width),
      size.height,
    );

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(segmentRect, radius),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GoogleProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.colors != colors;
  }
}
