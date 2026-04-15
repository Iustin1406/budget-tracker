import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/mobile/mobile_shell_screen.dart';
import 'screens/web/web_dashboard_screen.dart';

void main() {
  runApp(const BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return const WebDashboardScreen();
          }

          return const MobileShellScreen();
        },
      ),
    );
  }
}