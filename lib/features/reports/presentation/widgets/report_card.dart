import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final String reportCategory;
  final String reportType;

  const ReportCard({
    super.key, 
    required this.report,
    required this.reportCategory,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Card
        _buildSummaryCard(),
        const SizedBox(height: 20),
        
        // Detailed Breakdown based on category
        if (reportCategory == 'financial') ...[
          _buildFinancialBreakdown(),
        ] else if (reportCategory == 'payments') ...[
          _buildPaymentsBreakdown(),
        ] else if (reportCategory == 'expenses') ...[
          _buildExpensesBreakdown(),
        ] else if (reportCategory == 'salaries') ...[
          _buildSalariesBreakdown(),
        ],
      ],
    );
  }

  Widget _buildSummaryCard() {
    String mainTitle;
    double mainValue;
    Color mainColor;
    IconData mainIcon;

    switch (reportCategory) {
      case 'payments':
        mainTitle = 'Total Revenue';
        mainValue = report.totalPayments;
        mainColor = Colors.green;
        mainIcon = Icons.trending_up;
        break;
      case 'expenses':
        mainTitle = 'Total Expenses';
        mainValue = report.totalExpenses;
        mainColor = Colors.red;
        mainIcon = Icons.trending_down;
        break;
      case 'salaries':
        mainTitle = 'Total Salaries';
        mainValue = report.totalSalaries;
        mainColor = Colors.orange;
        mainIcon = Icons.people;
        break;
      case 'financial':
      default:
        mainTitle = 'Net Profit';
        mainValue = report.netProfit;
        mainColor = report.netProfit >= 0 ? Colors.green : Colors.red;
        mainIcon = report.netProfit >= 0 ? Icons.trending_up : Icons.trending_down;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mainColor, mainColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(mainIcon, color: Colors.white70, size: 32),
          const SizedBox(height: 8),
          Text(
            mainTitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\${mainValue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getPeriodText(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdown() {
    return Column(
      children: [
        _buildDetailCard('Revenue', report.totalPayments, Icons.attach_money, Colors.green),
        const SizedBox(height: 12),
        _buildDetailCard('Expenses', report.totalExpenses, Icons.shopping_cart, Colors.red),
        const SizedBox(height: 12),
        _buildDetailCard('Salaries', report.totalSalaries, Icons.people, Colors.orange),
        const SizedBox(height: 12),
        _buildDetailCard('Total Costs', report.totalCosts, Icons.calculate, Colors.purple),
      ],
    );
  }

  Widget _buildPaymentsBreakdown() {
    return Column(
      children: [
        _buildDetailCard('Total Revenue', report.totalPayments, Icons.attach_money, Colors.green),
        const SizedBox(height: 12),
        _buildInfoCard('Report Period', _getPeriodText(), Icons.calendar_today),
      ],
    );
  }

  Widget _buildExpensesBreakdown() {
    return Column(
      children: [
        _buildDetailCard('Total Expenses', report.totalExpenses, Icons.shopping_cart, Colors.red),
        const SizedBox(height: 12),
        _buildInfoCard('Report Period', _getPeriodText(), Icons.calendar_today),
      ],
    );
  }

  Widget _buildSalariesBreakdown() {
    return Column(
      children: [
        _buildDetailCard('Total Salaries', report.totalSalaries, Icons.people, Colors.orange),
        const SizedBox(height: 12),
        _buildInfoCard('Report Period', _getPeriodText(), Icons.calendar_today),
      ],
    );
  }

  Widget _buildDetailCard(String title, double amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPeriodText() {
    if (report.date != null) {
      return 'Daily Report - ${report.date}';
    } else if (report.year != null && report.month != null) {
      return 'Monthly Report - ${_getMonthName(report.month!)} ${report.year}';
    } else if (report.startDate != null && report.endDate != null) {
      return 'Range Report - ${report.startDate} to ${report.endDate}';
    }
    return reportType.toUpperCase() + ' Report';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}