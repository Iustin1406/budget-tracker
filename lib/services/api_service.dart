import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/expense.dart';
import '../models/stats.dart';

class ApiService {
  String _baseUrl() {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    return 'http://127.0.0.1:8000';
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse('${_baseUrl()}/categories'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => CategoryModel.fromJson(item)).toList();
  }

  Future<List<ExpenseModel>> getExpenses({
    String? category,
    int? month,
    int? year,
    String? date,
  }) async {
    final queryParameters = <String, String>{};

    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = category;
    }

    if (month != null) {
      queryParameters['month'] = month.toString();
    }

    if (year != null) {
      queryParameters['year'] = year.toString();
    }

    if (date != null && date.isNotEmpty) {
      queryParameters['date'] = date;
    }

    final uri = Uri.parse('${_baseUrl()}/expenses')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load expenses');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => ExpenseModel.fromJson(item)).toList();
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    required String date,
    String? description,
  }) async {
    final response = await http.post(
      Uri.parse('${_baseUrl()}/expenses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'category': category,
        'date': date,
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add expense');
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    final response = await http.delete(
      Uri.parse('${_baseUrl()}/expenses/$expenseId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete expense');
    }
  }

  Future<List<StatsByCategoryModel>> getStatsByCategory({
    int? month,
    int? year,
  }) async {
    final queryParameters = <String, String>{};

    if (month != null) {
      queryParameters['month'] = month.toString();
    }

    if (year != null) {
      queryParameters['year'] = year.toString();
    }

    final uri = Uri.parse('${_baseUrl()}/stats/by-category')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load category stats');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => StatsByCategoryModel.fromJson(item)).toList();
  }

  Future<List<StatsByDayModel>> getStatsByDay({
    int? month,
    int? year,
  }) async {
    final queryParameters = <String, String>{};

    if (month != null) {
      queryParameters['month'] = month.toString();
    }

    if (year != null) {
      queryParameters['year'] = year.toString();
    }

    final uri = Uri.parse('${_baseUrl()}/stats/by-day')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load day stats');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => StatsByDayModel.fromJson(item)).toList();
  }

  Future<List<StatsByMonthModel>> getStatsByMonth({
    int? year,
  }) async {
    final queryParameters = <String, String>{};

    if (year != null) {
      queryParameters['year'] = year.toString();
    }

    final uri = Uri.parse('${_baseUrl()}/stats/by-month')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load month stats');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => StatsByMonthModel.fromJson(item)).toList();
  }
}