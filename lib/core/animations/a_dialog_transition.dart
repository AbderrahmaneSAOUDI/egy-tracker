import 'package:flutter/material.dart';

/// Shows an animated modal dialog with smooth scale and fade in/out transitions.
Future<T?> showAnimatedDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  List<ChangeNotifier>? disposables,
  bool barrierDismissible = true,
  Duration duration = const Duration(milliseconds: 220),
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: 0.54),
    transitionDuration: duration,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final content = builder(dialogContext);
      if (disposables != null && disposables.isNotEmpty) {
        return DialogLifecycleWrapper(
          disposables: disposables,
          child: content,
        );
      }
      return content;
    },
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curve,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curve),
          child: child,
        ),
      );
    },
  );
}

/// A widget that manages disposing controllers and change notifiers when the dialog is unmounted.
class DialogLifecycleWrapper extends StatefulWidget {
  final List<ChangeNotifier> disposables;
  final Widget child;

  const DialogLifecycleWrapper({
    super.key,
    required this.disposables,
    required this.child,
  });

  @override
  State<DialogLifecycleWrapper> createState() => _DialogLifecycleWrapperState();
}

class _DialogLifecycleWrapperState extends State<DialogLifecycleWrapper> {
  @override
  void dispose() {
    for (final disposable in widget.disposables) {
      disposable.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
