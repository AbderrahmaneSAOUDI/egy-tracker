class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email.toLowerCase().trim(),
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic>? rawMap, String documentId) {
    final map = rawMap ?? const <String, dynamic>{};
    return UserProfile(
      id: documentId,
      name: map['name'] as String? ?? '',
      email: (map['email'] as String? ?? '').toLowerCase().trim(),
      photoUrl: map['photo_url'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
