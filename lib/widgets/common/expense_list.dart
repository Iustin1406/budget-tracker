import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/expense.dart';

class ExpenseList extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final Future<void> Function(int expenseId)? onDelete;

  const ExpenseList({
    super.key,
    required this.expenses,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy');

    if (expenses.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD8DFDA)),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('No expenses found'),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: expenses.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD8DFDA)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            title: Text(
              expense.category,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${expense.description ?? 'No description'}\n${formatter.format(expense.date)}',
                style: const TextStyle(height: 1.5),
              ),
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${expense.amount.toStringAsFixed(2)} RON',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                if (onDelete != null) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: () async {
                      await onDelete!(expense.id);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}