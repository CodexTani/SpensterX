import 'package:flutter/material.dart';
import '../services/balanceService.dart';
import '../services/storageService.dart';

class SetupBalancesScreen extends StatefulWidget {
  const SetupBalancesScreen({super.key});

  @override
  State<SetupBalancesScreen> createState() => _SetupBalancesScreenState();
}

class _SetupBalancesScreenState extends State<SetupBalancesScreen> {

  List<String> methods = [];
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    loadMethods();
  }

  void loadMethods() {
    final fetched = StorageService.getPaymentMethods();

    // 🔥 SAFETY: ensure list is never null
    methods = fetched.isNotEmpty ? fetched : [];

    for (var method in methods) {
      controllers[method] = TextEditingController(
        text: BalanceService.getBalance(method).toStringAsFixed(0),
      );
    }
  }

  void saveBalances() {
    Map<String, double> data = {};

    for (var method in methods) {
      data[method] =
          double.tryParse(controllers[method]?.text ?? "0") ?? 0;
    }

    BalanceService.setInitialBalances(data);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    // 🔥 EXTRA SAFETY (prevents map crash)
    if (methods.isEmpty) {
      loadMethods();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Manage Balances"),
      ),

      body: methods.isEmpty
          ? const Center(
              child: Text(
                "No payment methods found",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Expanded(
                    child: ListView(
                      children: methods.map((method) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextField(
                            controller: controllers[method],
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "$method Balance",
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: saveBalances,
                    child: const Text("Update"),
                  )

                ],
              ),
            ),
    );
  }
}