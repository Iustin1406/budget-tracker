class ExpenseModel {
  final int id;
  final double amount;
  final String? description;
  final String category;
  final DateTime date;
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    required this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}