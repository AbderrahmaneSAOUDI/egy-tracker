part of 'c_section_card.dart';

class _SectionCardState extends State<SectionCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isCollapsible ? widget.initiallyExpanded : true;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _fade = curve;
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curve);
    _controller.forward();

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _isExpanded ? 1.0 : 0.0,
    );
    _expandAnimation = CurvedAnimation(parent: _expandController, curve: Curves.easeInOutCubic);
  }

  void _toggleExpanded() {
    if (!widget.isCollapsible) return;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: buildSectionCardDecoration(
            isDark: isDark,
            borderColor: widget.borderColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionCardHeader(
                icon: widget.icon,
                iconColor: widget.iconColor,
                title: widget.title,
                subtitle: widget.subtitle,
                trailing: widget.trailing,
                isCollapsible: widget.isCollapsible,
                expandAnimation: _expandAnimation,
                onToggle: _toggleExpanded,
              ),
              SectionCardBody(
                isCollapsible: widget.isCollapsible,
                expandAnimation: _expandAnimation,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
