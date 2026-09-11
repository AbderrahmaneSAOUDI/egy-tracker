import '../utils/m_formatters.dart';

/// Immutable model representing physical money borrowed between users.
///
/// Borrower receives the cash (+), Lender hands over the cash (-).
class Borrow {
  final String id;
  final String borrowerId;
  final String lenderId;
  final double usdAmount;
  final double egpAmount;
  final DateTime date;
  final DateTime createdAt;

  const Borrow({
    required this.id,
    required this.borrowerId,
    required this.lenderId,
    required this.usdAmount,
    required this.egpAmount,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'borrower_id': borrowerId,
      'lender_id': lenderId,
      'usd_amount': usdAmount,
      'egp_amount': egpAmount,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Borrow.fromMap(Map<String, dynamic>? rawMap, String documentId) {
    final map = rawMap ?? const <String, dynamic>{};
    return Borrow(
      id: documentId,
      borrowerId: map['borrower_id'] as String? ?? '',
      lenderId: map['lender_id'] as String? ?? '',
      usdAmount: (map['usd_amount'] as num?)?.toDouble() ?? 0.0,
      egpAmount: (map['egp_amount'] as num?)?.toDouble() ?? 0.0,
      date: Formatters.parseDate(map['date']),
      createdAt: Formatters.parseDate(map['created_at']),
    );
  }

  Borrow copyWith({
    String? id,
    String? borrowerId,
    String? lenderId,
    double? usdAmount,
    double? egpAmount,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Borrow(
      id: id ?? this.id,
      borrowerId: borrowerId ?? this.borrowerId,
      lenderId: lenderId ?? this.lenderId,
      usdAmount: usdAmount ?? this.usdAmount,
      egpAmount: egpAmount ?? this.egpAmount,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
