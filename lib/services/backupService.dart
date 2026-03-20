import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../services/transactionService.dart';
import '../services/balanceService.dart';
import '../services/storageService.dart';
import '../models/transaction.dart';

class BackupService {

  // 🔥 EXPORT
  static Future<String> exportData() async {

    final data = {
      "transactions": TransactionService.transactions.map((t) => t.toMap()).toList(),
      "balances": BalanceService.initialBalances,
      "paymentMethods": StorageService.getPaymentMethods(),
    };

    final jsonString = jsonEncode(data);

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/spendster_backup.json");

    await file.writeAsString(jsonString);

    return file.path;
  }

  // 🔥 IMPORT
  static Future<void> importData() async {

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/spendster_backup.json");

    if (!await file.exists()) return;

    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString);

    // 🔥 Restore transactions
    final transactions = data["transactions"] as List;
    TransactionService.transactions = transactions
        .map((t) => Transaction.fromMap(t))
        .toList();

    TransactionService.saveTransactions();

    // 🔥 Restore balances
    final balances = Map<String, double>.from(data["balances"]);
    BalanceService.setInitialBalances(balances);

    // 🔥 Restore payment methods
    final methods = List<String>.from(data["paymentMethods"]);
    StorageService.savePaymentMethods(methods);
  }
}