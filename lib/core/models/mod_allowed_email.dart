import '../utils/m_formatters.dart';

class AllowedEmail {
  final String id;
  final String email;
  final DateTime createdAt;

  const AllowedEmail({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email.toLowerCase().trim(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AllowedEmail.fromMap(Map<String, dynamic>? rawMap, String documentId) {
    final map = rawMap ?? const <String, dynamic>{};
    return AllowedEmail(
      id: documentId,
      email: (map['email'] as String? ?? '').toLowerCase().trim(),
      createdAt: Formatters.parseDate(map['created_at']),
    );
  }
}
