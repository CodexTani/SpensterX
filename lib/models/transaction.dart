class Transaction {
  final String id;
  final double amount;
  final String description;
  final String category;
  final String paymentMethod;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.paymentMethod,
    required this.date,
    required this.isIncome,
  });

  Map<String, dynamic> toMap() {
  return {
    "id": id,
    "amount": amount,
    "description": description,
    "category": category,
    "paymentMethod": paymentMethod,
    "date": date.toIso8601String(),
    "isIncome": isIncome,
  };
}

factory Transaction.fromMap(Map map) {
  return Transaction(
    id: map['id'],
    amount: map['amount'],
    category: map['category'],
    paymentMethod: map['paymentMethod'],
    date: DateTime.parse(map['date']),
    description: map['description'],
    isIncome: map['isIncome'],
  );
}
}