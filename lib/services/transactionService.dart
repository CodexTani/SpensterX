import '../models/transaction.dart';
import 'storageService.dart';
import 'balanceService.dart';

class TransactionService {
  static List<Transaction> transactions = [];

  // LOAD
  static void loadTransactions() {
    final data = StorageService.box.get("transactions");

    if (data != null && data is List) {
      try {
        transactions = data
            .map((t) => Transaction.fromMap(Map<String, dynamic>.from(t)))
            .toList();
      } catch (e) {
        transactions = [];
      }
    } else {
      transactions = [];
    }

    BalanceService.recalculateBalances(transactions);
  }

  // SAVE (SAFE)
  static void saveTransactions() {
    try {
      final data = transactions.map((t) => t.toMap()).toList();
      StorageService.box.put("transactions", data);
    } catch (e) {
      // prevent crash
    }
  }

  // ADD
  static void addTransaction(Transaction t) {
    transactions.add(t);
    BalanceService.recalculateBalances(transactions);
    saveTransactions();
  }

  // DELETE
  static void deleteTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);
    BalanceService.recalculateBalances(transactions);
    saveTransactions();
  }

  // UPDATE
  static void updateTransaction(Transaction updated) {
    final index = transactions.indexWhere((t) => t.id == updated.id);

    if (index != -1) {
      transactions[index] = updated;
      BalanceService.recalculateBalances(transactions);
      saveTransactions();
    }
  }
}