import 'package:flutter/material.dart';

import 'mobile_add_expense_screen.dart';
import 'mobile_expenses_screen.dart';
import 'mobile_stats_screen.dart';

class MobileShellScreen extends StatefulWidget {
  const MobileShellScreen({super.key});

  @override
  State<MobileShellScreen> createState() => _MobileShellScreenState();
}

class _MobileShellScreenState extends State<MobileShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const MobileExpensesScreen(),
      const MobileAddExpenseScreen(),
      const MobileStatsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}