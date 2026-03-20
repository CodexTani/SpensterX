import 'package:flutter/material.dart';
import 'screens/mainScreen.dart';
// import 'screens/setupBalancesScreen.dart';
import 'services/storageService.dart';
import 'services/transactionService.dart';
import 'services/balanceService.dart';
import 'screens/nameSetupScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  BalanceService.loadBalances();
  TransactionService.loadTransactions();
  //BalanceService.recalculateBalances(TransactionService.transactions);

  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0F0F1A),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.white70,
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
  ),

  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
),
      home: StorageService.box.get("userName") != null
    ? const MainScreen()
    : const NameSetupScreen(),
    );
  }
}