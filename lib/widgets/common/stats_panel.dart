import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/stats.dart';

class StatsPanel extends StatelessWidget {
  final List<StatsByCategoryModel> categoryStats;
  final List<StatsByDayModel> dayStats;
  final List<StatsByMonthModel> monthStats;

  const StatsPanel({
    super.key,
    required this.categoryStats,
    required this.dayStats,
    required this.monthStats,
  });

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8DFDA)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8DFDA)),
      ),
      child: const Text('No data available'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('By Category'),
        if (categoryStats.isEmpty)
          _empty()
        else
          ...categoryStats.map(
            (item) => _row(
              item.category,
              '${item.total.toStringAsFixed(2)} RON',
            ),
          ),
        const SizedBox(height: 18),
        _sectionTitle('By Day'),
        if (dayStats.isEmpty)
          _empty()
        else
          ...dayStats.take(6).map(
            (item) => _row(
              formatter.format(item.date),
              '${item.total.toStringAsFixed(2)} RON',
            ),
          ),
        const SizedBox(height: 18),
        _sectionTitle('By Month'),
        if (monthStats.isEmpty)
          _empty()
        else
          ...monthStats.map(
            (item) => _row(
              '${item.month}/${item.year}',
              '${item.total.toStringAsFixed(2)} RON',
            ),
          ),
      ],
    );
  }
}