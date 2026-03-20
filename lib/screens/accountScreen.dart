import 'package:flutter/material.dart';
import 'setupBalancesScreen.dart';
import '../services/storageService.dart';
import 'paymentMethodsScreen.dart';
import '../services/backupService.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final name = StorageService.box.get("userName") ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              //GREETING
              Text(
                "Hello, $name 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              //SETTINGS CARDS
              settingCard(
                title: "Manage Balances",
                icon: Icons.account_balance_wallet,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SetupBalancesScreen(),
                    ),
                  );

                  if (result == true) {
                    setState(() {});
                  }
                },
              ),

              const SizedBox(height: 15),

              settingCard(
                title: "Payment Methods",
                icon: Icons.payments,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentMethodsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              settingCard(
                title: "Export Backup",
                icon: Icons.upload,
                onTap: () async {
                  await BackupService.exportData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Backup saved successfully")),
                  );
                },
              ),

              const SizedBox(height: 15),

              settingCard(
                title: "Import Backup",
                icon: Icons.download,
                onTap: () async {
                  await BackupService.importData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Backup restored successfully"),
                    ),
                  );

                  setState(() {}); // refresh UI
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
