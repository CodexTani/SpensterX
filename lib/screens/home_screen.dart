import 'package:flutter/material.dart';
import '../services/transactionService.dart';
import '../services/balanceService.dart';
import '../models/transaction.dart';
import '../services/storageService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double getTodaySpending() {
    final today = DateTime.now();
    double total = 0;

    for (Transaction t in TransactionService.transactions) {
      if (t.date.year == today.year &&
          t.date.month == today.month &&
          t.date.day == today.day &&
          !t.isIncome) {
        total += t.amount;
      }
    }
    return total;
  }

  double getMonthlySpending() {
    final now = DateTime.now();
    double total = 0;

    for (Transaction t in TransactionService.transactions) {
      if (t.date.year == now.year && t.date.month == now.month && !t.isIncome) {
        total += t.amount;
      }
    }
    return total;
  }

  double getMonthlyGoal() {
    return StorageService.getMonthlyLimit(DateTime.now());
  }

  double getMonthlyProgress() {
    final spending = getMonthlySpending();
    final goal = getMonthlyGoal();
    return goal == 0 ? 0 : spending / goal;
  }

  int getDaysLeft() {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    return lastDay - now.day + 1;
  }

  void showSetMonthlyLimitDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Monthly Limit"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter amount"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);

                if (value != null) {
                  StorageService.setMonthlyLimit(DateTime.now(), value);
                  setState(() {});
                }

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final methods = StorageService.getPaymentMethods();

    final monthlySpent = getMonthlySpending();
    final todaySpent = getTodaySpending();
    final monthlyGoal = getMonthlyGoal();
    final progress = getMonthlyProgress();

    final remaining = monthlyGoal - monthlySpent;
    final daysLeft = getDaysLeft();
    final safePerDay = daysLeft > 0 ? remaining / daysLeft : 0;

    String statusText;
    Color statusColor;

    if (progress < 0.7) {
      statusText = "On Track";
      statusColor = Colors.green;
    } else if (progress < 1) {
      statusText = "Careful";
      statusColor = Colors.orange;
    } else {
      statusText = "Overspent";
      statusColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // HEADER
                Row(
                  children: [
                    Image.asset("assets/appLogo.png", height: 40),
                    const SizedBox(width: 10),
                    const Text(
                      "SpendsterX",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: showSetMonthlyLimitDialog,
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // MAIN CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today",
                            style: TextStyle(color: Colors.white60),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "₹${todaySpent.toInt()}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Column(
                        children: [
                          Text(
                            "₹${remaining.toInt()} left",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "₹${safePerDay.toInt()} / day",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 12,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 140,
                            width: 140,
                            child: CircularProgressIndicator(
                              value: progress > 1 ? 1 : progress,
                              strokeWidth: 10,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation(
                                progress > 1 ? Colors.red : Colors.blueAccent,
                              ),
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "₹${monthlySpent.toInt()}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "of ₹${monthlyGoal.toInt()}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Balances",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // 🔥 DYNAMIC GRID
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: methods.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) {
                    final method = methods[index];

                    return modernCard(
                      method,
                      BalanceService.getBalance(method),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget modernCard(String title, double amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 6),
          Text(
            "₹${amount.toInt()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
