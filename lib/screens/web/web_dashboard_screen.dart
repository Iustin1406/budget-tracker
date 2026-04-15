import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/expense.dart';
import '../../models/stats.dart';
import '../../services/api_service.dart';
import '../../widgets/common/app_section_card.dart';
import '../../widgets/common/expense_form.dart';
import '../../widgets/common/expense_list.dart';
import '../../widgets/common/filter_bar.dart';
import '../../widgets/common/stats_panel.dart';
import '../../widgets/common/summary_card.dart';

class WebDashboardScreen extends StatefulWidget {
  const WebDashboardScreen({super.key});

  @override
  State<WebDashboardScreen> createState() => _WebDashboardScreenState();
}

class _WebDashboardScreenState extends State<WebDashboardScreen> {
  final ApiService _apiService = ApiService();

  List<CategoryModel> _categories = [];
  List<ExpenseModel> _expenses = [];
  List<StatsByCategoryModel> _categoryStats = [];
  List<StatsByDayModel> _dayStats = [];
  List<StatsByMonthModel> _monthStats = [];

  String? _selectedCategory;
  int? _selectedMonth;
  int? _selectedYear;

  bool _isLoading = true;

  double get _totalAmount {
    return _expenses.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
    });

    List<CategoryModel> categories = _categories;
    List<ExpenseModel> expenses = [];
    List<StatsByCategoryModel> categoryStats = [];
    List<StatsByDayModel> dayStats = [];
    List<StatsByMonthModel> monthStats = [];

    try {
      categories = await _apiService.getCategories();
    } catch (_) {}

    try {
      expenses = await _apiService.getExpenses(
        category: _selectedCategory,
        month: _selectedMonth,
        year: _selectedYear,
      );
    } catch (_) {}

    try {
      categoryStats = await _apiService.getStatsByCategory(
        month: _selectedMonth,
        year: _selectedYear,
      );
    } catch (_) {}

    try {
      dayStats = await _apiService.getStatsByDay(
        month: _selectedMonth,
        year: _selectedYear,
      );
    } catch (_) {}

    try {
      monthStats = await _apiService.getStatsByMonth(
        year: _selectedYear,
      );
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _categories = categories;
      _expenses = expenses;
      _categoryStats = categoryStats;
      _dayStats = dayStats;
      _monthStats = monthStats;
      _isLoading = false;
    });
  }

  Future<void> _deleteExpense(int expenseId) async {
    try {
      await _apiService.deleteExpense(expenseId);
      await _loadDashboard();

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Budget Tracker',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Manage expenses, apply filters, and track statistics in one place.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF5B6773),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: SummaryCard(
                                title: 'Selected total',
                                value: '${_totalAmount.toStringAsFixed(2)} RON',
                                icon: Icons.savings_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SummaryCard(
                                title: 'Expenses count',
                                value: _expenses.length.toString(),
                                icon: Icons.receipt_long_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: AppSectionCard(
                                title: 'Expenses',
                                child: Column(
                                  children: [
                                    FilterBar(
                                      selectedCategory: _selectedCategory,
                                      selectedMonth: _selectedMonth,
                                      selectedYear: _selectedYear,
                                      categories: categoryNames,
                                      onCategoryChanged: (value) async {
                                        setState(() {
                                          _selectedCategory = value;
                                        });
                                        await _loadDashboard();
                                      },
                                      onMonthChanged: (value) async {
                                        setState(() {
                                          _selectedMonth = value;
                                        });
                                        await _loadDashboard();
                                      },
                                      onYearChanged: (value) async {
                                        setState(() {
                                          _selectedYear = value;
                                        });
                                        await _loadDashboard();
                                      },
                                      onClear: () async {
                                        setState(() {
                                          _selectedCategory = null;
                                          _selectedMonth = null;
                                          _selectedYear = null;
                                        });
                                        await _loadDashboard();
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      height: 560,
                                      child: ExpenseList(
                                        expenses: _expenses,
                                        onDelete: _deleteExpense,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 380,
                              child: Column(
                                children: [
                                  AppSectionCard(
                                    title: 'Add Expense',
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
                                        await _loadDashboard();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  AppSectionCard(
                                    title: 'Statistics',
                                    child: StatsPanel(
                                      categoryStats: _categoryStats,
                                      dayStats: _dayStats,
                                      monthStats: _monthStats,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}