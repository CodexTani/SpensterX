import 'package:flutter/material.dart';
import '../services/storageService.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {

  late List<String> methods;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    methods = StorageService.getPaymentMethods();
  }

  void addMethod() {
    final name = controller.text.trim();

    if (name.isEmpty) return;

    methods.add(name);
    StorageService.savePaymentMethods(methods);

    controller.clear();
    setState(() {});
  }

  void deleteMethod(int index) {
    methods.removeAt(index);
    StorageService.savePaymentMethods(methods);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),

      appBar: AppBar(
        title: const Text("Payment Methods"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // ADD FIELD
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Add new method",
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addMethod,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // LIST
            Expanded(
              child: ListView.builder(
                itemCount: methods.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(methods[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteMethod(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}