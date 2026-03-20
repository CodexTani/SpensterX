import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transactionService.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();

    amountController =
        TextEditingController(text: widget.transaction.amount.toString());

    noteController =
        TextEditingController(text: widget.transaction.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Edit Transaction"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onPressed: () {

                  final amount = double.tryParse(amountController.text);

                  if (amount == null || amount <= 0) return;

                  final updated = Transaction(
                    id: widget.transaction.id,
                    amount: amount,
                    description: noteController.text,
                    category: widget.transaction.category,
                    paymentMethod: widget.transaction.paymentMethod,
                    date: widget.transaction.date,
                    isIncome: widget.transaction.isIncome,
                  );

                  TransactionService.updateTransaction(updated);

                  if (mounted) {
                    Navigator.pop(context, true); // 🔥 FIX
                  }
                },

                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}