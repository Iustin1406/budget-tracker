import 'package:flutter/material.dart';

import '../../models/stats.dart';
import '../../services/api_service.dart';
import '../../widgets/common/app_section_card.dart';
import '../../widgets/common/stats_panel.dart';

class MobileStatsScreen extends StatefulWidget {
  const MobileStatsScreen({super.key});

  @override
  State<MobileStatsScreen> createState() => _MobileStatsScreenState();
}

class _MobileStatsScreenState extends State<MobileStatsScreen> {
  final ApiService _apiService = ApiService();

  List<StatsByCategoryModel> _categoryStats = [];
  List<StatsByDayModel> _dayStats = [];
  List<StatsByMonthModel> _monthStats = [];

  bool _isLoading = true;
  int? _selectedMonth;
  int _selectedYear = 2026;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
    });

    List<StatsByCategoryModel> byCategory = [];
    List<StatsByDayModel> byDay = [];
    List<StatsByMonthModel> byMonth = [];

    try {
      byCategory = await _apiService.getStatsByCategory(
        month: _selectedMonth,
        year: _selectedYear,
      );
    } catch (_) {}

    try {
      byDay = await _apiService.getStatsByDay(
        month: _selectedMonth,
        year: _selectedYear,
      );
    } catch (_) {}

    try {
      byMonth = await _apiService.getStatsByMonth(
        year: _selectedYear,
      );
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _categoryStats = byCategory;
      _dayStats = byDay;
      _monthStats = byMonth;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AppSectionCard(
                  title: 'Stats Filters',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<int>(
                          initialValue: _selectedMonth,
                          decoration: const InputDecoration(labelText: 'Month'),
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('All'),
                            ),
                            ...months.map(
                              (month) => DropdownMenuItem<int>(
                                value: month,
                                child: Text(month.toString()),
                              ),
                            ),
                          ],
                          onChanged: (value) async {
                            setState(() {
                              _selectedMonth = value;
                            });
                            await _loadStats();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<int>(
                          initialValue: _selectedYear,
                          decoration: const InputDecoration(labelText: 'Year'),
                          items: [2024, 2025, 2026, 2027]
                              .map(
                                (year) => DropdownMenuItem<int>(
                                  value: year,
                                  child: Text(year.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            setState(() {
                              _selectedYear = value;
                            });
                            await _loadStats();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppSectionCard(
                  title: 'Statistics Overview',
                  child: StatsPanel(
                    categoryStats: _categoryStats,
                    dayStats: _dayStats,
                    monthStats: _monthStats,
                  ),
                ),
              ],
            ),
    );
  }
}