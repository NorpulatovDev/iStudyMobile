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
    String subtitle;

    switch (reportCategory) {
      case 'payments':
        mainTitle = 'Total Revenue';
        mainValue = report.safePayments;
        mainColor = Colors.green;
        mainIcon = Icons.trending_up;
        subtitle = 'Income from payments';
        break;
      case 'expenses':
        mainTitle = 'Total Expenses';
        mainValue = report.safeExpenses;
        mainColor = Colors.red;
        mainIcon = Icons.trending_down;
        subtitle = 'Operating expenses';
        break;
      case 'salaries':
        mainTitle = 'Total Salaries';
        mainValue = report.safeSalaries;
        mainColor = Colors.orange;
        mainIcon = Icons.people;
        subtitle = 'Staff compensation';
        break;
      case 'financial':
      default:
        mainTitle = 'Net Profit';
        mainValue = report.safeNetProfit;
        mainColor = report.safeNetProfit >= 0 ? Colors.green : Colors.red;
        mainIcon = report.safeNetProfit >= 0 ? Icons.trending_up : Icons.trending_down;
        subtitle = report.safeNetProfit >= 0 ? 'Profitable period' : 'Loss period';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mainColor, mainColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
          Icon(mainIcon, color: Colors.white70, size: 40),
          const SizedBox(height: 12),
          Text(
            mainTitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_formatAmount(mainValue)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getPeriodText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdown() {
    final profitMargin = report.safePayments > 0 
        ? (report.safeNetProfit / report.safePayments * 100) 
        : 0.0;
    
    return Column(
      children: [
        // Financial Overview
        _buildOverviewCard(),
        const SizedBox(height: 16),
        
        // Key Metrics
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Profit Margin', 
                '${profitMargin.toStringAsFixed(1)}%',
                profitMargin >= 0 ? Icons.trending_up : Icons.trending_down,
                profitMargin >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Cost Ratio', 
                '${report.safePayments > 0 ? (report.safeCosts / report.safePayments * 100).toStringAsFixed(1) : 0}%',
                Icons.pie_chart,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Detailed breakdown
        _buildDetailCard('Revenue', report.safePayments, Icons.attach_money, Colors.green),
        const SizedBox(height: 12),
        _buildDetailCard('Expenses', report.safeExpenses, Icons.shopping_cart, Colors.red),
        const SizedBox(height: 12),
        _buildDetailCard('Salaries', report.safeSalaries, Icons.people, Colors.orange),
        const SizedBox(height: 12),
        _buildDetailCard('Total Costs', report.safeCosts, Icons.calculate, Colors.purple),
      ],
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Financial Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'This ${reportType} report shows your branch\'s financial performance. '
            '${report.netProfit! >= 0 ? "Your branch is profitable" : "Your branch has losses"} '
            'with a net ${report.netProfit! >= 0 ? "profit" : "loss"} of \$${_formatAmount(report.netProfit!.abs())}.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsBreakdown() {
    return Column(
      children: [
        _buildSummaryInfoCard(
          'Payment Summary',
          'Total revenue collected during this period',
          Icons.payment,
        ),
        const SizedBox(height: 16),
        _buildDetailCard('Total Revenue', report.safePayments, Icons.attach_money, Colors.green),
        const SizedBox(height: 12),
        _buildInfoCard('Report Period', _getPeriodText(), Icons.calendar_today),
        const SizedBox(height: 12),
        _buildInfoCard('Branch ID', 'Branch #${report.branchId}', Icons.location_on),
      ],
    );
  }

  Widget _buildExpensesBreakdown() {
    return Column(
      children: [
        _buildSummaryInfoCard(
          'Expense Summary',
          'Total expenses incurred during this period',
          Icons.receipt,
        ),
        const SizedBox(height: 16),
        _buildDetailCard('Total Expenses', report.safeExpenses, Icons.shopping_cart, Colors.red),
        const SizedBox(height: 12),
        _buildInfoCard('Report Period', _getPeriodText(), Icons.calendar_today),
        const SizedBox(height: 12),
        _buildInfoCard('Branch ID', 'Branch #${report.branchId}', Icons.location_on),
      ],
    );
  }

  Widget _buildSalariesBreakdown() {
    return Column(
      children: [
        _buildSummaryInfoCard(
          'Salary Summary',
          'Total staff compensation for this period',
          Icons.people,
        ),
        const SizedBox(height: 16),
        _buildDetailCard('Total Salaries', report.safeSalaries, Icons.people, Colors.orange),
        const SizedBox(height: 12),
        _buildInfoCard('Report Period', _getPeriodText(), Icons.calendar_today),
        const SizedBox(height: 12),
        _buildInfoCard('Branch ID', 'Branch #${report.branchId}', Icons.location_on),
      ],
    );
  }

  Widget _buildSummaryInfoCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                  '\$${_formatAmount(amount)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              reportType.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
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

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(2);
    }
  }

  String _getPeriodText() {
    if (report.date != null) {
      return 'Daily Report - ${report.date}';
    } else if (report.year != null && report.month != null) {
      return 'Monthly Report - ${_getMonthName(report.month!)} ${report.year}';
    } else if (report.startDate != null && report.endDate != null) {
      return 'Range Report - ${report.startDate} to ${report.endDate}';
    }
    return '${reportType.toUpperCase()} Report';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}