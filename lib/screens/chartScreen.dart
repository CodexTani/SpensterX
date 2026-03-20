import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transactionService.dart';
import '../models/transaction.dart';

class ChartScreen extends StatelessWidget {
  final List<Transaction>? filteredTransactions;
  final DateTime? startDate;
  final DateTime? endDate;

  const ChartScreen({
    super.key,
    this.filteredTransactions,
    this.startDate,
    this.endDate,
  });

  List<Transaction> get transactions =>
      filteredTransactions ?? TransactionService.transactions;

  Map<String, double> getCategoryData() {
    Map<String, double> data = {};

    for (Transaction t in transactions) {
      if (!t.isIncome) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = getCategoryData();

    final total = categoryData.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        title: Text(
          startDate != null && endDate != null
              ? "${startDate!.day}/${startDate!.month} - ${endDate!.day}/${endDate!.month}"
              : "Insights",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 10),

            Text(
              "Total Spending",
              style: TextStyle(color: Colors.white60),
            ),

            const SizedBox(height: 5),

            Text(
              "₹${total.toInt()}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 250,
              child: categoryData.isEmpty
                  ? const Center(
                      child: Text(
                        "No data",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        sections: categoryData.entries.map((entry) {
                          return PieChartSectionData(
                            value: entry.value,
                            title: entry.key,
                            radius: 60,
                            color: Colors.blueAccent,
                          );
                        }).toList(),
                      ),
                    ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: ListView(
                children: categoryData.entries.map((entry) {
                  return ListTile(
                    title: Text(
                      entry.key,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      "₹${entry.value.toInt()}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }).toList(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}