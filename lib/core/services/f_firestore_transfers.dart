part of 'f_firestore.dart';

mixin FirestoreTransfersMixin on FirestoreServiceBase {
  // ===================== EXCHANGES =====================
  Stream<List<Exchange>> getExchangesStream() {
    try {
      return _exchangesCollection.snapshots().map((snapshot) {
        final list = snapshot.docs
            .map((doc) => Exchange.fromMap(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      }).handleError((error) {
        debugPrint('Firestore exchanges stream error: $error');
        return <Exchange>[];
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<void> addExchange(Exchange exchange) async {
    final docRef = _exchangesCollection.doc(exchange.id.isNotEmpty ? exchange.id : null);
    final toSave = Exchange(
      id: docRef.id,
      userId: exchange.userId,
      fromCurrency: exchange.fromCurrency,
      fromAmount: exchange.fromAmount,
      toCurrency: exchange.toCurrency,
      toAmount: exchange.toAmount,
      exchangeRate: exchange.exchangeRate,
      date: exchange.date,
      createdAt: exchange.createdAt,
    );
    await docRef.set(toSave.toMap());
  }

  Future<void> deleteExchange(String id) async {
    await _exchangesCollection.doc(id).delete();
  }

  // ===================== BORROWS =====================
  Stream<List<Borrow>> getBorrowsStream() {
    try {
      return _borrowsCollection.snapshots().map((snapshot) {
        final list = snapshot.docs
            .map((doc) => Borrow.fromMap(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      }).handleError((error) {
        debugPrint('Firestore borrows stream error: $error');
        return <Borrow>[];
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<void> addBorrow(Borrow borrow) async {
    final docRef = _borrowsCollection.doc(borrow.id.isNotEmpty ? borrow.id : null);
    final toSave = Borrow(
      id: docRef.id,
      borrowerId: borrow.borrowerId,
      lenderId: borrow.lenderId,
      usdAmount: borrow.usdAmount,
      egpAmount: borrow.egpAmount,
      date: borrow.date,
      createdAt: borrow.createdAt,
    );
    await docRef.set(toSave.toMap());
  }

  Future<void> deleteBorrow(String id) async {
    await _borrowsCollection.doc(id).delete();
  }
}
