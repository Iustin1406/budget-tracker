import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final String? selectedCategory;
  final int? selectedMonth;
  final int? selectedYear;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;
  final VoidCallback onClear;

  const FilterBar({
    super.key,
    required this.selectedCategory,
    required this.selectedMonth,
    required this.selectedYear,
    required this.categories,
    required this.onCategoryChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (index) => index + 1);
    final years = [2024, 2025, 2026, 2027];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All'),
              ),
              ...categories.map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              ),
            ],
            onChanged: onCategoryChanged,
          ),
        ),
        SizedBox(
          width: 140,
          child: DropdownButtonFormField<int>(
            initialValue: selectedMonth,
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
            onChanged: onMonthChanged,
          ),
        ),
        SizedBox(
          width: 140,
          child: DropdownButtonFormField<int>(
            initialValue: selectedYear,
            decoration: const InputDecoration(labelText: 'Year'),
            items: [
              const DropdownMenuItem<int>(
                value: null,
                child: Text('All'),
              ),
              ...years.map(
                (year) => DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
              ),
            ],
            onChanged: onYearChanged,
          ),
        ),
        OutlinedButton(
          onPressed: onClear,
          child: const Text('Clear'),
        ),
      ],
    );
  }
}