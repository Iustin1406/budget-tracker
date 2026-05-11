import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  StatsByYearModel? _yearStats;
  StatsByRangeModel? _rangeStats;

  bool _isLoading = true;
  int? _selectedMonth;
  int _selectedYear = 2026;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

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
    StatsByYearModel? byYear;
    StatsByRangeModel? byRange;

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

    try {
      byYear = await _apiService.getStatsByYear(
        year: _selectedYear,
      );
    } catch (_) {}

    if (_rangeStart != null && _rangeEnd != null) {
      try {
        final fmt = DateFormat('yyyy-MM-dd');
        byRange = await _apiService.getStatsByRange(
          startDate: fmt.format(_rangeStart!),
          endDate: fmt.format(_rangeEnd!),
        );
      } catch (_) {}
    }

    if (!mounted) return;

    setState(() {
      _categoryStats = byCategory;
      _dayStats = byDay;
      _monthStats = byMonth;
      _yearStats = byYear;
      _rangeStats = byRange;
      _isLoading = false;
    });
  }

  Future<void> _pickRangeDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _rangeStart : _rangeEnd) ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _rangeStart = picked;
      } else {
        _rangeEnd = picked;
      }
    });

    if (_rangeStart != null && _rangeEnd != null) {
      await _loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (index) => index + 1);
    final formatter = DateFormat('dd MMM yyyy');

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
                  title: 'Date Range',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 170,
                        child: InkWell(
                          onTap: () => _pickRangeDate(true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                            ),
                            child: Text(
                              _rangeStart != null
                                  ? formatter.format(_rangeStart!)
                                  : 'Select',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        child: InkWell(
                          onTap: () => _pickRangeDate(false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                            ),
                            child: Text(
                              _rangeEnd != null
                                  ? formatter.format(_rangeEnd!)
                                  : 'Select',
                            ),
                          ),
                        ),
                      ),
                      if (_rangeStart != null || _rangeEnd != null)
                        OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              _rangeStart = null;
                              _rangeEnd = null;
                              _rangeStats = null;
                            });
                          },
                          child: const Text('Clear Range'),
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
                    yearStats: _yearStats,
                    rangeStats: _rangeStats,
                  ),
                ),
              ],
            ),
    );
  }
}
