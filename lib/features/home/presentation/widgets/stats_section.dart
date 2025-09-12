import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import './stats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: const [
            StatCard(
              title: 'Total Branches',
              value: '12',
              icon: Icons.business,
              color: AppTheme.primaryColor,
            ),
            StatCard(
              title: 'Total Users',
              value: '48',
              icon: Icons.people,
              color: AppTheme.successColor,
            ),
            StatCard(
              title: 'Active Students',
              value: '1,234',
              icon: Icons.school,
              color: Colors.orange,
            ),
            StatCard(
              title: 'Monthly Revenue',
              value: '\$45,678',
              icon: Icons.attach_money,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}
