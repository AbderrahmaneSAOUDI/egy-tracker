/// Model managing user selections for data deletion.
class DeleteDataSelection {
  bool deleteExpenses = true;
  bool deleteExchanges = true;
  bool deleteBorrows = true;
  bool deleteInitialBalances = true;
  bool deleteFriends = true;

  bool get allSelected =>
      deleteExpenses &&
      deleteExchanges &&
      deleteBorrows &&
      deleteInitialBalances &&
      deleteFriends;

  bool get hasSelection =>
      deleteExpenses ||
      deleteExchanges ||
      deleteBorrows ||
      deleteInitialBalances ||
      deleteFriends;

  void toggleAll() {
    final newVal = !allSelected;
    deleteExpenses = newVal;
    deleteExchanges = newVal;
    deleteBorrows = newVal;
    deleteInitialBalances = newVal;
    deleteFriends = newVal;
  }
}
