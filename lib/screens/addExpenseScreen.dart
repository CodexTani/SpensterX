import 'package:flutter/material.dart';
import '../utils/categories.dart';
import '../models/transaction.dart';
import '../services/transactionService.dart';
import '../services/storageService.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = categories.first;

  List<String> paymentMethods = [];
  String? selectedPaymentMethod;

  DateTime selectedDate = DateTime.now();
  bool isIncome = false;

  @override
  void initState() {
    super.initState();

    paymentMethods = StorageService.getPaymentMethods();

    if (paymentMethods.isNotEmpty) {
      selectedPaymentMethod = paymentMethods.first;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isIncome ? "Add Income" : "Add Expense"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TOGGLE
              Row(
                children: [

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => isIncome = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: !isIncome
                              ? Colors.blueAccent
                              : const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Expense",
                            style: TextStyle(
                              color: !isIncome
                                  ? Colors.white
                                  : Colors.white60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => isIncome = true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isIncome
                              ? Colors.green
                              : const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Income",
                            style: TextStyle(
                              color: isIncome
                                  ? Colors.white
                                  : Colors.white60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 20),

              // AMOUNT
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

              const SizedBox(height: 16),

              // PAYMENT METHOD
              DropdownButtonFormField<String>(
                initialValue: paymentMethods.contains(selectedPaymentMethod)
                    ? selectedPaymentMethod
                    : null,
                dropdownColor: const Color(0xFF1A1A2E),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Payment Method",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1A1A2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // CATEGORY
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                dropdownColor: const Color(0xFF1A1A2E),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1A1A2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // NOTE
              TextField(
                controller: noteController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Note",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1A1A2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // DATE
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: const Text("Change"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    final amountText = amountController.text.trim();

                    if (amountText.isEmpty) return;

                    final amount = double.tryParse(amountText);
                    if (amount == null || amount <= 0) return;

                    if (selectedPaymentMethod == null) return;

                    TransactionService.addTransaction(
                      Transaction(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        amount: amount,
                        description: noteController.text,
                        category: selectedCategory,
                        paymentMethod: selectedPaymentMethod!,
                        date: selectedDate,
                        isIncome: isIncome,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: Text(isIncome ? "Save Income" : "Save Expense"),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}