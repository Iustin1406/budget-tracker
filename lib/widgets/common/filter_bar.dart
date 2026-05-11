import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterBar extends StatelessWidget {
  final String? selectedCategory;
  final int? selectedMonth;
  final int? selectedYear;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;
  final VoidCallback onClear;

  final String? selectedSortBy;
  final String? selectedSortOrder;
  final ValueChanged<String?>? onSortByChanged;
  final ValueChanged<String?>? onSortOrderChanged;

  final DateTime? selectedDate;
  final ValueChanged<DateTime?>? onDateChanged;

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
    this.selectedSortBy,
    this.selectedSortOrder,
    this.onSortByChanged,
    this.onSortOrderChanged,
    this.selectedDate,
    this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (index) => index + 1);
    final years = [2024, 2025, 2026, 2027];
    final formatter = DateFormat('dd MMM yyyy');

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
        if (onDateChanged != null)
          SizedBox(
            width: 180,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2028),
                );
                onDateChanged!(picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Date'),
                child: Text(
                  selectedDate != null
                      ? formatter.format(selectedDate!)
                      : 'All',
                ),
              ),
            ),
          ),
        if (onSortByChanged != null)
          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String>(
              initialValue: selectedSortBy ?? 'date',
              decoration: const InputDecoration(labelText: 'Sort by'),
              items: const [
                DropdownMenuItem(value: 'date', child: Text('Date')),
                DropdownMenuItem(value: 'amount', child: Text('Amount')),
                DropdownMenuItem(value: 'category', child: Text('Category')),
              ],
              onChanged: onSortByChanged,
            ),
          ),
        if (onSortOrderChanged != null)
          IconButton(
            icon: Icon(
              selectedSortOrder == 'asc'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
            ),
            tooltip: selectedSortOrder == 'asc' ? 'Ascending' : 'Descending',
            onPressed: () {
              onSortOrderChanged!(
                selectedSortOrder == 'asc' ? 'desc' : 'asc',
              );
            },
          ),
        OutlinedButton(
          onPressed: onClear,
          child: const Text('Clear'),
        ),
      ],
    );
  }
}
