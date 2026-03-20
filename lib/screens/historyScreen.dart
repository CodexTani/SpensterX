import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transactionService.dart';
import '../models/transaction.dart';
import 'editTransactionScreen.dart';
import 'package:expense_app/utils/categories.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

final colors = [
  Colors.blueAccent,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.red,
  Colors.teal,
];

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? startDate;
  DateTime? endDate;

  List<Transaction> getFilteredTransactions() {
    final all = TransactionService.transactions;

    if (startDate == null || endDate == null) {
      final now = DateTime.now();
      return all.where((t) =>
          t.date.year == now.year && t.date.month == now.month).toList();
    }

    return all.where((t) {
      return t.date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> getCategoryData(List<Transaction> list) {
    Map<String, double> data = {};
    for (var t in list) {
      if (!t.isIncome) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = getFilteredTransactions();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Transaction History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),

            // FULL SCREEN INSIGHTS
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InsightsScreen(
                    transactions: getFilteredTransactions(),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

         
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() => startDate = picked);
                      }
                    },
                    child: Text(
                      startDate == null
                          ? "Start Date"
                          : "${startDate!.day}/${startDate!.month}",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                    child: Text(
                      endDate == null
                          ? "End Date"
                          : "${endDate!.day}/${endDate!.month}",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () {
                    setState(() {
                      startDate = null;
                      endDate = null;
                    });
                  },
                  icon: const Icon(Icons.clear, color: Colors.white),
                ),
              ],
            ),
          ),

          // LIST
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text("No transactions found",
                        style: TextStyle(color: Colors.white70)))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[transactions.length - 1 - index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditTransactionScreen(transaction: t),
                            ),
                          );
                        },
                        child: modernTile(t),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget modernTile(Transaction t) {
  final isIncome = t.isIncome;

  final catData = categoryDataList.firstWhere(
    (c) => c.name == t.category,
    orElse: () => const CategoryData(
      name: "Others",
      icon: Icons.category,
      color: Colors.grey,
    ),
  );

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A2E),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: Row(
      children: [

        //ICON BOX
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: catData.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(catData.icon, color: catData.color),
        ),

        const SizedBox(width: 12),

        //TEXT SECTION
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                t.description.isNotEmpty ? t.description : t.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${t.category} • ${t.paymentMethod}",
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${t.date.day}/${t.date.month}/${t.date.year}",
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        //AMOUNT
        Text(
          "${isIncome ? '+' : '-'} ₹${t.amount.toInt()}",
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
}


///


class InsightsScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const InsightsScreen({super.key, required this.transactions});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {

  DateTime? startDate;
  DateTime? endDate;

  List<Transaction> getFiltered() {
    if (startDate == null || endDate == null) {
      return widget.transactions;
    }

    return widget.transactions.where((t) {
      return t.date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
             t.date.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> getCategoryData(List<Transaction> list) {
    Map<String, double> data = {};
    for (var t in list) {
      if (!t.isIncome) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {

    final filtered = getFiltered();
    final data = getCategoryData(filtered);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        title: const Text("Insights"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // START / END DATE 
            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() => startDate = picked);
                      }
                    },
                    child: Text(
                      startDate == null
                          ? "Start Date"
                          : "${startDate!.day}/${startDate!.month}",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                    child: Text(
                      endDate == null
                          ? "End Date"
                          : "${endDate!.day}/${endDate!.month}",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () {
                    setState(() {
                      startDate = null;
                      endDate = null;
                    });
                  },
                  icon: const Icon(Icons.clear, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),
          
            // CHART
            SizedBox(
              height: 250,
              child: data.isEmpty
                  ? const Center(
                      child: Text("No data",
                          style: TextStyle(color: Colors.white70)))
                  : 

PieChart(
  PieChartData(
    sections: data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;

      return PieChartSectionData(
        value: e.value,
        title: e.key,
        radius: 60,
        color: colors[index % colors.length], // 🔥 COLORS ADDED
      );
    }).toList(),
  ),
)
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: ListView(
                children: data.entries.map((e) {
                  return ListTile(
                    title: Text(e.key,
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text("₹${e.value.toInt()}",
                        style:
                            const TextStyle(color: Colors.white70)),
                  );
                }).toList(),
              ),
            ),

            // PDF BUTTON
            ElevatedButton(
              onPressed: () {},
              child: const Text("Download PDF"),
            ),
          ],
        ),
      ),
    );
  }
}