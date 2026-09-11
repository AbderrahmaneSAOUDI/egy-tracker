part of 'c_slide_action_card.dart';

class _SlideActionCardState extends State<SlideActionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late Animation<double> _slideAnimation;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.addListener(() {
      setState(() {
        _dragOffset = _slideAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _animateBackToZero() {
    _slideAnimation = Tween<double>(
      begin: _dragOffset,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward(from: 0.0);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta ?? 0.0;
      if (widget.startAction == null && _dragOffset > 0) _dragOffset = 0.0;
      if (widget.endAction == null && _dragOffset < 0) _dragOffset = 0.0;
      _dragOffset = _dragOffset.clamp(-widget.maxActionWidth, widget.maxActionWidth);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset >= widget.triggerThreshold && widget.startAction != null) {
      widget.startAction!.onTrigger();
    } else if (_dragOffset <= -widget.triggerThreshold && widget.endAction != null) {
      widget.endAction!.onTrigger();
    }
    _animateBackToZero();
  }

  @override
  Widget build(BuildContext context) {
    final startWidth = _dragOffset > 0 ? _dragOffset : 0.0;
    final endWidth = _dragOffset < 0 ? -_dragOffset : 0.0;

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      onTap: () {
        if (_dragOffset.abs() > 5.0) {
          _animateBackToZero();
        } else {
          widget.onTap?.call();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: buildSlideActionRow(
        context: context,
        child: widget.child,
        startAction: widget.startAction,
        endAction: widget.endAction,
        startWidth: startWidth,
        endWidth: endWidth,
        maxActionWidth: widget.maxActionWidth,
        spacing: widget.spacing,
        onStartTrigger: () {
          widget.startAction?.onTrigger();
          _animateBackToZero();
        },
        onEndTrigger: () {
          widget.endAction?.onTrigger();
          _animateBackToZero();
        },
      ),
    );
  }
}
