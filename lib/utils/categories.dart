import 'package:flutter/material.dart';

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryData({
    required this.name,
    required this.icon,
    required this.color,
  });
}

const List<CategoryData> categoryDataList = [

  CategoryData(
    name: "Food",
    icon: Icons.fastfood,
    color: Colors.orange,
  ),

  CategoryData(
    name: "Study",
    icon: Icons.school,
    color: Colors.blue,
  ),

  CategoryData(
    name: "Robotics",
    icon: Icons.memory,
    color: Colors.purple,
  ),

  CategoryData(
    name: "Essentials",
    icon: Icons.shopping_bag,
    color: Colors.green,
  ),

  CategoryData(
    name: "Others",
    icon: Icons.category,
    color: Colors.grey,
  ),

];

// keep this for old dropdowns
const List<String> categories = [
  "Food",
  "Study",
  "Robotics",
  "Essentials",
  "Others",
];