part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

// Payment Report Events
class LoadDailyPaymentReport extends ReportEvent {
  final int branchId;
  final String date;

  const LoadDailyPaymentReport({
    required this.branchId,
    required this.date,
  });

  @override
  List<Object> get props => [branchId, date];
}

class LoadMonthlyPaymentReport extends ReportEvent {
  final int branchId;
  final int year;
  final int month;

  const LoadMonthlyPaymentReport({
    required this.branchId,
    required this.year,
    required this.month,
  });

  @override
  List<Object> get props => [branchId, year, month];
}

class LoadPaymentRangeReport extends ReportEvent {
  final int branchId;
  final String startDate;
  final String endDate;

  const LoadPaymentRangeReport({
    required this.branchId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [branchId, startDate, endDate];
}

// Expense Report Events
class LoadDailyExpenseReport extends ReportEvent {
  final int branchId;
  final String date;

  const LoadDailyExpenseReport({
    required this.branchId,
    required this.date,
  });

  @override
  List<Object> get props => [branchId, date];
}

class LoadMonthlyExpenseReport extends ReportEvent {
  final int branchId;
  final int year;
  final int month;

  const LoadMonthlyExpenseReport({
    required this.branchId,
    required this.year,
    required this.month,
  });

  @override
  List<Object> get props => [branchId, year, month];
}

class LoadExpenseRangeReport extends ReportEvent {
  final int branchId;
  final String startDate;
  final String endDate;

  const LoadExpenseRangeReport({
    required this.branchId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [branchId, startDate, endDate];
}

// Salary Report Events
class LoadMonthlySalaryReport extends ReportEvent {
  final int branchId;
  final int year;
  final int month;

  const LoadMonthlySalaryReport({
    required this.branchId,
    required this.year,
    required this.month,
  });

  @override
  List<Object> get props => [branchId, year, month];
}

// Financial Summary Events
class LoadFinancialSummary extends ReportEvent {
  final int branchId;
  final int year;
  final int month;

  const LoadFinancialSummary({
    required this.branchId,
    required this.year,
    required this.month,
  });

  @override
  List<Object> get props => [branchId, year, month];
}

class LoadFinancialSummaryRange extends ReportEvent {
  final int branchId;
  final String startDate;
  final String endDate;

  const LoadFinancialSummaryRange({
    required this.branchId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [branchId, startDate, endDate];
}