import 'package:flutter/material.dart';
import '../services/transactionService.dart';
import '../models/transaction.dart';
import '../services/pdfService.dart';

class DateSummaryScreen extends StatefulWidget {
  const DateSummaryScreen({super.key});

  @override
  State<DateSummaryScreen> createState() => _DateSummaryScreenState();
}

class _DateSummaryScreenState extends State<DateSummaryScreen> {

  DateTime? startDate;
  DateTime? endDate;

  double total = 0;
  Map<String, double> categoryTotals = {};

  void calculateSummary() {

  if (startDate == null || endDate == null) return;

  double sum = 0;
  Map<String, double> map = {};

  for (Transaction t in TransactionService.transactions) {

    if (!t.isIncome &&
        t.date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
        t.date.isBefore(endDate!.add(const Duration(days: 1)))) {

      sum += t.amount;

      map[t.category] = (map[t.category] ?? 0) + t.amount;

    }

  }

  setState(() {
    total = sum;
    categoryTotals = map;
  });

}

  Future pickStart() async {

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        startDate = date;
      });
    }

  }

  Future pickEnd() async {

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        endDate = date;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Date Summary"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
        child: Column(

          children: [

            ElevatedButton(
              onPressed: pickStart,
              child: const Text("Select Start Date"),
            ),

            ElevatedButton(
              onPressed: pickEnd,
              child: const Text("Select End Date"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateSummary,
              child: const Text("Generate Summary"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
  onPressed: () {

    if (startDate != null && endDate != null) {

      PdfService.generateSummaryPDF(
        total,
        categoryTotals,
        startDate!,
        endDate!,
      );

    }

  },
  child: const Text("Export PDF"),
),

            const SizedBox(height: 30),

            Text(
              "Total Spending: ₹${total.toInt()}",
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 20),

...categoryTotals.entries.map((entry) {

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(16),
boxShadow: [
  BoxShadow(
    color: Colors.black.withOpacity(0.25),
    blurRadius: 10,
    offset: const Offset(0, 5),
  ),
],),



    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(entry.key),

        Text(
          "₹${entry.value.toInt()}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        )

      ],
    ),
  );

}),

          ],

        ),
        )
      ),

    );

  }

}