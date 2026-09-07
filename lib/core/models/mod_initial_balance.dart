class InitialBalance {
  final String userId;
  final double usdAmount;
  final double egpAmount;
  final DateTime updatedAt;

  const InitialBalance({
    required this.userId,
    required this.usdAmount,
    required this.egpAmount,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'usd_amount': usdAmount,
      'egp_amount': egpAmount,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory InitialBalance.fromMap(Map<String, dynamic> map, String documentId) {
    return InitialBalance(
      userId: map['user_id'] as String? ?? documentId,
      usdAmount: (map['usd_amount'] as num?)?.toDouble() ?? 0.0,
      egpAmount: (map['egp_amount'] as num?)?.toDouble() ?? 0.0,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
