class StatsByCategoryModel {
  final String category;
  final double total;

  StatsByCategoryModel({
    required this.category,
    required this.total,
  });

  factory StatsByCategoryModel.fromJson(Map<String, dynamic> json) {
    return StatsByCategoryModel(
      category: json['category'],
      total: (json['total'] as num).toDouble(),
    );
  }
}

class StatsByDayModel {
  final DateTime date;
  final double total;

  StatsByDayModel({
    required this.date,
    required this.total,
  });

  factory StatsByDayModel.fromJson(Map<String, dynamic> json) {
    return StatsByDayModel(
      date: DateTime.parse(json['date']),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class StatsByMonthModel {
  final int year;
  final int month;
  final double total;

  StatsByMonthModel({
    required this.year,
    required this.month,
    required this.total,
  });

  factory StatsByMonthModel.fromJson(Map<String, dynamic> json) {
    return StatsByMonthModel(
      year: json['year'],
      month: json['month'],
      total: (json['total'] as num).toDouble(),
    );
  }
}