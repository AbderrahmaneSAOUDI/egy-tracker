import 'package:flutter/material.dart';
import '../utils/m_formatters.dart';

/// Scope providing a visit token to descendant [AnimatedCounter] widgets.
///
/// Whenever [token] changes (for example when the user switches tabs or navigates to a page),
/// descendant counters reset and re-run their increment animation from 0.0 to the target value.
class PageVisitScope extends InheritedWidget {
  final int token;

  const PageVisitScope({
    super.key,
    required this.token,
    required super.child,
  });

  static int of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PageVisitScope>();
    return scope?.token ?? 0;
  }

  @override
  bool updateShouldNotify(covariant PageVisitScope oldWidget) {
    return oldWidget.token != token;
  }
}

/// Generic animated counter that smoothly interpolates between numbers.
///
/// Animates from 0 to [value] on initial render, on every page open/switch (via [PageVisitScope]),
/// and smoothly interpolates to the new [value] whenever updated (e.g. from real-time Firebase streams).
class AnimatedCounter extends StatefulWidget {
  final double value;
  final Duration duration;
  final Curve curve;
  final Object? resetTrigger;
  final Widget Function(BuildContext context, double value) builder;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1300),
    this.curve = Curves.easeOutCubic,
    this.resetTrigger,
    required this.builder,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late Animation<double> _animation;
  bool _hasSettledFromZero = false;
  int? _lastVisitToken;

  double get _currentValue => _animation.value;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _setupAnimation(begin: 0.0, end: widget.value);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _hasSettledFromZero = true;
      }
    });

    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  void _setupAnimation({required double begin, required double end}) {
    _animation = Tween<double>(begin: begin, end: end).animate(_curvedAnimation);
  }

  void _animateFromZero() {
    _hasSettledFromZero = false;
    _setupAnimation(begin: 0.0, end: widget.value);
    _controller.forward(from: 0.0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentToken = PageVisitScope.of(context);
    if (_lastVisitToken != null && currentToken != _lastVisitToken) {
      _animateFromZero();
    }
    _lastVisitToken = currentToken;
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      _curvedAnimation.curve = widget.curve;
    }
    if (widget.resetTrigger != null &&
        widget.resetTrigger != oldWidget.resetTrigger) {
      _animateFromZero();
      return;
    }
    if (oldWidget.value != widget.value) {
      // If we haven't completed our initial rise from zero yet (e.g. first load from Firebase),
      // keep starting from 0.0 so the full increment animation is visible!
      final start = _hasSettledFromZero ? _currentValue : 0.0;
      _setupAnimation(begin: start, end: widget.value);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _curvedAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curvedAnimation,
      builder: (context, _) => widget.builder(context, _animation.value),
    );
  }
}

/// Specialized animated currency counter for USD and EGP.
///
/// Smoothly increments numbers on load, on page/tab visits, and updates in real time on data changes.
class AnimatedCurrencyCounter extends StatelessWidget {
  final double value;
  final String currency; // 'USD' or 'EGP'
  final TextStyle? style;
  final TextAlign textAlign;
  final Duration duration;
  final Curve curve;
  final Object? resetTrigger;
  final String Function(double value)? formatter;
  final int? maxLines;

  const AnimatedCurrencyCounter({
    super.key,
    required this.value,
    required this.currency,
    this.style,
    this.textAlign = TextAlign.right,
    this.duration = const Duration(milliseconds: 1300),
    this.curve = Curves.easeOutCubic,
    this.resetTrigger,
    this.formatter,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCounter(
      value: value,
      duration: duration,
      curve: curve,
      resetTrigger: resetTrigger,
      builder: (context, animatedValue) {
        final text = formatter != null
            ? formatter!(animatedValue)
            : Formatters.formatCurrency(animatedValue, currency);
        return Text(
          text,
          textAlign: textAlign,
          style: style,
          maxLines: maxLines,
        );
      },
    );
  }
}
