import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import './action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            ActionCard(
              title: 'Manage Branches',
              icon: Icons.business,
              color: AppTheme.primaryColor,
              onTap: () {
                // TODO: Navigate to branches page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon: Manage Branches')),
                );
              },
            ),
            ActionCard(
              title: 'Manage Users',
              icon: Icons.people,
              color: AppTheme.successColor,
              onTap: () {
                // TODO: Navigate to users page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon: Manage Users')),
                );
              },
            ),
            ActionCard(
              title: 'Reports',
              icon: Icons.analytics,
              color: Colors.orange,
              onTap: () {
                // TODO: Navigate to reports page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon: Reports')),
                );
              },
            ),
            ActionCard(
              title: 'Settings',
              icon: Icons.settings,
              color: Colors.purple,
              onTap: () {
                // TODO: Navigate to settings page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon: Settings')),
                );
              },
            ),
            ActionCard(
              title: 'Backup',
              icon: Icons.backup,
              color: Colors.teal,
              onTap: () {
                // TODO: Navigate to backup page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon: Backup')),
                );
              },
            ),
            ActionCard(
              title: 'Support',
              icon: Icons.support,
              color: Colors.indigo,
              onTap: () {
                // TODO: Navigate to support page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon: Support')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}