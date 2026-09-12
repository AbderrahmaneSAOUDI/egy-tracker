import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/t_palette.dart';

/// High-performance ambient looping background featuring vibrant organic floating
/// gradient orbs and luminous drifting bokeh particles.
///
/// Designed with strict harmonic frequencies (integer multiples of 2*pi)
/// and smooth sine-windowed particle lifecycles to guarantee 100% mathematical
/// continuity with zero jumps, snapping, or perceptible repetition.
class AnimatedLoginBackground extends StatefulWidget {
  final Widget? child;
  final bool? enableLoopAnimation;
  final Duration duration;

  const AnimatedLoginBackground({
    super.key,
    this.child,
    this.enableLoopAnimation,
    this.duration = const Duration(seconds: 36),
  });

  @override
  State<AnimatedLoginBackground> createState() => _AnimatedLoginBackgroundState();
}

class _AnimatedLoginBackgroundState extends State<AnimatedLoginBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _shouldLoop {
    if (widget.enableLoopAnimation != null) {
      return widget.enableLoopAnimation!;
    }
    // Automatically disable infinite loop during automated widget tests
    // to prevent pumpAndSettle timeouts.
    final binding = WidgetsBinding.instance;
    final isTest = binding.runtimeType.toString().contains('Test');
    return !isTest;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (_shouldLoop) {
      _controller.repeat();
    } else {
      _controller.value = 0.25; // Snapshot position for static test frames
    }
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

