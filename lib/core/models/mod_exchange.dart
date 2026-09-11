import '../utils/m_formatters.dart';

class Exchange {
  final String id;
  final String userId;
  final String fromCurrency; // 'USD' or 'EGP'
  final double fromAmount;
  final String toCurrency; // 'USD' or 'EGP'
  final double toAmount;
  final double exchangeRate;
  final DateTime date;
  final DateTime createdAt;

  const Exchange({
    required this.id,
    required this.userId,
    required this.fromCurrency,
    required this.fromAmount,
    required this.toCurrency,
    required this.toAmount,
    required this.exchangeRate,
    required this.date,
    required this.createdAt,
  }) : assert(fromCurrency != toCurrency, 'fromCurrency and toCurrency must be different');


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'from_currency': fromCurrency,
      'from_amount': fromAmount,
      'to_currency': toCurrency,
      'to_amount': toAmount,
      'exchange_rate': exchangeRate,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Exchange.fromMap(Map<String, dynamic>? rawMap, String documentId) {
    final map = rawMap ?? const <String, dynamic>{};
    return Exchange(
      id: documentId,
      userId: map['user_id'] as String? ?? '',
      fromCurrency: map['from_currency'] as String? ?? 'USD',
      fromAmount: (map['from_amount'] as num?)?.toDouble() ?? 0.0,
      toCurrency: map['to_currency'] as String? ?? 'EGP',
      toAmount: (map['to_amount'] as num?)?.toDouble() ?? 0.0,
      exchangeRate: (map['exchange_rate'] as num?)?.toDouble() ?? 1.0,
      date: Formatters.parseDate(map['date']),
      createdAt: Formatters.parseDate(map['created_at']),
    );
  }
}
