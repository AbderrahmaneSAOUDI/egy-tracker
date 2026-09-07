import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Standard Google Sign In branded button with loading state.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSigningIn;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isSigningIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: isSigningIn ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor:
              isDark ? theme.colorScheme.surfaceContainer : Colors.white,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isSigningIn
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            : SvgPicture.asset(
                'assets/images/logo_google.svg',
                width: 20,
                height: 20,
                placeholderBuilder: (context) => const Icon(
                  Icons.g_mobiledata_rounded,
                  size: 22,
                ),
              ),
        label: Text(
          isSigningIn ? 'Signing in...' : 'Sign in with Google',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
