import '../models/transaction.dart';
import 'storageService.dart';

class BalanceService {
  static Map<String, double> initialBalances = {};
  static Map<String, double> currentBalances = {};

  // LOAD
  static void loadBalances() {
    final data = StorageService.box.get("balances");

    if (data != null) {
      initialBalances =
          Map<String, double>.from(Map<String, dynamic>.from(data));
    }

    currentBalances = Map.from(initialBalances);
  }

  // SAVE
  static void saveBalances() {
    StorageService.box.put("balances", initialBalances);
  }

  // SET INITIAL
  static void setInitialBalances(Map<String, double> balances) {
    initialBalances = balances;
    currentBalances = Map.from(balances);
    saveBalances();
  }

  // 🔥 FINAL SAFE RECALCULATION
  static void recalculateBalances(List<Transaction> transactions) {
    // reset safely
    currentBalances = {};

    // copy initial balances
    initialBalances.forEach((key, value) {
      currentBalances[key] = value;
    });

    for (Transaction t in transactions) {
      final method = t.paymentMethod;

      // ensure key exists
      currentBalances.putIfAbsent(method, () => 0);

      if (t.isIncome) {
        currentBalances[method] =
            currentBalances[method]! + t.amount;
      } else {
        currentBalances[method] =
            currentBalances[method]! - t.amount;
      }
    }
  }

  // GET CURRENT
  static double getBalance(String method) {
    return currentBalances[method] ?? 0;
  }

  // GET INITIAL
  static double getInitialBalance(String method) {
    return initialBalances[method] ?? 0;
  }
}