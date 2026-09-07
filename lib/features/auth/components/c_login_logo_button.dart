import 'package:flutter/material.dart';
import '../../../core/animations/a_press_scale.dart';

/// App logo button used on Login screen with tap-to-auto-login feature for developer convenience.
class LoginLogoButton extends StatelessWidget {
  final VoidCallback? onTap;

  const LoginLogoButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: PressScale(
        key: const Key('login_logo_button'),
        onTap: onTap,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.account_balance_wallet_rounded,
                size: 36,
                color: theme.colorScheme.primary,
              );
            },
          ),
        ),
      ),
    );
  }
}
