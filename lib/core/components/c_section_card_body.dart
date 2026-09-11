import 'package:flutter/material.dart';

/// Body wrapper for SectionCard supporting collapsible SizeTransition.
class SectionCardBody extends StatelessWidget {
  final bool isCollapsible;
  final Animation<double> expandAnimation;
  final Widget child;

  const SectionCardBody({
    super.key,
    required this.isCollapsible,
    required this.expandAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCollapsible) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: child,
      );
    }
    return SizeTransition(
      sizeFactor: expandAnimation,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: child,
      ),
    );
  }
}