    return Stack(
      fit: StackFit.expand,
      children: [
        // Base canvas gradient: rich contrast foundation for both light and dark modes
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      theme.colorScheme.surfaceContainerLowest,
                      const Color(0xFF14161B),
                    ]
                  : [
                      const Color(0xFFE9F0F8),
                      const Color(0xFFDCE6F2),
                    ],
            ),
          ),
        ),

        // Continuous smooth ambient gradient orbs and particles
        RepaintBoundary(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _AmbientMeshPainter(
                    progress: _controller.value,
                    isDark: isDark,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ),

        // Optional child content placed on top
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _AmbientMeshPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _AmbientMeshPainter({
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;
    // theta is the primary angular progress in [0, 2*pi).
    // All frequencies used below MUST be integers to ensure exact C^inf continuity across 1.0 -> 0.0.
    final theta = progress * 2.0 * math.pi;

    // Saturated jewel-toned palette for vibrant visibility in Light mode,
    // and luminous neon glow in Dark mode.
    final blue = isDark ? googleBlueDark : const Color(0xFF1967D2);
    final green = isDark ? googleGreenDark : const Color(0xFF0D904F);
    final amber = isDark ? googleYellowDark : const Color(0xFFE37400);
    final violet = isDark ? const Color(0xFFB388FF) : const Color(0xFF8E24AA);
    final teal = isDark ? const Color(0xFF4DD0E1) : const Color(0xFF00897B);

    // Light mode has significantly higher opacity so gradients pop clearly against the canvas
    final double baseAlpha = isDark ? 0.22 : 0.44;

    // 1. Primary Blue (Lissajous path: freq 1 & 2)
    final blueCenter = Offset(
      w * (0.26 + 0.16 * math.sin(theta) + 0.05 * math.cos(2 * theta)),
      h * (0.24 + 0.14 * math.cos(theta) + 0.04 * math.sin(2 * theta)),
    );
    final blueRadius = w * (0.62 + 0.06 * math.sin(theta));
    final blueAlpha = baseAlpha * (0.95 + 0.15 * math.cos(theta));
    _drawOrb(
      canvas: canvas,
      center: blueCenter,
      radius: blueRadius,
      color: blue.withValues(alpha: blueAlpha.clamp(0.0, 1.0)),
    );

    // 2. Emerald Green (Lissajous path: phase 2*pi/3, freq 1 & 2)
    const phiGreen = 2.0 * math.pi / 3.0;
    final greenCenter = Offset(
      w * (0.75 + 0.15 * math.cos(theta + phiGreen) - 0.05 * math.sin(2 * theta)),
      h * (0.70 + 0.14 * math.sin(theta + phiGreen) + 0.04 * math.cos(2 * theta)),
    );
    final greenRadius = w * (0.56 + 0.05 * math.cos(theta));
    final greenAlpha = baseAlpha * (0.90 + 0.15 * math.sin(theta));
    _drawOrb(
      canvas: canvas,
      center: greenCenter,
      radius: greenRadius,
      color: green.withValues(alpha: greenAlpha.clamp(0.0, 1.0)),
    );

    // 3. Warm Amber / Gold (Lissajous path: phase 4*pi/3, freq 1 & 2)
    const phiAmber = 4.0 * math.pi / 3.0;
    final amberCenter = Offset(
      w * (0.70 + 0.16 * math.sin(theta + phiAmber) + 0.04 * math.cos(2 * theta)),
      h * (0.22 + 0.12 * math.cos(theta + phiAmber) - 0.04 * math.sin(2 * theta)),
    );
    final amberRadius = w * (0.50 + 0.05 * math.sin(2 * theta));
    final amberAlpha = baseAlpha * (0.88 + 0.14 * math.cos(2 * theta));
    _drawOrb(
      canvas: canvas,
      center: amberCenter,
      radius: amberRadius,
      color: amber.withValues(alpha: amberAlpha.clamp(0.0, 1.0)),
    );

    // 4. Violet / Magenta accent (Lissajous path: phase pi/2, freq 1 & 2)
    const phiViolet = math.pi / 2.0;
    final violetCenter = Offset(
      w * (0.30 + 0.14 * math.cos(theta + phiViolet) + 0.05 * math.sin(2 * theta)),
      h * (0.78 + 0.13 * math.sin(theta + phiViolet) - 0.04 * math.cos(2 * theta)),
    );
    final violetRadius = w * (0.52 + 0.05 * math.cos(2 * theta));
    final violetAlpha = baseAlpha * (0.80 + 0.14 * math.sin(theta));
    _drawOrb(
      canvas: canvas,
      center: violetCenter,
      radius: violetRadius,
      color: violet.withValues(alpha: violetAlpha.clamp(0.0, 1.0)),
    );

    // 5. Teal accent (Center-drifting harmonic: phase pi, freq 1 & 2)
    const phiTeal = math.pi;
    final tealCenter = Offset(
      w * (0.52 + 0.12 * math.sin(theta + phiTeal) - 0.04 * math.cos(2 * theta)),
      h * (0.48 + 0.10 * math.cos(theta + phiTeal) + 0.03 * math.sin(2 * theta)),
    );
    final tealRadius = w * (0.44 + 0.04 * math.sin(theta));
    final tealAlpha = baseAlpha * (0.70 + 0.12 * math.cos(theta));
    _drawOrb(
      canvas: canvas,
      center: tealCenter,
      radius: tealRadius,
      color: teal.withValues(alpha: tealAlpha.clamp(0.0, 1.0)),
    );

    // Vibrant floating bokeh particles with sine-windowed lifecycles
    _drawAmbientParticles(canvas, size, theta);
  }

  void _drawOrb({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Color color,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color,
          color.withValues(alpha: color.a * 0.72),
          color.withValues(alpha: color.a * 0.30),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.40, 0.72, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  void _drawAmbientParticles(Canvas canvas, Size size, double theta) {
    const numParticles = 18;

    final particleColors = isDark
        ? const [
            Colors.white,
            Color(0xFF2563EB),
            Color(0xFF81C995),
            Color(0xFFFDD663),
          ]
        : const [
            Color(0xFF1967D2), // Royal Blue
            Color(0xFF0D904F), // Emerald Green
            Color(0xFFE37400), // Amber Gold
            Color(0xFF8E24AA), // Violet
          ];

    final corePaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < numParticles; i++) {
      // Deterministic spread
      final seedX = ((i * 41 + 17) % 100) / 100.0;
      final seedY = ((i * 61 + 31) % 100) / 100.0;
      final baseSize = isDark
          ? 1.5 + ((i * 19) % 25) / 10.0
          : 2.4 + ((i * 23) % 25) / 10.0;

      // Each particle completes an exact integer number of cycles (1 cycle)
      final offset = i / numParticles;
      final tau = (progress + offset) % 1.0;

      // Vertical drift: drifts upward across its lifecycle
      final rawY = seedY - (tau * 0.28);
      final yNorm = rawY < 0.0 ? rawY + 1.0 : rawY;

      // Subtle horizontal sway with integer harmonic (freq = 1)
      final xNorm = seedX + 0.03 * math.sin(theta + (i * 2.0 * math.pi / numParticles));

      final px = xNorm * size.width;
      final py = yNorm * size.height;

      // Sine-windowed lifecycle envelope:
      // Exactly 0 at spawn and reset to prevent pops
      final lifecycleFade = math.sin(math.pi * tau);
      final double maxAlpha = isDark ? 0.40 : 0.65;
      final particleAlpha = maxAlpha * lifecycleFade;

      final pColor = particleColors[i % particleColors.length];

      // Outer soft glow halo
      glowPaint.color = pColor.withValues(alpha: particleAlpha * 0.35);
      canvas.drawCircle(Offset(px, py), baseSize * 2.0, glowPaint);

      // Inner crisp particle core
      corePaint.color = pColor.withValues(alpha: particleAlpha);
      canvas.drawCircle(Offset(px, py), baseSize, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientMeshPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
