import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../branches/presentation/bloc/branch_bloc.dart';
import '../../../branches/data/models/branch_model.dart';
import '../../../branches/presentation/widgets/branch_selector.dart';
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
  String reportType = 'daily';
  String reportCategory = 'payments';
  DateTime? startDate;
  DateTime? endDate;
  BranchModel? selectedBranch;

  @override
  void initState() {
    super.initState();
    _checkUserAndLoadBranches();
  }

  void _checkUserAndLoadBranches() {
    final authState = context.read<AuthBloc>().state;
    print('=== Checking user authentication ===');
    
    if (authState is AuthAuthenticated) {
      print('User: ${authState.user.username}');
      print('Role: ${authState.user.role}');
      print('User Branch ID: ${authState.user.branchId}');
      
      if (authState.user.branchId != null) {
        // User has a specific branch assigned
        print('User has assigned branch, skipping branch selection');
        // We could create a BranchModel from user data, but for now let's load branches anyway
      }
      
      // Load available branches for SUPER_ADMIN
      print('Loading branches for selection...');
      context.read<BranchBloc>().add(LoadBranches());
    } else {
      print('ERROR: User not authenticated');
    }
  }

  void _onBranchSelected(BranchModel branch) {
    print('=== Branch selected in Reports Page ===');
    print('Branch ID: ${branch.id}');
    print('Branch Name: ${branch.name}');
    
    setState(() {
      selectedBranch = branch;
    });
    
    // Auto-load initial report for selected branch
    _loadReport(branch.id);
  }

  void _onReportParametersChanged() {
    print('=== Report parameters changed ===');
    print('Report Type: $reportType');
    print('Report Category: $reportCategory');
    print('Selected Date: $selectedDate');
    print('Selected Branch: ${selectedBranch?.name ?? "None"}');
    
    if (selectedBranch != null) {
      _loadReport(selectedBranch!.id);
    } else {
      print('No branch selected, cannot load report');
    }
  }

  void _loadReport(int branchId) {
    print('=== Loading report for branch $branchId ===');
    
    if (reportType == 'daily') {
      _loadDailyReport(branchId);
    } else if (reportType == 'monthly') {
      _loadMonthlyReport(branchId);
    } else if (reportType == 'range' && startDate != null && endDate != null) {
      _loadRangeReport(branchId);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _loadDailyReport(int branchId) {
    final dateStr = _formatDate(selectedDate);
    print('Loading daily $reportCategory report for branch $branchId on $dateStr');
    
    switch (reportCategory) {
      case 'payments':
        context.read<ReportBloc>().add(LoadDailyPaymentReport(branchId: branchId, date: dateStr));
        break;
      case 'expenses':
        context.read<ReportBloc>().add(LoadDailyExpenseReport(branchId: branchId, date: dateStr));
        break;
      case 'financial':
      default:
        context.read<ReportBloc>().add(LoadDailyPaymentReport(branchId: branchId, date: dateStr));
        break;
    }
  }

  void _loadMonthlyReport(int branchId) {
    print('Loading monthly $reportCategory report for branch $branchId');
    
    switch (reportCategory) {
      case 'payments':
        context.read<ReportBloc>().add(LoadMonthlyPaymentReport(
          branchId: branchId, 
          year: selectedDate.year, 
          month: selectedDate.month
        ));
        break;
      case 'expenses':
        context.read<ReportBloc>().add(LoadMonthlyExpenseReport(
          branchId: branchId, 
          year: selectedDate.year, 
          month: selectedDate.month
        ));
        break;
      case 'salaries':
        context.read<ReportBloc>().add(LoadMonthlySalaryReport(
          branchId: branchId, 
          year: selectedDate.year, 
          month: selectedDate.month
        ));
        break;
      case 'financial':
      default:
        context.read<ReportBloc>().add(LoadFinancialSummary(
          branchId: branchId, 
          year: selectedDate.year, 
          month: selectedDate.month
        ));
        break;
    }
  }

  void _loadRangeReport(int branchId) {
    final startDateStr = _formatDate(startDate!);
    final endDateStr = _formatDate(endDate!);
    print('Loading range $reportCategory report for branch $branchId');
    
    switch (reportCategory) {
      case 'payments':
        context.read<ReportBloc>().add(LoadPaymentRangeReport(
          branchId: branchId, 
          startDate: startDateStr, 
          endDate: endDateStr
        ));
        break;
      case 'expenses':
        context.read<ReportBloc>().add(LoadExpenseRangeReport(
          branchId: branchId, 
          startDate: startDateStr, 
          endDate: endDateStr
        ));
        break;
      case 'financial':
      default:
        context.read<ReportBloc>().add(LoadFinancialSummaryRange(
          branchId: branchId, 
          startDate: startDateStr, 
          endDate: endDateStr
        ));
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
          // Show selected branch
          if (selectedBranch != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    selectedBranch!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
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
            // Branch Selection - Wrapped in BlocBuilder to rebuild on state changes
            BlocBuilder<BranchBloc, BranchState>(
              builder: (context, branchState) {
                return BranchSelector(
                  onBranchSelected: _onBranchSelected,
                  // Pass current selection state to help with UI updates
                  currentSelectedBranch: branchState is BranchSelected ? branchState.selectedBranch : null,
                );
              },
            ),
            
            // Show report controls only if branch is selected
            if (selectedBranch != null) ...[
              const SizedBox(height: 24),
              
              // Current Selection Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Viewing: ${reportCategory.toUpperCase()} - ${reportType.toUpperCase()} - ${_getCurrentSelectionText()}',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
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
                  if (start != null && end != null) {
                    _onReportParametersChanged();
                  }
                },
              ),
              
              const SizedBox(height: 24),
              
              // Manual Refresh Button
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onReportParametersChanged,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Report Content
              BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is ReportLoading) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading report for ${selectedBranch!.name}...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _onReportParametersChanged,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
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
                  
                  // Initial state - show instruction
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            color: Colors.blue[600],
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ready to load reports',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select report parameters and click refresh to view data for ${selectedBranch!.name}',
                            style: TextStyle(color: Colors.blue[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _onReportParametersChanged,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Load Report'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              // Show message when no branch is selected
              const SizedBox(height: 24),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.business_outlined,
                        color: Colors.orange[600],
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select a Branch',
                        style: TextStyle(
                          color: Colors.orange[600],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please select a branch from the list above to view reports',
                        style: TextStyle(color: Colors.orange[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getCurrentSelectionText() {
    if (reportType == 'daily') {
      return _formatDate(selectedDate);
    } else if (reportType == 'monthly') {
      return '${selectedDate.month}/${selectedDate.year}';
    } else if (reportType == 'range' && startDate != null && endDate != null) {
      return '${_formatDate(startDate!)} to ${_formatDate(endDate!)}';
    }
    return 'No date selected';
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
                      if (reportCategory == 'financial') {
                        reportCategory = 'payments';
                      }
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
              if (reportType != 'daily')
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