import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  final List<String> categories;
  final Future<void> Function({
    required double amount,
    required String category,
    required String date,
    String? description,
  }) onSubmit;

  const ExpenseForm({
    super.key,
    required this.categories,
    required this.onSubmit,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSubmit(
        amount: double.parse(_amountController.text),
        category: _selectedCategory!,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      _amountController.clear();
      _descriptionController.clear();

      setState(() {
        _selectedCategory = null;
        _selectedDate = DateTime.now();
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add expense')),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'e.g. 45.5',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Amount is required';
              }

              final parsed = double.tryParse(value);
              if (parsed == null || parsed <= 0) {
                return 'Enter a valid amount';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: widget.categories.contains(_selectedCategory)
                ? _selectedCategory
                : null,
            decoration: const InputDecoration(labelText: 'Category'),
            hint: const Text('Select category'),
            items: widget.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: widget.categories.isEmpty
                ? null
                : (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Optional',
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD8DFDA)),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: $formattedDate',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Pick'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed:
                  _isLoading || widget.categories.isEmpty ? null : _submit,
              child: Text(
                _isLoading
                    ? 'Saving...'
                    : widget.categories.isEmpty
                        ? 'No categories available'
                        : 'Add expense',
              ),
            ),
          ),
        ],
      ),
    );
  }
}