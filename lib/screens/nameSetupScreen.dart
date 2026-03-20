import 'package:flutter/material.dart';
import 'mainScreen.dart';
import '../services/storageService.dart';

class NameSetupScreen extends StatefulWidget {
  const NameSetupScreen({super.key});

  @override
  State<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {

  final controller = TextEditingController();

  void saveName() {
    final name = controller.text.trim();

    if (name.isEmpty) return;

    StorageService.box.put("userName", name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Spacer(),

            const Text(
              "Welcome to SpendsterX 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "What should we call you?",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your name",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveName,
              child: const Text("Continue"),
            ),

            const Spacer(),

          ],
        ),
      ),
    );
  }
}