import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../services/api_service.dart';
import '../../widgets/common/app_section_card.dart';
import '../../widgets/common/expense_form.dart';

class MobileAddExpenseScreen extends StatefulWidget {
  const MobileAddExpenseScreen({super.key});

  @override
  State<MobileAddExpenseScreen> createState() => _MobileAddExpenseScreenState();
}

class _MobileAddExpenseScreenState extends State<MobileAddExpenseScreen> {
  final ApiService _apiService = ApiService();

  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<CategoryModel> categories = [];

    try {
      categories = await _apiService.getCategories();
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryNames = _categories.map((item) => item.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppSectionCard(
                  title: 'New Expense',
                  child: ExpenseForm(
                    categories: categoryNames,
                    onSubmit: ({
                      required double amount,
                      required String category,
                      required String date,
                      String? description,
                    }) async {
                      await _apiService.addExpense(
                        amount: amount,
                        category: category,
                        date: date,
                        description: description,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}