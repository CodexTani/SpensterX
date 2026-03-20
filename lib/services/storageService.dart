import 'package:hive_flutter/hive_flutter.dart';

class StorageService {

  static late Box box;

  static Future init() async {
    await Hive.initFlutter();
    box = await Hive.openBox("expenseBox");
  }

  // 🔥 NEW: Get monthly limit
  static double getMonthlyLimit(DateTime date) {
    final key = "monthlyLimit_${date.year}_${date.month}";
    final value = box.get(key);

    if (value == null) {
      return 10000; // default fallback
    }

    return value;
  }

  // 🔥 NEW: Set monthly limit
  static void setMonthlyLimit(DateTime date, double amount) {
    final key = "monthlyLimit_${date.year}_${date.month}";
    box.put(key, amount);
  }

  // 🔥 PAYMENT METHODS STORAGE

static List<String> getPaymentMethods() {
  final methods = box.get("paymentMethods");

  if (methods != null) {
    return List<String>.from(methods);
  }

  // Default methods (first time)
  final defaultMethods = ["Bank", "UPI1", "UPI2", "Cash"];
  box.put("paymentMethods", defaultMethods);

  return defaultMethods;
}

static void savePaymentMethods(List<String> methods) {
  box.put("paymentMethods", methods);
}
}