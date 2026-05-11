import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/expense.dart';
import '../../services/api_service.dart';
import '../../widgets/common/app_section_card.dart';
import '../../widgets/common/expense_list.dart';
import '../../widgets/common/filter_bar.dart';
import '../../widgets/common/summary_card.dart';

class MobileExpensesScreen extends StatefulWidget {
  const MobileExpensesScreen({super.key});

  @override
  State<MobileExpensesScreen> createState() => _MobileExpensesScreenState();
}

class _MobileExpensesScreenState extends State<MobileExpensesScreen> {
  final ApiService _apiService = ApiService();

  List<CategoryModel> _categories = [];
  List<ExpenseModel> _expenses = [];

  String? _selectedCategory;
  int? _selectedMonth;
  int? _selectedYear;
  DateTime? _selectedDate;
  String _selectedSortBy = 'date';
  String _selectedSortOrder = 'desc';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  double get _totalAmount {
    return _expenses.fold(0, (sum, item) => sum + item.amount);
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    List<CategoryModel> categories = _categories;
    List<ExpenseModel> expenses = [];

    try {
      categories = await _apiService.getCategories();
    } catch (_) {}

    try {
      expenses = await _apiService.getExpenses(
        category: _selectedCategory,
        month: _selectedDate != null ? null : _selectedMonth,
        year: _selectedDate != null ? null : _selectedYear,
        date: _selectedDate != null
            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
            : null,
        sortBy: _selectedSortBy,
        sortOrder: _selectedSortOrder,
      );
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _categories = categories;
      _expenses = expenses;
      _isLoading = false;
    });
  }

  Future<void> _deleteExpense(int expenseId) async {
    try {
      await _apiService.deleteExpense(expenseId);
      await _loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense deleted')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete expense')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryNames = _categories.map((item) => item.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SummaryCard(
                    title: 'Selected total',
                    value: '${_totalAmount.toStringAsFixed(2)} RON',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  const SizedBox(height: 16),
                  AppSectionCard(
                    title: 'Filters',
                    child: FilterBar(
                      selectedCategory: _selectedCategory,
                      selectedMonth: _selectedMonth,
                      selectedYear: _selectedYear,
                      categories: categoryNames,
                      selectedDate: _selectedDate,
                      selectedSortBy: _selectedSortBy,
                      selectedSortOrder: _selectedSortOrder,
                      onCategoryChanged: (value) async {
                        setState(() {
                          _selectedCategory = value;
                        });
                        await _loadData();
                      },
                      onMonthChanged: (value) async {
                        setState(() {
                          _selectedMonth = value;
                        });
                        await _loadData();
                      },
                      onYearChanged: (value) async {
                        setState(() {
                          _selectedYear = value;
                        });
                        await _loadData();
                      },
                      onDateChanged: (value) async {
                        setState(() {
                          _selectedDate = value;
                        });
                        await _loadData();
                      },
                      onSortByChanged: (value) async {
                        setState(() {
                          _selectedSortBy = value ?? 'date';
                        });
                        await _loadData();
                      },
                      onSortOrderChanged: (value) async {
                        setState(() {
                          _selectedSortOrder = value ?? 'desc';
                        });
                        await _loadData();
                      },
                      onClear: () async {
                        setState(() {
                          _selectedCategory = null;
                          _selectedMonth = null;
                          _selectedYear = null;
                          _selectedDate = null;
                          _selectedSortBy = 'date';
                          _selectedSortOrder = 'desc';
                        });
                        await _loadData();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppSectionCard(
                    title: 'Expenses',
                    child: SizedBox(
                      height: 460,
                      child: ExpenseList(
                        expenses: _expenses,
                        onDelete: _deleteExpense,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
