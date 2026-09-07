import 'package:flutter/material.dart';

/// Clean circular avatar that safely loads a profile photo from a network URL
/// with graceful fallback to user initials when offline or on image load failure.
class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String? name;
  final String? email;
  final double radius;
  final Color backgroundColor;
  final Color foregroundColor;

  const UserAvatar({
    super.key,
    this.photoUrl,
    this.name,
    this.email,
    this.radius = 20,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;
    final initial = (name != null && name!.trim().isNotEmpty)
        ? name!.trim()[0].toUpperCase()
        : (email != null && email!.trim().isNotEmpty)
            ? email!.trim()[0].toUpperCase()
            : 'U';

    final fallback = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.85,
          fontWeight: FontWeight.bold,
          color: foregroundColor,
        ),
      ),
    );

    if (!hasPhoto) {
      return fallback;
    }

    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.network(
          photoUrl!.trim(),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      ),
    );
  }
}
