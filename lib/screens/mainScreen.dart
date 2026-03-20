import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'historyScreen.dart';
import 'addExpenseScreen.dart';
import 'accountScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;

  Widget getScreen() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const HistoryScreen();
      case 3:
        return const AccountScreen(); 
      default:
        return const HomeScreen();
    }
  }

  void onItemTapped(int index) {
    if (index == 2) {
      // OPEN ADD SCREEN 
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
      );
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: getScreen(),

      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped, 

          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A1A2E),

          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white60,

          iconSize: 28,

          selectedLabelStyle: const TextStyle(height: 0),
          unselectedLabelStyle: const TextStyle(height: 0),

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 32),
              label: "",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}