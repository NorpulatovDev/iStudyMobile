import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/report_bloc.dart';
import '../widgets/report_card.dart';
import '../widgets/date_selector.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  DateTime selectedDate = DateTime.now();
  String reportType = 'daily'; // daily, monthly, range
  String reportCategory = 'financial'; // financial, payments, expenses, salaries
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _loadInitialReport();
  }

  void _loadInitialReport() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user.branchId != null) {
      // Load daily financial summary by default
      _loadDailyFinancialReport(authState.user.branchId!);
    }
  }

  void _loadDailyFinancialReport(int branchId) {
    final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    
    // Load both daily payment and expense reports for financial summary
    context.read<ReportBloc>().add(
      LoadFinancialSummary(
        branchId: branchId,
        year: selectedDate.year,
        month: selectedDate.month,
      ),
    );
  }

  void _onReportParametersChanged() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user.branchId != null) {
      final branchId = authState.user.branchId!;
      
      if (reportType == 'daily') {
        _loadDailyReport(branchId);
      } else if (reportType == 'monthly') {
        _loadMonthlyReport(branchId);
      } else if (reportType == 'range' && startDate != null && endDate != null) {
        _loadRangeReport(branchId);
      }
    }
  }

  void _loadDailyReport(int branchId) {
    final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    
    switch (reportCategory) {
      case 'payments':
        context.read<ReportBloc>().add(LoadDailyPaymentReport(branchId: branchId, date: dateStr));
        break;
      case 'expenses':
        context.read<ReportBloc>().add(LoadDailyExpenseReport(branchId: branchId, date: dateStr));
        break;
      case 'financial':
      default:
        context.read<ReportBloc>().add(LoadFinancialSummary(branchId: branchId, year: selectedDate.year, month: selectedDate.month));
        break;
    }
  }

  void _loadMonthlyReport(int branchId) {
    switch (reportCategory) {
      case 'payments':
        context.read<ReportBloc>().add(LoadMonthlyPaymentReport(branchId: branchId, year: selectedDate.year, month: selectedDate.month));
        break;
      case 'expenses':
        context.read<ReportBloc>().add(LoadMonthlyExpenseReport(branchId: branchId, year: selectedDate.year, month: selectedDate.month));
        break;
      case 'salaries':
        context.read<ReportBloc>().add(LoadMonthlySalaryReport(branchId: branchId, year: selectedDate.year, month: selectedDate.month));
        break;
      case 'financial':
      default:
        context.read<ReportBloc>().add(LoadFinancialSummary(branchId: branchId, year: selectedDate.year, month: selectedDate.month));
        break;
    }
  }

  void _loadRangeReport(int branchId) {
    final startDateStr = '${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}';
    final endDateStr = '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}';
    
    switch (reportCategory) {
      case 'payments':
        context.read<ReportBloc>().add(LoadPaymentRangeReport(branchId: branchId, startDate: startDateStr, endDate: endDateStr));
        break;
      case 'expenses':
        context.read<ReportBloc>().add(LoadExpenseRangeReport(branchId: branchId, startDate: startDateStr, endDate: endDateStr));
        break;
      case 'financial':
      default:
        context.read<ReportBloc>().add(LoadFinancialSummaryRange(branchId: branchId, startDate: startDateStr, endDate: endDateStr));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Reports Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Type Selector
            _buildReportTypeSelector(),
            const SizedBox(height: 16),
            
            // Report Category Selector
            _buildReportCategorySelector(),
            const SizedBox(height: 16),
            
            // Date Selector
            DateSelector(
              reportType: reportType,
              selectedDate: selectedDate,
              startDate: startDate,
              endDate: endDate,
              onDateChanged: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
                _onReportParametersChanged();
              },
              onRangeChanged: (DateTime? start, DateTime? end) {
                setState(() {
                  startDate = start;
                  endDate = end;
                });
                _onReportParametersChanged();
              },
            ),
            
            const SizedBox(height: 24),
            
            // Report Content
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }
                
                if (state is ReportError) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[600],
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading report',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(color: Colors.red[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                if (state is ReportLoaded) {
                  return ReportCard(
                    report: state.report,
                    reportCategory: reportCategory,
                    reportType: reportType,
                  );
                }
                
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Period',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  'Daily',
                  reportType == 'daily',
                  () {
                    setState(() {
                      reportType = 'daily';
                    });
                    _onReportParametersChanged();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToggleButton(
                  'Monthly',
                  reportType == 'monthly',
                  () {
                    setState(() {
                      reportType = 'monthly';
                    });
                    _onReportParametersChanged();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToggleButton(
                  'Range',
                  reportType == 'range',
                  () {
                    setState(() {
                      reportType = 'range';
                    });
                    _onReportParametersChanged();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCategorySelector() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('Financial', 'financial', Icons.account_balance),
              _buildCategoryChip('Payments', 'payments', Icons.payment),
              _buildCategoryChip('Expenses', 'expenses', Icons.receipt),
              if (reportType != 'daily')
                _buildCategoryChip('Salaries', 'salaries', Icons.people),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title, String value, IconData icon) {
    final isSelected = reportCategory == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          reportCategory = value;
        });
        _onReportParametersChanged();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}