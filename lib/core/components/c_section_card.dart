import 'package:flutter/material.dart';
import 'c_section_card_body.dart';
import 'c_section_card_decoration.dart';
import 'c_section_card_header.dart';

export 'c_section_card_body.dart';
export 'c_section_card_decoration.dart';
export 'c_section_card_header.dart';

part 'c_section_card_state.dart';

/// Reusable section card with standardized borders, background,
/// and clean header (IconBadge + Title + optional trailing widget).
class SectionCard extends StatefulWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? borderColor;
  final Widget child;
  final bool isCollapsible;
  final bool initiallyExpanded;

  const SectionCard({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.borderColor,
    required this.child,
    this.isCollapsible = false,
    this.initiallyExpanded = true,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}
