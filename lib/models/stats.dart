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

class StatsByYearModel {
  final int year;
  final List<StatsByCategoryModel> stats;

  StatsByYearModel({
    required this.year,
    required this.stats,
  });

  factory StatsByYearModel.fromJson(Map<String, dynamic> json) {
    return StatsByYearModel(
      year: json['year'],
      stats: (json['stats'] as List)
          .map((item) => StatsByCategoryModel.fromJson(item))
          .toList(),
    );
  }
}

class StatsByRangeModel {
  final DateTime startDate;
  final DateTime endDate;
  final List<StatsByCategoryModel> stats;

  StatsByRangeModel({
    required this.startDate,
    required this.endDate,
    required this.stats,
  });

  factory StatsByRangeModel.fromJson(Map<String, dynamic> json) {
    return StatsByRangeModel(
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      stats: (json['stats'] as List)
          .map((item) => StatsByCategoryModel.fromJson(item))
          .toList(),
    );
  }
}