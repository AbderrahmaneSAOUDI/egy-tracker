class Expense {
  final String id;
  final String title;
  final double amount;
  final String currency; // 'USD' or 'EGP'
  final String paidBy; // user ID of the payer
  final String splitType; // 'default_100', 'fifty_fifty', 'custom'
  final double mePercentage;
  final double friendPercentage;
  final DateTime date;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.paidBy,
    required this.splitType,
    required this.mePercentage,
    required this.friendPercentage,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'currency': currency,
      'paid_by': paidBy,
      'split_type': splitType,
      'me_percentage': mePercentage,
      'friend_percentage': friendPercentage,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map, String documentId) {
    return Expense(
      id: documentId,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] as String? ?? 'USD',
      paidBy: map['paid_by'] as String? ?? '',
      splitType: map['split_type'] as String? ?? 'default_100',
      mePercentage: (map['me_percentage'] as num?)?.toDouble() ?? 100.0,
      friendPercentage: (map['friend_percentage'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] != null
          ? DateTime.tryParse(map['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
