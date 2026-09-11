part of 'f_firestore.dart';

mixin FirestoreExpensesMixin on FirestoreServiceBase {
  Stream<List<Expense>> getExpensesStream() {
    try {
      return _expensesCollection.snapshots().map((snapshot) {
        final list = snapshot.docs
            .map((doc) => Expense.fromMap(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      });
    } catch (_) {
      return const Stream.empty();
    }
  }

  Future<void> addExpense(Expense expense) async {
    final docRef = _expensesCollection.doc(expense.id.isNotEmpty ? expense.id : null);
    final toSave = Expense(
      id: docRef.id,
      title: expense.title,
      amount: expense.amount,
      currency: expense.currency,
      paidBy: expense.paidBy,
      splitType: expense.splitType,
      mePercentage: expense.mePercentage,
      friendPercentage: expense.friendPercentage,
      date: expense.date,
      createdAt: expense.createdAt,
    );
    await docRef.set(toSave.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _expensesCollection.doc(id).delete();
  }
}
